import 'dart:async';
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/group_member.dart';
import '../widgets/map_container.dart';
import '../widgets/member_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Timer _timer;
  Duration _remaining = const Duration(hours: 0, minutes: 47, seconds: 12);

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remaining.inSeconds > 0) {
        setState(() => _remaining -= const Duration(seconds: 1));
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _twoDigit(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    const members = GroupMember.mockMembers;
    final sabayCount = members.where((m) => m.status == MemberStatus.nearBy).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── Header ────────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Taralets! 🎉',
                            style: TextStyle(
                              color: AppColors.charcoal,
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Eastwood City Mall · Tonight',
                            style: TextStyle(color: AppColors.bodyText, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    _StatusDot(),
                  ],
                ),
              ),
            ),

            // ── Map ───────────────────────────────────────────────────────
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 18, 20, 0),
                child: MapContainer(height: 210, showPin: true),
              ),
            ),

            // ── Countdown pill ────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    _CountdownPill(remaining: _remaining, twoDigit: _twoDigit),
                    const SizedBox(width: 10),
                    _SabayPill(count: sabayCount, total: members.length),
                  ],
                ),
              ),
            ),

            // ── Members header ────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Group Members',
                      style: TextStyle(
                        color: AppColors.charcoal,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '${members.length} people',
                      style: const TextStyle(color: AppColors.captionText, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),

            // ── Member cards ──────────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) => MemberCard(member: members[i]),
                  childCount: members.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.tealLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(color: AppColors.teal, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          const Text('Live', style: TextStyle(color: AppColors.teal, fontSize: 12, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _CountdownPill extends StatelessWidget {
  final Duration remaining;
  final String Function(int) twoDigit;
  const _CountdownPill({required this.remaining, required this.twoDigit});

  @override
  Widget build(BuildContext context) {
    final h = twoDigit(remaining.inHours);
    final m = twoDigit(remaining.inMinutes.remainder(60));
    final s = twoDigit(remaining.inSeconds.remainder(60));
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Time to Meetup', style: TextStyle(color: AppColors.captionText, fontSize: 11, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(
              '$h:$m:$s',
              style: const TextStyle(
                color: AppColors.charcoal,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SabayPill extends StatelessWidget {
  final int count;
  final int total;
  const _SabayPill({required this.count, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.teal,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sabay-Sabay', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 11, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(
            '$count/$total ready',
            style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
