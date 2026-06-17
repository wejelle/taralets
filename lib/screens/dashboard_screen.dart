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
  final bool hasActiveTrip;
  final void Function(int)? onAddDelay;
  final VoidCallback? onToggleReady;

  const DashboardScreen({
    super.key,
    this.tripName = 'Taralets!',
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

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late Timer _timer;
  Duration _remaining = const Duration(hours: 0, minutes: 0, seconds: 0);
  late final AnimationController _pulseController;

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

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void didUpdateWidget(DashboardScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.reportedDelayMinutes != widget.reportedDelayMinutes ||
        oldWidget.targetTime != widget.targetTime) {
      _calculateInitialTime();
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
    _pulseController.dispose();
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
    final members = GroupMember.mockMembers;
    final otherMembers = members.where((m) => !m.isCurrentUser).toList();
    final int totalMembers = members.length + 1;

    final onTheWayCount = members
            .where((m) =>
                m.status == MemberStatus.ready ||
                m.status == MemberStatus.inTransit)
            .length +
        (widget.isReady ? 1 : 0);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(context)),
            SliverToBoxAdapter(child: _buildMapCard(members)),
            SliverToBoxAdapter(
              child: _buildPillsRow(
                count: onTheWayCount,
                totalMembers: totalMembers,
                isReady: widget.isReady, // Ipinasa natin ang status
              ),
            ),
            SliverToBoxAdapter(child: _buildActionButtons()),
            SliverToBoxAdapter(
                child: _buildMembersHeader(otherMembers.length + 1)),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: MemberCard(member: otherMembers[i]),
                  ),
                  childCount: otherMembers.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.tripName,
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.charcoal,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on_rounded,
                        size: 14, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        '${widget.location} · ${widget.targetTime?.format(context) ?? "Soon"}',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.bodyText,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _StatusDot(pulseController: _pulseController),
        ],
      ),
    );
  }

  Widget _buildMapCard(List<GroupMember> members) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: const Color(0xFFE8F0F2), // Fallback base color
          
          // ── DITO ILALAGAY ANG IMAGE PLACEHOLDER CODE ──
          image: DecorationImage(
            // Gumamit tayo ng reliable Unsplash map image para iwas CORS/Load error
            image: const NetworkImage(
              'https://images.unsplash.com/photo-1524661135-423995f22d0b?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80'
            ),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.85), // Pinaputi pa natin lalo para hindi masapawan ang pins
              BlendMode.lighten,
            ),
          ),
          // ──────────────────────────────────────────────

          boxShadow: [
            BoxShadow(
              color: AppColors.charcoal.withOpacity(0.04),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: MapContainer(
            height: 220,
            showPin: true,
            pinLabel: widget.location,
            members: members,
            isReady: widget.isReady, 
          ),
        ),
      ),
    );
  } 


  Widget _buildPillsRow(
      {required int count, required int totalMembers, required bool isReady}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _CountdownPill(remaining: _remaining, twoDigit: _twoDigit),
            const SizedBox(width: 12),
            _StatusPill(count: count, total: totalMembers, isReady: isReady),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _ActionButton(
                onTap: widget.onToggleReady,
                active: widget.isReady,
                activeColor: AppColors.teal,
                activeIcon: Icons.directions_car_rounded,
                idleIcon: Icons.directions_walk_rounded,
                activeLabel: 'On the way',
                idleLabel: 'Set off to leave',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionButton(
                onTap: _showDelayModal,
                active: widget.reportedDelayMinutes > 0,
                activeColor: AppColors.urgent,
                activeIcon: Icons.warning_rounded,
                idleIcon: Icons.timer_outlined,
                activeLabel: 'Delayed (+${widget.reportedDelayMinutes}m)',
                idleLabel: 'Report Delay',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMembersHeader(int total) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Group Status',
              style: GoogleFonts.plusJakartaSans(
                  color: AppColors.charcoal,
                  fontSize: 16,
                  fontWeight: FontWeight.w800)),
          Text('$total members',
              style: GoogleFonts.plusJakartaSans(
                  color: AppColors.captionText,
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ── COMPONENTS ──

class _StatusDot extends StatelessWidget {
  final AnimationController pulseController;
  const _StatusDot({required this.pulseController});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.teal.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: pulseController,
            builder: (context, _) {
              return Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.teal,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.teal
                          .withOpacity(0.3 * pulseController.value),
                      blurRadius: 4 * pulseController.value,
                      spreadRadius: 2 * pulseController.value,
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(width: 6),
          Text('Live',
              style: GoogleFonts.plusJakartaSans(
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.charcoal.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.schedule_rounded,
                    size: 14, color: AppColors.captionText),
                const SizedBox(width: 6),
                Text('ETA',
                    style: GoogleFonts.plusJakartaSans(
                        color: AppColors.captionText,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '$h:$m:$s',
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.charcoal,
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final int count;
  final int total;
  final bool isReady; // ── Tumatanggap na ng status
  
  const _StatusPill({
    required this.count,
    required this.total,
    required this.isReady,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.charcoal.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                    // ── FIX: Dynamic Icon at Label ──
                    isReady
                        ? Icons.directions_car_rounded
                        : Icons.near_me_rounded,
                    size: 14,
                    color: isReady ? AppColors.teal : AppColors.primary),
                const SizedBox(width: 6),
                Text(isReady ? 'On the way' : 'En Route',
                    style: GoogleFonts.plusJakartaSans(
                        color: AppColors.captionText,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$count',
                    style: GoogleFonts.plusJakartaSans(
                        color: AppColors.charcoal,
                        fontSize: 20,
                        fontWeight: FontWeight.w800),
                  ),
                  TextSpan(
                    text: ' / $total',
                    style: GoogleFonts.plusJakartaSans(
                        color: AppColors.captionText,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
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

class _ActionButton extends StatelessWidget {
  final VoidCallback? onTap;
  final bool active;
  final Color activeColor;
  final IconData activeIcon;
  final IconData idleIcon;
  final String activeLabel;
  final String idleLabel;

  const _ActionButton({
    required this.onTap,
    required this.active,
    required this.activeColor,
    required this.activeIcon,
    required this.idleIcon,
    required this.activeLabel,
    required this.idleLabel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: active ? activeColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: active
                  ? activeColor.withOpacity(0.3)
                  : AppColors.charcoal.withOpacity(0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ],
          border: Border.all(
            color: active ? activeColor : AppColors.divider.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(active ? activeIcon : idleIcon,
                color: active ? Colors.white : AppColors.charcoal, size: 18),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                active ? activeLabel : idleLabel,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.plusJakartaSans(
                  color: active ? Colors.white : AppColors.charcoal,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32), topRight: Radius.circular(32)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 48,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Text('Report a Delay',
                style: GoogleFonts.plusJakartaSans(
                    color: AppColors.charcoal,
                    fontSize: 22,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text('Adjusting your ETA will notify the group.',
                style: GoogleFonts.plusJakartaSans(
                    color: AppColors.captionText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _options.map((mins) {
                final bool isSelected = _selectedMins == mins;
                return GestureDetector(
                  onTap: () => setState(() => _selectedMins = mins),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 14),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.urgent : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: isSelected
                              ? AppColors.urgent
                              : AppColors.divider),
                    ),
                    child: Text(
                      '+$mins m',
                      style: GoogleFonts.plusJakartaSans(
                        color:
                            isSelected ? Colors.white : AppColors.bodyText,
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
                  backgroundColor: AppColors.urgent,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: Text('Confirm Delay',
                    style: GoogleFonts.plusJakartaSans(
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