import 'package:flutter/material.dart';
import '../models/group_member.dart';
import '../constants/colors.dart';

class MemberCard extends StatelessWidget {
  final GroupMember member;

  const MemberCard({super.key, required this.member});

  // Ligtas na String processing para maiwasan ang enum check errors
  String _getStatusString() {
    return member.status.toString().split('.').last.toLowerCase();
  }

  // Nagbibigay ng tamang kulay depende sa text value ng status
  Color _getBadgeColor(String statusStr) {
    if (statusStr.contains('near')) {
      return Colors.green; // Green kung malapit
    } else if (statusStr.contains('arrive')) {
      return Colors.amber; // Yellow/Amber kung dumating na
    } else {
      return Colors.red;   // Red kung malayo o on the way
    }
  }

  // Nagbibigay ng malinis na text display para sa badge UI
  String _getBadgeLabel(String statusStr) {
    if (statusStr.contains('near')) return 'Near';
    if (statusStr.contains('arrive')) return 'Arrived';
    return 'Far';
  }

  @override
  Widget build(BuildContext context) {
    final statusStr = _getStatusString();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.divider),
      ),
      color: Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Text(
            member.name.isNotEmpty ? member.name[0].toUpperCase() : '?',
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              member.name,
              style: const TextStyle(
                color: AppColors.charcoal,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            
            // ── COMPILED STATUS BADGE (GREEN / RED / YELLOW) ──
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _getBadgeColor(statusStr).withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _getBadgeColor(statusStr),
                  width: 1,
                ),
              ),
              child: Text(
                _getBadgeLabel(statusStr),
                style: TextStyle(
                  color: _getBadgeColor(statusStr),
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        subtitle: Text(
          // Inalis ang .isReady para mawala ang error at ginamit ang status label dynamically
          'Status: ${_getBadgeLabel(statusStr)}',
          style: const TextStyle(
            color: AppColors.bodyText,
            fontSize: 12,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: AppColors.captionText,
        ),
      ),
    );
  }
}