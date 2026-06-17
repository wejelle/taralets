import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _handleLogout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  void _navTo(Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // BAGO: Transparent na para lumusot yung global background ng MainShell
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
              24, 20, 24, 100), // Bottom padding for Nav Bar
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // ── USER AVATAR & INFO ──
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.5),
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.primary.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10))
                      ],
                    ),
                    child: const CircleAvatar(
                      radius: 55,
                      backgroundColor: Color(0xFFF3F4F6),
                      backgroundImage: NetworkImage(
                          'https://api.dicebear.com/7.x/lorelei/png?seed=Jewelle&backgroundColor=ff6397'),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3)),
                    child: const Icon(Icons.edit_rounded,
                        color: Colors.white, size: 16),
                  )
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Jewelle Lucero',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: AppColors.charcoal,
                    letterSpacing: -0.5),
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                    color: AppColors.tealLight.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20)),
                child: const Text(
                  'jewelle.lucero@example.com',
                  style: TextStyle(
                      fontSize: 13,
                      color: AppColors.teal,
                      fontWeight: FontWeight.w800),
                ),
              ),

              const SizedBox(height: 32),

              // ── SETTINGS & OPTIONS PANEL (Glassmorphism Card) ──
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.45),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.6), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        _ProfileOption(
                            icon: Icons.person_outline_rounded,
                            title: 'Account Settings',
                            onTap: () =>
                                _navTo(const _AccountSettingsScreen())),
                        Divider(
                            color: Colors.white.withOpacity(0.5),
                            height: 1,
                            indent: 50),
                        _ProfileOption(
                            icon: Icons.map_outlined,
                            title: 'Trip History',
                            onTap: () => _navTo(const _TripHistoryScreen())),
                        Divider(
                            color: Colors.white.withOpacity(0.5),
                            height: 1,
                            indent: 50),
                        _ProfileOption(
                            icon: Icons.notifications_none_rounded,
                            title: 'Notifications',
                            badgeCount: 2,
                            onTap: () => _navTo(const _NotificationsScreen())),
                        Divider(
                            color: Colors.white.withOpacity(0.5),
                            height: 1,
                            indent: 50),
                        _ProfileOption(
                            icon: Icons.help_outline_rounded,
                            title: 'Help & Support',
                            onTap: () => _navTo(const _HelpSupportScreen())),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // ── LOGOUT BUTTON (Animated) ──
              _HoverLogoutButton(onTap: _handleLogout),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

// ── CUSTOM WIDGET PARA SA MENU ITEM (Animated Hover) ──
class _ProfileOption extends StatefulWidget {
  final IconData icon;
  final String title;
  final int? badgeCount;
  final VoidCallback onTap;

  const _ProfileOption(
      {required this.icon,
      required this.title,
      this.badgeCount,
      required this.onTap});

  @override
  State<_ProfileOption> createState() => _ProfileOptionState();
}

class _ProfileOptionState extends State<_ProfileOption> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: ListTile(
        onTap: widget.onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        tileColor:
            _isHovered ? Colors.white.withOpacity(0.3) : Colors.transparent,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(_isHovered ? 0.15 : 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(widget.icon, color: AppColors.primary, size: 22),
        ),
        title: Text(widget.title,
            style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: AppColors.charcoal,
                fontSize: 15)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.badgeCount != null)
              Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                    color: AppColors.urgent, shape: BoxShape.circle),
                child: Text(widget.badgeCount.toString(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold)),
              ),
            Icon(Icons.chevron_right_rounded,
                color: AppColors.charcoal.withOpacity(0.4)),
          ],
        ),
      ),
    );
  }
}

// ── ANIMATED LOGOUT BUTTON ──
class _HoverLogoutButton extends StatefulWidget {
  final VoidCallback onTap;
  const _HoverLogoutButton({required this.onTap});

  @override
  State<_HoverLogoutButton> createState() => _HoverLogoutButtonState();
}

class _HoverLogoutButtonState extends State<_HoverLogoutButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: SizedBox(
          width: double.infinity,
          child: TextButton.icon(
            onPressed: widget.onTap,
            style: TextButton.styleFrom(
              backgroundColor: _isHovered
                  ? AppColors.danger
                  : AppColors.dangerLight.withOpacity(0.7),
              foregroundColor: _isHovered ? Colors.white : AppColors.danger,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            icon: const Icon(Icons.logout_rounded, size: 20),
            label: const Text(
              'Log Out',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// PROTOTYPE DUMMY SCREENS (PHILIPPINES CONTEXT)
// ============================================================================

class _AccountSettingsScreen extends StatelessWidget {
  const _AccountSettingsScreen();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Account Settings',
            style: TextStyle(fontWeight: FontWeight.w800)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text('Personal Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 20),
          _buildTextField('Full Name', 'Jewelle Lucero'),
          const SizedBox(height: 16),
          _buildTextField('Email Address', 'jewelle.lucero@example.com'),
          const SizedBox(height: 16),
          _buildTextField('Phone Number', '+63 912 345 6789'),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Save Changes',
                style: TextStyle(fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String placeholder) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: Colors.black54,
                fontSize: 12,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: placeholder,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200)),
          ),
        ),
      ],
    );
  }
}

