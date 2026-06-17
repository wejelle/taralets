import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants/colors.dart';
import 'screens/dashboard_screen.dart';
import 'screens/invite_screen.dart';
import 'screens/discover_screen.dart';
import 'screens/timeline_screen.dart';
import 'screens/initialization_screen.dart';

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
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    InviteScreen(),
    DiscoverScreen(),
    TimelineScreen(),
    InitializationScreen(),
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
