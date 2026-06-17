import 'package:flutter/material.dart';

enum MemberStatus { pending, ready, inTransit, arrived }

class GroupMember {
  final String id;
  final String name;
  final String avatarInitials;
  final Color avatarColor;
  final String mockLocation;
  final double distanceKm;
  final int departureMinutesFromNow;
  final String targetLeaveTime;
  final String? actualLeaveTime;
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
    required this.targetLeaveTime,
    this.actualLeaveTime,
    required this.status,
    this.isCurrentUser = false,
  });

  // ── Mock dataset ──────────────────────────────────────────────────────────
  static List<GroupMember> mockMembers = [
    GroupMember(
        id: 'u2',
        name: 'Ana Cruz',
        avatarInitials: 'AC',
        avatarColor: const Color(0xFF0D9488),
        mockLocation: 'Timog Ave',
        distanceKm: 3.4,
        departureMinutesFromNow: 0,
        targetLeaveTime: 'Ready',
        status: MemberStatus.ready), // READY NA SILA
    GroupMember(
        id: 'u3',
        name: 'Gia Lopez',
        avatarInitials: 'GL',
        avatarColor: const Color(0xFF0066FF),
        mockLocation: 'Ortigas',
        distanceKm: 7.8,
        departureMinutesFromNow: 0,
        targetLeaveTime: 'Ready',
        status: MemberStatus.ready),
    GroupMember(
        id: 'u4',
        name: 'Dennise Sinday',
        avatarInitials: 'DS',
        avatarColor: const Color(0xFFEC4899),
        mockLocation: 'Makati',
        distanceKm: 12.1,
        departureMinutesFromNow: 0,
        targetLeaveTime: 'Ready',
        status: MemberStatus.ready),
  ];
}
