import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'initialization_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Malinis na background na kapareho ng sa Initialization Screen
      backgroundColor: const Color(0xFFF7F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text('Hello, Traveler!',
                  style: TextStyle(
                      color: AppColors.charcoal,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5)),
              const SizedBox(height: 8),
              const Text('Ready for your next group travel?',
                  style: TextStyle(
                      color: AppColors.bodyText,
                      fontSize: 15,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 40),

              // ── Modern, Solid Empty State Card ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border:
                      Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4))
                  ],
                ),
                child: const Column(
                  children: [
                    Icon(Icons.flight_takeoff_rounded,
                        color: AppColors.captionText, size: 52),
                    SizedBox(height: 16),
                    Text('No Active Trips',
                        style: TextStyle(
                            color: AppColors.charcoal,
                            fontSize: 18,
                            fontWeight: FontWeight.w900)),
                    SizedBox(height: 6),
                    Text("You don't have any ongoing meetups right now.",
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(color: AppColors.bodyText, fontSize: 14)),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // ── Action Cards ──
              _buildActionCard(
                context: context,
                title: 'Plan a New Meetup',
                subtitle: 'Set a location and target time',
                icon: Icons.add_location_alt_rounded,
                color: AppColors.primary,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const InitializationScreen()));
                },
              ),
              const SizedBox(height: 16),

              _buildActionCard(
                context: context,
                title: 'Join a Group',
                subtitle: 'Enter a room code from a friend',
                icon: Icons.meeting_room_rounded,
                color: AppColors
                    .secondary, // Siguraduhing may AppColors.secondary ka, kung wala, pwede mong gawing AppColors.primaryLight
                onTap: () => _showJoinDialog(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(
      {required BuildContext context,
      required String title,
      required String subtitle,
      required IconData icon,
      required Color color,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
          boxShadow: [
            BoxShadow(
                color: color.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4))
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: AppColors.charcoal,
                          fontSize: 16,
                          fontWeight: FontWeight.w900)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: const TextStyle(
                          color: AppColors.bodyText,
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                color: AppColors.captionText, size: 16),
          ],
        ),
      ),
    );
  }

  void _showJoinDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white.withOpacity(0.95),
        title: const Text('Join Group',
            style: TextStyle(
                fontWeight: FontWeight.w900, color: AppColors.charcoal)),
        content: TextField(
          decoration: InputDecoration(
            hintText: 'Enter 6-digit Room Code',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                    color: AppColors
                        .divider)), // Kung wala ang AppColors.divider, pwede itong const Color(0xFFE5E7EB)
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel',
                  style: TextStyle(
                      color: AppColors.captionText,
                      fontWeight: FontWeight.w700))),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Joined group successfully!')));
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            child: const Text('Join',
                style: TextStyle(fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }
}
