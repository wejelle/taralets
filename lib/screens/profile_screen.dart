import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // LOGIC: Function para mag-log out
  void _handleLogout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  // LOGIC: Navigation handlers para sa prototype screens
  void _navTo(Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ── PREMIUM ACCENT BACKGROUND (Custom Colors) ──
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(88, 255, 99, 151), 
              ),
            ),
          ),
          Positioned(
            bottom: 150,
            left: -150,
            child: Container(
              width: 350,
              height: 350,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(64, 255, 170, 113), 
              ),
            ),
          ),

          // ── MAIN CONTENT ──
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  
                  // ── USER AVATAR & INFO (Cute Girl Avatar Guaranteed) ──
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 20,
                                offset: const Offset(0, 10))
                          ],
                        ),
                        child: const CircleAvatar(
                          radius: 55,
                          backgroundColor: Color(0xFFF3F4F6),
                          // Ginamit ang "lorelei" style para laging cute, happy, at babae
                          backgroundImage: NetworkImage(
                              'https://api.dicebear.com/7.x/lorelei/png?seed=Jewelle&backgroundColor=ff6397'), 
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: const Color(0xFFFF1E56),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3)),
                        child: const Icon(Icons.edit_rounded, color: Colors.white, size: 16),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Jewelle Lucero',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.black87, letterSpacing: -0.5),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6F7F0), 
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: const Text(
                      'jewelle.lucero@example.com',
                      style: TextStyle(fontSize: 13, color: Color(0xFF00A86B), fontWeight: FontWeight.w700), 
                    ),
                  ),
                  
                  const SizedBox(height: 32),

                  // ── SETTINGS & OPTIONS PANEL (Clean White Card) ──
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
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
                          onTap: () => _navTo(const _AccountSettingsScreen())
                        ),
                        Divider(color: Colors.grey.shade100, height: 1, indent: 50),
                        _ProfileOption(
                          icon: Icons.map_outlined, 
                          title: 'Trip History', 
                          onTap: () => _navTo(const _TripHistoryScreen())
                        ),
                        Divider(color: Colors.grey.shade100, height: 1, indent: 50),
                        _ProfileOption(
                          icon: Icons.notifications_none_rounded, 
                          title: 'Notifications', 
                          badgeCount: 2,
                          onTap: () => _navTo(const _NotificationsScreen())
                        ),
                        Divider(color: Colors.grey.shade100, height: 1, indent: 50),
                        _ProfileOption(
                          icon: Icons.help_outline_rounded, 
                          title: 'Help & Support', 
                          onTap: () => _navTo(const _HelpSupportScreen())
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ── LOGOUT BUTTON ──
                  SizedBox(
                    width: double.infinity,
                    child: TextButton.icon(
                      onPressed: _handleLogout,
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.red.shade50,
                        foregroundColor: Colors.red.shade700,
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
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── CUSTOM WIDGET PARA SA MENU ITEM ──
class _ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final int? badgeCount;
  final VoidCallback onTap;

  const _ProfileOption({required this.icon, required this.title, this.badgeCount, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppColors.primary, size: 22),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.black87, fontSize: 15)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (badgeCount != null)
            Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(color: AppColors.urgent, shape: BoxShape.circle),
              child: Text(badgeCount.toString(), style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          const Icon(Icons.chevron_right_rounded, color: Colors.black38),
        ],
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Account Settings', style: TextStyle(fontWeight: FontWeight.w800)), 
        backgroundColor: Colors.white, 
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text('Personal Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String placeholder) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: placeholder,
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Trip History', style: TextStyle(fontWeight: FontWeight.w800)), 
        backgroundColor: Colors.white, 
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildTripCard('Cebu-Bohol Escapade', 'April 15, 2026', 'Completed', ['Ana Pauline', 'Gia Lopez', 'Denise Sinday']),
          const SizedBox(height: 16),
          _buildTripCard('Boracay Summer Getaway', 'October 29, 2025', 'Completed', ['Ana Pauline', 'Gia Lopez']),
          const SizedBox(height: 16),
          _buildTripCard('Baguio Food Trip', 'September 12, 2025', 'Completed', ['Denise Sinday', 'Ana Pauline']),
        ],
      ),
    );
  }

  Widget _buildTripCard(String title, String date, String status, List<String> members) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(date, style: const TextStyle(color: Colors.black45, fontSize: 12, fontWeight: FontWeight.w600)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFE6F7F0), borderRadius: BorderRadius.circular(8)),
                child: Text(status, style: const TextStyle(color: Color(0xFF00A86B), fontSize: 10, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black87)),
          const SizedBox(height: 12),
          Text('Companions: ${members.join(", ")}', style: const TextStyle(color: Colors.black54, fontSize: 12)),
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Notifications', style: TextStyle(fontWeight: FontWeight.w800)), 
        backgroundColor: Colors.white, 
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: ListView(
        children: [
          _buildNotif('Gia Lopez invited you to a new trip: "Siargao Surfing Weekend".', '2 hours ago', true),
          _buildNotif('Denise Sinday marked as Ready for today\'s meetup at BGC.', '5 hours ago', true),
          _buildNotif('Your group successfully arrived at Palawan.', 'Yesterday', false),
          _buildNotif('Ana Pauline Cruz added a new stop to the Tagaytay itinerary.', '2 days ago', false),
        ],
      ),
    );
  }

  Widget _buildNotif(String message, String time, bool isNew) {
    return Container(
      color: isNew ? const Color(0xFFFFF0F5) : Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        leading: CircleAvatar(
          backgroundColor: isNew ? const Color(0xFFFFD6E5) : Colors.grey.shade100,
          child: Icon(isNew ? Icons.notifications_active_rounded : Icons.notifications_none_rounded, 
            color: isNew ? const Color(0xFFFF1E56) : Colors.black45, size: 20),
        ),
        title: Text(message, style: TextStyle(fontSize: 13, fontWeight: isNew ? FontWeight.w700 : FontWeight.w500, color: Colors.black87, height: 1.4)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(time, style: const TextStyle(fontSize: 11, color: Colors.black45)),
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Help & Support', style: TextStyle(fontWeight: FontWeight.w800)), 
        backgroundColor: Colors.white, 
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text('Frequently Asked Questions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 16),
          _buildFAQ('How do I create a new group trip?', 'Go to the Dashboard and click the "Plan a New Meetup" button. You can set the target time and location from there.'),
          _buildFAQ('Can I invite friends who don\'t have the app?', 'Yes! You can share the 6-digit Room Code via Messenger or text. They can enter it once they download Taralets.'),
          _buildFAQ('How does the AI Optimization work?', 'Our algorithm analyzes the distance and ideal time for each activity you add to the Timeline, and arranges them to minimize travel delay.'),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.05), borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                const Icon(Icons.support_agent_rounded, size: 40, color: AppColors.primary),
                const SizedBox(height: 12),
                const Text('Need more help?', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                const SizedBox(height: 4),
                const Text('Contact our support team directly.', style: TextStyle(color: Colors.black54, fontSize: 13)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: (){},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    elevation: 0,
                    side: BorderSide(color: AppColors.primary.withOpacity(0.2)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                  ),
                  child: const Text('Contact Us'),
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
      title: Text(question, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.black87)),
      iconColor: AppColors.primary,
      childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      children: [
        Text(answer, style: const TextStyle(color: Colors.black54, fontSize: 13, height: 1.5)),
      ],
    );
  }
}