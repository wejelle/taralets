import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'initialization_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Greeting
              const Text('Hello, Traveler!',
                  style: TextStyle(
                      color: AppColors.charcoal,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5)),
              const SizedBox(height: 8),
              const Text('Ready for your next group travel?',
                  style: TextStyle(color: AppColors.bodyText, fontSize: 14)),
              const SizedBox(height: 40),

              // Empty State (Wala pang trip)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white, // O AppColors.surface kung na-add mo na
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.divider),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.flight_takeoff_rounded,
                        color: AppColors.captionText, size: 48),
                    SizedBox(height: 16),
                    Text('No Active Trips',
                        style: TextStyle(
                            color: AppColors.charcoal,
                            fontSize: 16,
                            fontWeight: FontWeight.w800)),
                    SizedBox(height: 4),
                    Text("You don't have any ongoing meetups right now.",
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(color: AppColors.bodyText, fontSize: 13)),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Button: Create a Trip (Papunta sa Map/Initialization)
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

              // Button: Join a Trip (Room Code)
              _buildActionCard(
                context: context,
                title: 'Join a Group',
                subtitle: 'Enter a room code from a friend',
                icon: Icons.meeting_room_rounded,
                color: AppColors.secondary,
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
          border: Border.all(color: AppColors.divider),
          boxShadow: [
            BoxShadow(
                color: color.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4))
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
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
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: const TextStyle(
                          color: AppColors.bodyText, fontSize: 12)),
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
        backgroundColor: AppColors.background,
        title: const Text('Join Group',
            style: TextStyle(fontWeight: FontWeight.w800)),
        content: TextField(
          decoration: InputDecoration(
            hintText: 'Enter 6-digit Room Code',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.divider)),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Joined group successfully!')));
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white),
            child: const Text('Join'),
          ),
        ],
      ),
    );
  }
}
