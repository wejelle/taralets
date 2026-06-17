import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';
import '../models/group_member.dart';
import '../widgets/map_container.dart';
import '../widgets/member_card.dart';

class DashboardScreen extends StatefulWidget {
  final String tripName;
  final String location;
  final TimeOfDay? targetTime;

  final int reportedDelayMinutes;
  final bool isReady;
  final bool hasActiveTrip; // BAGO: Tumatanggap ng status galing sa main shell
  final void Function(int)? onAddDelay;
  final VoidCallback? onToggleReady;

  const DashboardScreen({
    super.key,
    this.tripName = 'Taralets! 🎉',
    this.location = 'Eastwood City Mall',
    this.targetTime,
    this.reportedDelayMinutes = 0,
    this.isReady = false,
    this.hasActiveTrip = true,
    this.onAddDelay,
    this.onToggleReady,
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

  @override
  void didUpdateWidget(DashboardScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.reportedDelayMinutes != widget.reportedDelayMinutes) {
      int diff = widget.reportedDelayMinutes - oldWidget.reportedDelayMinutes;
      setState(() {
        _remaining += Duration(minutes: diff);
      });
    }
  }

  void _calculateInitialTime() {
    int currentDelay = widget.reportedDelayMinutes;
    if (widget.targetTime != null) {
      final now = TimeOfDay.now();
      int diffInMinutes =
          (widget.targetTime!.hour * 60 + widget.targetTime!.minute) -
              (now.hour * 60 + now.minute);
      if (diffInMinutes < 0) diffInMinutes += 1440;
      diffInMinutes += currentDelay;
      _remaining = Duration(minutes: diffInMinutes);
    } else {
      _remaining = const Duration(hours: 1, minutes: 30) +
          Duration(minutes: currentDelay);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _twoDigit(int n) => n.toString().padLeft(2, '0');

  void _showDelayModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _DelaySelectorModal(
        onConfirm: (mins) {
          widget.onAddDelay?.call(mins);
          Navigator.pop(ctx);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // DYNAMIC COUNTING KASAMA INVITES:
    final members = GroupMember.mockMembers;

    // 👈 BAGO: Idagdag itong line na ito DITO para makita ng buong build method
    final otherMembers = members.where((m) => !m.isCurrentUser).toList();

    final int totalMembers = members.length + 1; // +1 kasi kasama ka (You)

    // Bibilangin lahat ng ready. Ang isReady sa widget ay para sayo.
    final sabayCount =
        members.where((m) => m.status == MemberStatus.ready).length +
            (widget.isReady ? 1 : 0);
    final bool isAllReady = sabayCount == totalMembers;

    return Scaffold(
      backgroundColor: Colors.transparent, // Mag-aadapt sa global background
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
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
                            widget.tripName,
                            style: const TextStyle(
                                color: AppColors.charcoal,
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.5),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${widget.location} · ${widget.targetTime?.format(context) ?? "Soon"}',
                            style: const TextStyle(
                                color: AppColors.bodyText,
                                fontSize: 13,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    _StatusDot(),
                  ],
                ),
              ),
            ),

            // ── MAP CONTAINER ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                child: MapContainer(
                    height: 210,
                    showPin: true,
                    pinLabel: widget.location,
                    members: members,
                    // Di na gagalaw hangga't di 4/4 ready
                    isReady: isAllReady),
              ),
            ),

