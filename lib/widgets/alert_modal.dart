import 'package:flutter/material.dart';
import '../constants/colors.dart';

class UrgentDepartureModal extends StatelessWidget {
  final VoidCallback onDismiss;
  const UrgentDepartureModal({super.key, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.urgent.withOpacity(0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.urgent.withOpacity(0.2),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.urgentLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.warning_rounded, color: AppColors.urgent, size: 22),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🚨 Urgent Departure Alert',
                      style: TextStyle(
                        color: AppColors.urgent,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Tiered Priority — Level 2',
                      style: TextStyle(color: AppColors.bodyText, fontSize: 12),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onDismiss,
                child: const Icon(Icons.close_rounded, color: AppColors.captionText, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const _AlertTier(
            level: '🔴 LEVEL 3 — CRITICAL',
            color: AppColors.danger,
            bgColor: AppColors.dangerLight,
            message: 'Jett Villanueva must leave NOW to arrive on time. Distance: 12.1 km.',
          ),
          const SizedBox(height: 8),
          const _AlertTier(
            level: '🟠 LEVEL 2 — URGENT',
            color: AppColors.urgent,
            bgColor: AppColors.urgentLight,
            message: 'Anika Flores needs to depart within 5 minutes. Distance: 7.8 km.',
          ),
          const SizedBox(height: 8),
          const _AlertTier(
            level: '🔵 LEVEL 1 — HEADS UP',
            color: AppColors.primary,
            bgColor: AppColors.primaryLight,
            message: 'Carlo Reyes should leave in 22 minutes. Distance: 3.4 km.',
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: onDismiss,
              style: TextButton.styleFrom(
                backgroundColor: AppColors.urgent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Notify All Members', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertTier extends StatelessWidget {
  final String level;
  final String message;
  final Color color;
  final Color bgColor;

  const _AlertTier({
    required this.level,
    required this.message,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(level, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
          const SizedBox(height: 4),
          Text(message, style: const TextStyle(color: AppColors.charcoal, fontSize: 12, height: 1.4)),
        ],
      ),
    );
  }
}
