import 'package:flutter/material.dart';
import '../models/group_member.dart';
import '../constants/colors.dart';

class MemberCard extends StatefulWidget {
  final GroupMember member;
  const MemberCard({super.key, required this.member});

  @override
  State<MemberCard> createState() => _MemberCardState();
}

class _MemberCardState extends State<MemberCard> {
  bool _isNotified = false;

  void _triggerNotify() {
    setState(() => _isNotified = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Nudge sent to ${widget.member.name.split(' ')[0]}! 🔔'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
    // Reset notify state for demo purposes
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _isNotified = false);
    });
  }

  Color _getBadgeColor() {
    switch (widget.member.status) {
      case MemberStatus.pending:
        return AppColors.urgent;
      case MemberStatus.ready:
        return AppColors.teal;
      case MemberStatus.inTransit:
        return AppColors.primary;
      case MemberStatus.arrived:
        return AppColors.starGold;
    }
  }

  String _getBadgeLabel() {
    switch (widget.member.status) {
      case MemberStatus.pending:
        return 'Should leave at ${widget.member.targetLeaveTime}';
      case MemberStatus.ready:
        return 'Ready to leave';
      case MemberStatus.inTransit:
        return 'Left at ${widget.member.actualLeaveTime ?? "..."}';
      case MemberStatus.arrived:
        return 'Arrived at Destination';
    }
  }

  Widget _buildTrailingAction() {
    if (widget.member.status == MemberStatus.pending) {
      return GestureDetector(
        onTap: _isNotified ? null : _triggerNotify,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: _isNotified ? AppColors.divider : AppColors.primaryLight,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            _isNotified ? 'Notified' : 'Notify',
            style: TextStyle(
              color: _isNotified ? AppColors.captionText : AppColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    IconData icon;
    switch (widget.member.status) {
      case MemberStatus.ready:
        icon = Icons.check_circle_rounded;
        break;
      case MemberStatus.inTransit:
        icon = Icons.directions_car_rounded;
        break;
      case MemberStatus.arrived:
        icon = Icons.location_on_rounded;
        break;
      default:
        icon = Icons.chevron_right_rounded;
    }
    return Icon(icon, color: _getBadgeColor().withOpacity(0.8));
  }

  @override
  Widget build(BuildContext context) {
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
          backgroundColor: widget.member.avatarColor.withOpacity(0.15),
          child: Text(
            widget.member.avatarInitials,
            style: TextStyle(
              color: widget.member.avatarColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          widget.member.name,
          style: const TextStyle(
            color: AppColors.charcoal,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: _getBadgeColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: _getBadgeColor().withOpacity(0.3)),
            ),
            child: Text(
              _getBadgeLabel(),
              style: TextStyle(
                color: _getBadgeColor(),
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        trailing: _buildTrailingAction(),
      ),
    );
  }
}
