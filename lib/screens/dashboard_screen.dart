import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';
import '../models/group_member.dart';
import '../widgets/map_container.dart';
import '../widgets/member_card.dart';

class DashboardScreen extends StatefulWidget {
  // MODULE 3.0 DATA (Dito tatanggapin ang galing sa Initialization Screen)
  final String tripName;
  final String location;
  final TimeOfDay? targetTime;

  const DashboardScreen({
    super.key,
    this.tripName = 'Taralets! 🎉',
    this.location = 'Eastwood City Mall',
    this.targetTime,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Timer _timer;
  Duration _remaining = const Duration(hours: 0, minutes: 0, seconds: 0);

  @override
  void initState() {
    super.initState();
    _calculateInitialTime();
    
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remaining.inSeconds > 0) {
        setState(() => _remaining -= const Duration(seconds: 1));
      } else {
        _timer.cancel();
      }
    });
  }

  // Logic para ma-kalkula kung ilang oras pa bago ang Target Arrival Time
  void _calculateInitialTime() {
    if (widget.targetTime != null) {
      final now = TimeOfDay.now();
      int diffInMinutes = (widget.targetTime!.hour * 60 + widget.targetTime!.minute) - 
                          (now.hour * 60 + now.minute);
      
      // Kung ang target time ay pang-bukas (negative), magdadagdag tayo ng 24 hours (1440 mins)
      if (diffInMinutes < 0) diffInMinutes += 1440;
      
      _remaining = Duration(minutes: diffInMinutes);
    } else {
      _remaining = const Duration(hours: 1, minutes: 30); // Default fallback
    }
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
      backgroundColor: AppColors.background, // Clean minimalist background
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── Header (DYNAMIC) ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.tripName, // Dynamic Trip Name
                            style: const TextStyle(color: AppColors.charcoal, fontSize: 26, fontWeight: FontWeight.w900, letterSpacing: -0.5),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${widget.location} · ${widget.targetTime?.format(context) ?? "Soon"}', // Dynamic Location at Time
                            style: const TextStyle(color: AppColors.bodyText, fontSize: 13, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    _StatusDot(),
                  ],
                ),
              ),
            ),

            // ── Map ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                child: MapContainer(height: 210, showPin: true, pinLabel: widget.location),
              ),
            ),

            // ── Countdown pill ──
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

            // ── Members header ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Group Members', style: TextStyle(color: AppColors.charcoal, fontSize: 16, fontWeight: FontWeight.w800)),
                    Text('${members.length} people', style: const TextStyle(color: AppColors.captionText, fontSize: 13)),
                  ],
                ),
              ),
            ),

            // ── Member cards ──
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

// ── Components ─────────────────────────────────

class _StatusDot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.tealLight,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7, height: 7,
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
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Time to Meetup', style: TextStyle(color: AppColors.captionText, fontSize: 11, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(
              '$h:$m:$s',
              style: GoogleFonts.jetBrainsMono(
                color: AppColors.charcoal,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
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
      decoration: BoxDecoration(
        color: AppColors.teal,
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sabay-Sabay', style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 11, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$count/$total',
                  style: GoogleFonts.jetBrainsMono(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800),
                ),
                const TextSpan(
                  text: ' ready',
                  style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}