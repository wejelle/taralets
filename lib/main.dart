import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants/colors.dart';
import 'screens/dashboard_screen.dart';
import 'screens/invite_screen.dart';
import 'screens/discover_screen.dart';
import 'screens/timeline_screen.dart';
import 'screens/initialization_screen.dart';
import 'screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const TaraletsApp());
}

class TaraletsApp extends StatelessWidget {
  const TaraletsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taralets!',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          background: AppColors.background,
        ),
        scaffoldBackgroundColor: AppColors.background,
        textTheme: GoogleFonts.interTextTheme(),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.charcoal,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: GoogleFonts.inter(
            color: AppColors.charcoal,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

class MainShell extends StatefulWidget {
  final String tripName;
  final String location;
  final TimeOfDay? targetTime;

  const MainShell({
    super.key,
    this.tripName = 'Taralets! 🎉',
    this.location = 'Eastwood City Mall',
    this.targetTime,
  });
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  int _reportedDelayMinutes = 0;
  bool _isReady = false;

  void _addDelay(int minutes) {
    setState(() {
      _reportedDelayMinutes += minutes;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Schedule Adjusted! Added $minutes mins. 🚦'),
        backgroundColor: AppColors.urgent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _toggleReady() {
    setState(() {
      _isReady = !_isReady;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isReady
            ? 'You are marked as Ready! 🎉'
            : 'Status set to Pending.'),
        backgroundColor: AppColors.teal,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  List<Widget> get _screens => [
        DashboardScreen(
          tripName: widget.tripName,
          location: widget.location,
          targetTime: widget.targetTime,
          reportedDelayMinutes: _reportedDelayMinutes,
          isReady: _isReady,
          onAddDelay: _addDelay,
          onToggleReady: _toggleReady,
        ),
        const InviteScreen(),
        const DiscoverScreen(),
        TimelineScreen(
          tripName: widget.tripName,
          location: widget.location,
          targetTime: widget.targetTime,
          reportedDelayMinutes: _reportedDelayMinutes,
        ),
        const InitializationScreen(),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.charcoal.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 64,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                    icon: Icons.map_outlined,
                    label: 'Map',
                    index: 0,
                    current: _currentIndex,
                    onTap: _onTap),
                _NavItem(
                    icon: Icons.group_add_outlined,
                    label: 'Invite',
                    index: 1,
                    current: _currentIndex,
                    onTap: _onTap),
                _NavItem(
                    icon: Icons.explore_outlined,
                    label: 'Discover',
                    index: 2,
                    current: _currentIndex,
                    onTap: _onTap),
                _NavItem(
                    icon: Icons.timeline_outlined,
                    label: 'Timeline',
                    index: 3,
                    current: _currentIndex,
                    onTap: _onTap),
                _NavItem(
                    icon: Icons.add_location_alt_outlined,
                    label: 'Pin',
                    index: 4,
                    current: _currentIndex,
                    onTap: _onTap),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTap(int index) => setState(() => _currentIndex = index);
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int current;
  final void Function(int) onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool active = index == current;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: active
                    ? AppColors.primary.withOpacity(0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 22,
                color: active
                    ? AppColors.primary
                    : AppColors.charcoal.withOpacity(0.4),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                color: active
                    ? AppColors.primary
                    : AppColors.charcoal.withOpacity(0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
