import 'package:flutter/material.dart';
import '../constants/colors.dart';

enum MemberStatus { nearBy, onTheWay, urgent }

class GroupMember {
  final String id;
  final String name;
  final String avatarInitials;
  final Color avatarColor;
  final String mockLocation;
  final double distanceKm;
  final int departureMinutesFromNow;
  final MemberStatus status;
  final bool isCurrentUser;

  const GroupMember({
    required this.id,
    required this.name,
    required this.avatarInitials,
    required this.avatarColor,
    required this.mockLocation,
    required this.distanceKm,
    required this.departureMinutesFromNow,
    required this.status,
    this.isCurrentUser = false,
  });

  String get departureBadgeLabel {
    if (departureMinutesFromNow <= 0) return 'Depart now!';
    if (departureMinutesFromNow < 60)
      return 'Leave in ${departureMinutesFromNow}m';
    final h = departureMinutesFromNow ~/ 60;
    final m = departureMinutesFromNow % 60;
    return m == 0 ? 'Leave in ${h}h' : 'Leave in ${h}h ${m}m';
  }

  Color get badgeColor {
    switch (status) {
      case MemberStatus.nearBy:
        return AppColors.teal;
      case MemberStatus.onTheWay:
        return AppColors.primary;
      case MemberStatus.urgent:
        return AppColors.urgent;
    }
  }

  Color get badgeBgColor {
    switch (status) {
      case MemberStatus.nearBy:
        return AppColors.tealLight;
      case MemberStatus.onTheWay:
        return AppColors.primaryLight;
      case MemberStatus.urgent:
        return AppColors.urgentLight;
    }
  }

  // ── Mock dataset ──────────────────────────────────────────────────────────
  static const List<GroupMember> mockMembers = [
    GroupMember(
      id: 'u1',
      name: 'Jewelle Lucero',
      avatarInitials: 'JL',
      avatarColor: Color(0xFF8B5CF6),
      mockLocation: 'Katipunan Ave, QC',
      distanceKm: 1.2,
      departureMinutesFromNow: 10,
      status: MemberStatus.nearBy,
      isCurrentUser: true,
    ),
    GroupMember(
      id: 'u2',
      name: 'Ana Cruz',
      avatarInitials: 'AC',
      avatarColor: Color(0xFF0D9488),
      mockLocation: 'Timog Ave, QC',
      distanceKm: 3.4,
      departureMinutesFromNow: 22,
      status: MemberStatus.onTheWay,
    ),
    GroupMember(
      id: 'u3',
      name: 'Gia Lopez',
      avatarInitials: 'GL',
      avatarColor: Color(0xFF0066FF),
      mockLocation: 'Ortigas Center, Pasig',
      distanceKm: 7.8,
      departureMinutesFromNow: 5,
      status: MemberStatus.urgent,
    ),
    GroupMember(
      id: 'u4',
      name: 'Dennise Sinday',
      avatarInitials: 'DS',
      avatarColor: Color(0xFFEC4899),
      mockLocation: 'Ayala, Makati',
      distanceKm: 12.1,
      departureMinutesFromNow: 0,
      status: MemberStatus.urgent,
    ),
  ];
}
