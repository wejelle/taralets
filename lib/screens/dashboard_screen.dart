import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    final sabayCount =
        members.where((m) => m.status == MemberStatus.nearBy).length;

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient (Soft Sage Green & Lavender)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFE0C3FC), // Light purple
                  Color(0xFF8EC5FC), // Light blue
                ],
              ),
            ),
          ),

          SafeArea(
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
                                  color: Colors.black87,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Eastwood City Mall · Tonight',
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        _StatusDot(), // Gagamit na ito ng HoverGlassCard
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
                        _CountdownPill(
                            remaining: _remaining, twoDigit: _twoDigit),
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
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '${members.length} people',
                          style: const TextStyle(
                              color: Colors.black54, fontSize: 13),
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
        ],
      ),
    );
  }
}

// ── Reusable Hoverable Glass Card ─────────────────────────────────────────────
class HoverGlassCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final Color? borderColor;

  const HoverGlassCard({
    super.key,
    required this.child,
    this.margin = EdgeInsets.zero,
    this.padding = const EdgeInsets.all(12),
    this.color,
    this.borderColor,
  });

  @override
  State<HoverGlassCard> createState() => _HoverGlassCardState();
}

class _HoverGlassCardState extends State<HoverGlassCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.03 : 1.0, // Slight pop effect
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        child: Container(
          margin: widget.margin,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: widget.padding,
                decoration: BoxDecoration(
                  color: widget.color ??
                      Colors.white.withOpacity(_isHovered ? 0.45 : 0.3),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: widget.borderColor ??
                        Colors.white.withOpacity(_isHovered ? 0.6 : 0.4),
                    width: 1.5,
                  ),
                ),
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Updated Components (using HoverGlassCard) ─────────────────────────────────

class _StatusDot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HoverGlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      color: AppColors.tealLight.withOpacity(0.4), // Tinted glass
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
                color: AppColors.teal, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          const Text('Live',
              style: TextStyle(
                  color: AppColors.teal,
                  fontSize: 12,
                  fontWeight: FontWeight.w700)),
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
      child: HoverGlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Time to Meetup',
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 11,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(
              '$h:$m:$s',
              style: GoogleFonts.jetBrainsMono(
                color: Colors.black87,
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
    return HoverGlassCard(
      color: AppColors.teal.withOpacity(0.6), // Tinted teal glass
      borderColor: Colors.white.withOpacity(0.3),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sabay-Sabay',
              style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 11,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$count/$total',
                  style: GoogleFonts.jetBrainsMono(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(
                  text: ' ready',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