class _TripHistoryScreen extends StatelessWidget {
  const _TripHistoryScreen();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Trip History',
            style: TextStyle(fontWeight: FontWeight.w800)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildTripCard('Cebu-Bohol Escapade', 'April 15, 2026', 'Completed',
              ['Ana Pauline', 'Gia Lopez', 'Denise Sinday']),
          const SizedBox(height: 16),
          _buildTripCard('Boracay Summer Getaway', 'October 29, 2025',
              'Completed', ['Ana Pauline', 'Gia Lopez']),
          const SizedBox(height: 16),
          _buildTripCard('Baguio Food Trip', 'September 12, 2025', 'Completed',
              ['Denise Sinday', 'Ana Pauline']),
        ],
      ),
    );
  }

  Widget _buildTripCard(
      String title, String date, String status, List<String> members) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(date,
                  style: const TextStyle(
                      color: AppColors.captionText,
                      fontSize: 12,
                      fontWeight: FontWeight.w700)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                    color: AppColors.tealLight,
                    borderRadius: BorderRadius.circular(8)),
                child: Text(status,
                    style: const TextStyle(
                        color: AppColors.teal,
                        fontSize: 10,
                        fontWeight: FontWeight.w900)),
              )
            ],
          ),
          const SizedBox(height: 8),
          Text(title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.charcoal)),
          const SizedBox(height: 12),
          Text('Companions: ${members.join(", ")}',
              style: const TextStyle(color: AppColors.bodyText, fontSize: 12)),
        ],
      ),
    );
  }
}

class _NotificationsScreen extends StatelessWidget {
  const _NotificationsScreen();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Notifications',
            style: TextStyle(fontWeight: FontWeight.w800)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: ListView(
        children: [
          _buildNotif(
              'Gia Lopez invited you to a new trip: "Siargao Surfing Weekend".',
              '2 hours ago',
              true),
          _buildNotif(
              'Denise Sinday marked as Ready for today\'s meetup at BGC.',
              '5 hours ago',
              true),
          _buildNotif('Your group successfully arrived at Palawan.',
              'Yesterday', false),
          _buildNotif(
              'Ana Pauline Cruz added a new stop to the Tagaytay itinerary.',
              '2 days ago',
              false),
        ],
      ),
    );
  }

  Widget _buildNotif(String message, String time, bool isNew) {
    return Container(
      color: isNew ? AppColors.primary.withOpacity(0.05) : Colors.transparent,
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        leading: CircleAvatar(
          backgroundColor: isNew ? AppColors.primaryLight : Colors.white,
          child: Icon(
              isNew
                  ? Icons.notifications_active_rounded
                  : Icons.notifications_none_rounded,
              color: isNew ? AppColors.primary : AppColors.captionText,
              size: 20),
        ),
        title: Text(message,
            style: TextStyle(
                fontSize: 13,
                fontWeight: isNew ? FontWeight.w800 : FontWeight.w600,
                color: AppColors.charcoal,
                height: 1.4)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(time,
              style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.captionText,
                  fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}

class _HelpSupportScreen extends StatelessWidget {
  const _HelpSupportScreen();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Help & Support',
            style: TextStyle(fontWeight: FontWeight.w800)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text('Frequently Asked Questions',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.charcoal)),
          const SizedBox(height: 16),
          _buildFAQ('How do I create a new group trip?',
              'Go to the Dashboard and click the "Plan a New Meetup" button. You can set the target time and location from there.'),
          _buildFAQ('Can I invite friends who don\'t have the app?',
              'Yes! You can share the 6-digit Room Code via Messenger or text. They can enter it once they download Taralets.'),
          _buildFAQ('How does the AI Optimization work?',
              'Our algorithm analyzes the distance and ideal time for each activity you add to the Timeline, and arranges them to minimize travel delay.'),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                const Icon(Icons.support_agent_rounded,
                    size: 40, color: AppColors.primary),
                const SizedBox(height: 12),
                const Text('Need more help?',
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: AppColors.charcoal)),
                const SizedBox(height: 4),
                const Text('Contact our support team directly.',
                    style: TextStyle(color: AppColors.bodyText, fontSize: 13)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      elevation: 0,
                      side:
                          BorderSide(color: AppColors.primary.withOpacity(0.2)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: const Text('Contact Us',
                      style: TextStyle(fontWeight: FontWeight.w800)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFAQ(String question, String answer) {
    return ExpansionTile(
      title: Text(question,
          style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: AppColors.charcoal)),
      iconColor: AppColors.primary,
      childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      children: [
        Text(answer,
            style: const TextStyle(
                color: AppColors.bodyText, fontSize: 13, height: 1.5)),
      ],
    );
  }
}