            // ── PILLS ROW (Dynamic Countdown/Invite Code) ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    // BAGO: Lalabas lang ang countdown pag ready na lahat!
                    isAllReady
                        ? _CountdownPill(
                            remaining: _remaining, twoDigit: _twoDigit)
                        : const Expanded(
                            child: Center(
                                child: Text(
                                    'Waiting for everyone to be ready...',
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 12)))),
                    const SizedBox(width: 10),
                    _SabayPill(
                        count: sabayCount,
                        total: totalMembers), // DYNAMIC TOTAL TO!
                  ],
                ),
              ),
            ),

            // ── ACTION BUTTONS ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: widget.onToggleReady,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color:
                                widget.isReady ? AppColors.teal : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                                color: widget.isReady
                                    ? AppColors.teal
                                    : AppColors.divider),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                  widget.isReady
                                      ? Icons.check_circle_rounded
                                      : Icons.radio_button_unchecked_rounded,
                                  color: widget.isReady
                                      ? Colors.white
                                      : AppColors.captionText,
                                  size: 18),
                              const SizedBox(width: 8),
                              Text(widget.isReady ? 'Ready!' : 'Mark Ready',
                                  style: TextStyle(
                                      color: widget.isReady
                                          ? Colors.white
                                          : AppColors.captionText,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: _showDelayModal,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: widget.reportedDelayMinutes > 0
                                ? AppColors.urgent
                                : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                                color: widget.reportedDelayMinutes > 0
                                    ? AppColors.urgent
                                    : AppColors.divider),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.warning_rounded,
                                  color: widget.reportedDelayMinutes > 0
                                      ? Colors.white
                                      : AppColors.urgent,
                                  size: 18),
                              const SizedBox(width: 8),
                              Text(
                                  widget.reportedDelayMinutes > 0
                                      ? 'Delayed (+${widget.reportedDelayMinutes}m)'
                                      : 'Delay?',
                                  style: TextStyle(
                                      color: widget.reportedDelayMinutes > 0
                                          ? Colors.white
                                          : AppColors.urgent,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── HEADER: GROUP MEMBERS ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Group Members',
                        style: TextStyle(
                            color: AppColors.charcoal,
                            fontSize: 16,
                            fontWeight: FontWeight.w800)),
                    Text('${members.length + 1} people',
                        style: const TextStyle(
                            color: AppColors.captionText, fontSize: 13)),
                  ],
                ),
              ),
            ),

            // ── LIST: GROUP MEMBERS ──
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                  20, 0, 20, 100), // Extra padding sa baba para sa floating nav
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) => MemberCard(
                      member: otherMembers[
                          i]), // Ginamit ang otherMembers imbes na members
                  childCount:
                      otherMembers.length, // Ginamit ang length ng otherMembers
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── CUSTOM WIDGET PARA SA DELAY MODAL ──
class _DelaySelectorModal extends StatefulWidget {
  final ValueChanged<int> onConfirm;
  const _DelaySelectorModal({required this.onConfirm});

  @override
  State<_DelaySelectorModal> createState() => _DelaySelectorModalState();
}

class _DelaySelectorModalState extends State<_DelaySelectorModal> {
  int _selectedMins = 15;
  final List<int> _options = [5, 10, 15, 30, 45, 60];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.timer_rounded,
                    color: AppColors.charcoal, size: 24),
                const SizedBox(width: 10),
                const Text('Report a Delay',
                    style: TextStyle(
                        color: AppColors.charcoal,
                        fontSize: 20,
                        fontWeight: FontWeight.w800)),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close_rounded,
                      color: AppColors.captionText),
                )
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.urgent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.urgent.withOpacity(0.4)),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.warning_amber_rounded,
                      color: AppColors.urgent, size: 20),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Warning: Adding a delay will automatically adjust the ETA and departure time for the rest of the group.',
                      style: TextStyle(
                          color: AppColors.urgent,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('How long will you be delayed?',
                style: TextStyle(
                    color: AppColors.charcoal,
                    fontSize: 14,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _options.map((mins) {
                final bool isSelected = _selectedMins == mins;
                return GestureDetector(
                  onTap: () => setState(() => _selectedMins = mins),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.divider),
                    ),
                    child: Text(
                      '+$mins m',
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.bodyText,
                        fontSize: 14,
                        fontWeight:
                            isSelected ? FontWeight.w800 : FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => widget.onConfirm(_selectedMins),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: Text('Confirm Add Delay (+$_selectedMins mins)',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    )),
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

// BAGO: Invite Code Banner na pamalit habang naghihintay
class _InviteCodePill extends StatelessWidget {
  final String code;
  const _InviteCodePill({required this.code});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.primaryLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Room Invite Code',
                style: TextStyle(
                    color: AppColors.captionText,
                    fontSize: 11,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  code,
                  style: GoogleFonts.jetBrainsMono(
                    color: AppColors.primary,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                  ),
                ),
                const Icon(Icons.copy_rounded,
                    color: AppColors.primary, size: 18),
              ],
            ),
          ],
        ),
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
            const Text('Time to Meetup',
                style: TextStyle(
                    color: AppColors.captionText,
                    fontSize: 11,
                    fontWeight: FontWeight.w700)),
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sabay-Sabay',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 11,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$count/$total',
                    style: GoogleFonts.jetBrainsMono(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w800),
                  ),
                  const TextSpan(
                    text: ' ready',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
