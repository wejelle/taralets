import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/group_member.dart';

class MemberCard extends StatelessWidget {
  final GroupMember member;
  const MemberCard({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(color: AppColors.charcoal.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: member.avatarColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                member.avatarInitials,
                style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Name + location
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      member.name,
                      style: const TextStyle(color: AppColors.charcoal, fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                    if (member.isCurrentUser) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('You', style: TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 13, color: AppColors.captionText),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        member.mockLocation,
                        style: const TextStyle(color: AppColors.bodyText, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${member.distanceKm.toStringAsFixed(1)} km',
                      style: const TextStyle(color: AppColors.captionText, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Departure badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: member.badgeBgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              member.departureBadgeLabel,
              style: TextStyle(
                color: member.badgeColor,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
