import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants/colors.dart';
import 'screens/dashboard_screen.dart';
import 'screens/invite_screen.dart';
import 'screens/discover_screen.dart';
import 'screens/timeline_screen.dart';
import 'screens/initialization_screen.dart';
import 'screens/profile_screen.dart';

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
        textTheme: GoogleFonts.plusJakartaSansTextTheme(), 
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.charcoal,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: GoogleFonts.plusJakartaSans(
            color: AppColors.charcoal,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  final String tripName;
  final String location;
  final TimeOfDay? targetTime;

  const MainShell({
    super.key,
    this.tripName = 'Taralets!',
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
  bool _hasActiveTrip = true;

  late final TimeOfDay _safeTargetTime;

  @override
  void initState() {
    super.initState();
    _safeTargetTime = widget.targetTime ?? const TimeOfDay(hour: 18, minute: 0);
  }

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
            ? 'You are now on your way! 🚗'
            // ── Pinalitan ang "Pending" ng mas akmang mensahe ──
            : 'Travel status canceled. You are back on standby.'), 
        backgroundColor: _isReady ? AppColors.teal : AppColors.captionText, // Iba na rin ang kulay pag cancel
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
          targetTime: _safeTargetTime,
          reportedDelayMinutes: _reportedDelayMinutes,
          isReady: _isReady,
          hasActiveTrip: _hasActiveTrip,
          onAddDelay: _addDelay,
          onToggleReady: _toggleReady,
        ),
        const InviteScreen(),
        const InitializationScreen(), 
        const DiscoverScreen(),       
        TimelineScreen(
          tripName: widget.tripName,
          location: widget.location,
          targetTime: _safeTargetTime,
          reportedDelayMinutes: _reportedDelayMinutes,
        ),
        const ProfileScreen(),
      ];

  void _onTap(int index) => setState(() => _currentIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      extendBody: true, 
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 66, // Standard height para sa navigation bar
          margin: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(34),
            boxShadow: [
              BoxShadow(
                color: AppColors.charcoal.withOpacity(0.08),
                blurRadius: 24,
                offset: const Offset(0, 10),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _NavBarIcon(
                icon: Icons.home_rounded,
                isSelected: _currentIndex == 0,
                onTap: () => _onTap(0),
              ),
              _NavBarIcon(
                icon: Icons.group_add_rounded,
                isSelected: _currentIndex == 1,
                onTap: () => _onTap(1),
              ),
              _NavBarIcon(
                icon: Icons.add_location_alt_rounded,
                isSelected: _currentIndex == 2,
                onTap: () => _onTap(2),
              ),
              _NavBarIcon(
                icon: Icons.map_rounded,
                isSelected: _currentIndex == 3,
                onTap: () => _onTap(3),
              ),
              _NavBarIcon(
                icon: Icons.timeline_rounded,
                isSelected: _currentIndex == 4,
                onTap: () => _onTap(4),
              ),
              _NavBarIcon(
                icon: Icons.person_rounded,
                isSelected: _currentIndex == 5,
                onTap: () => _onTap(5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavBarIcon extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarIcon({
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        // Binawasan natin ng kaunti ang horizontal padding para magkasya ang 6 icons nang maayos
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Icon(
          icon,
          color: isSelected ? AppColors.primary : AppColors.captionText.withOpacity(0.6),
          size: 26, 
        ),
      ),
    );
  }
}