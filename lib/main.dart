import 'dart:ui';
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
      // BAGO: Diretso na agad sa MainShell imbes na LoginScreen
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

  // BAGO: Indicator kung may active group trip (Para ma-hide/show ang map)
  bool _hasActiveTrip = true;

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
          hasActiveTrip: _hasActiveTrip, // Ipapasa natin yung status
          onAddDelay: _addDelay,
          onToggleReady: _toggleReady,
        ),
        const InviteScreen(),
        const InitializationScreen(), // Index 2: Ito na yung Core/Pin Screen natin
        const DiscoverScreen(),
        TimelineScreen(
          tripName: widget.tripName,
          location: widget.location,
          targetTime: widget.targetTime,
          reportedDelayMinutes: _reportedDelayMinutes,
        ),
        const ProfileScreen(),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Aesthetic Pattern (Faint Gradient + Circles)
          Positioned.fill(
            child: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
              colors: [
                Color(0xFFFFEAEE), // Faint Hot Pink
                Color(0xFFFFF2E6), // Faint Peach
                Color(0xFFFFF9F2), // Faint Soft Orange
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ))),
          ),
          Positioned(
            top: -50,
            right: -30,
            child: CircleAvatar(
                radius: 130,
                backgroundColor: Colors.white.withOpacity(
                    0.35)), // 👈 'backgroundColor' imbes na 'color'
          ),
          Positioned(
            bottom: 100,
            left: -60,
            child: CircleAvatar(
                radius: 110,
                backgroundColor: AppColors.primaryLight.withOpacity(
                    0.25)), // 👈 'backgroundColor' imbes na 'color'
          ),

          Positioned.fill(
            child: IndexedStack(index: _currentIndex, children: _screens),
          ),
        ],
      ),
      extendBody:
          true, // Para lumusot yung content sa ilalim ng transparent nav
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.charcoal.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          child: BackdropFilter(
            // BAGO: Glassmorphism effect para malinis tingnan
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              color: Colors.white.withOpacity(0.75),
              child: SafeArea(
                child: SizedBox(
                  height: 72,
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      Row(
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
                          const SizedBox(
                              width: 68), // Spacer para sa center button
                          _NavItem(
                              icon: Icons.explore_outlined,
                              label: 'Discover',
                              index: 3,
                              current: _currentIndex,
                              onTap: _onTap),
                          _NavItem(
                              icon: Icons.timeline_outlined,
                              label: 'Timeline',
                              index: 4,
                              current: _currentIndex,
                              onTap: _onTap),
                          _NavItem(
                              icon: Icons.person_outline_rounded,
                              label: 'Profile',
                              index: 5,
                              current: _currentIndex,
                              onTap: _onTap),
                        ],
                      ),

                      // BAGO: Elevated Core Button sa Gitna
                      Positioned(
                        top: -16,
                        child: _CenterCoreButton(
                          currentIndex: _currentIndex,
                          targetIndex: 2,
                          onTap: _onTap,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTap(int index) => setState(() => _currentIndex = index);
}

// ── CUSTOM CENTER STANDOUT BUTTON COMPONENT ──
class _CenterCoreButton extends StatefulWidget {
  final int currentIndex;
  final int targetIndex;
  final Function(int) onTap;

  const _CenterCoreButton(
      {required this.currentIndex,
      required this.targetIndex,
      required this.onTap});

  @override
  State<_CenterCoreButton> createState() => _CenterCoreButtonState();
}

class _CenterCoreButtonState extends State<_CenterCoreButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final bool isSelected = widget.currentIndex == widget.targetIndex;
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => widget.onTap(widget.targetIndex),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()..scale(_isHovered ? 1.08 : 1.0),
          height: 64,
          width: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [AppColors.primary, Color(0xFFFF8A7A)], // Pink to Peach
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.35),
                blurRadius: _isHovered ? 16 : 10,
                offset: const Offset(0, 6),
              ),
            ],
            border: Border.all(color: Colors.white, width: 3),
          ),
          child: Icon(
            Icons.add_location_alt_rounded,
            color: Colors.white,
            size: isSelected ? 30 : 26,
          ),
        ),
      ),
    );
  }
}

// ── NAV ITEM COMPONENT WITH MICRO-INTERACTION ──
class _NavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final int index;
  final int current;
  final void Function(int) onTap;

  const _NavItem(
      {required this.icon,
      required this.label,
      required this.index,
      required this.current,
      required this.onTap});

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    final bool active = widget.index == widget.current;
    return GestureDetector(
      onTapDown: (_) => setState(() => _isTapped = true),
      onTapUp: (_) => setState(() => _isTapped = false),
      onTapCancel: () => setState(() => _isTapped = false),
      onTap: () => widget.onTap(widget.index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: Matrix4.identity()..scale(_isTapped ? 0.92 : 1.0),
        child: SizedBox(
          width: 52,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: active
                      ? AppColors.primary.withOpacity(0.08)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  widget.icon,
                  size: 22,
                  color: active
                      ? AppColors.primary
                      : AppColors.charcoal.withOpacity(0.4),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: active ? FontWeight.w800 : FontWeight.w500,
                  color: active
                      ? AppColors.primary
                      : AppColors.charcoal.withOpacity(0.5),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
