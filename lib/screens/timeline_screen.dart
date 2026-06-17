import 'dart:async';
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/timeline_activity.dart';
import '../widgets/star_rating.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  late List<TimelineActivity> _activities;
  bool _toastVisible = true;
  Timer? _toastTimer;

  @override
  void initState() {
    super.initState();
    _activities = TimelineActivity.mockActivities();
    _toastTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) setState(() => _toastVisible = false);
    });
  }

  @override
  void dispose() {
    _toastTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 24, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Trip Timeline', style: TextStyle(color: AppColors.charcoal, fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
                        SizedBox(height: 2),
                        Text('Saturday, Jun 21 · Eastwood City', style: TextStyle(color: AppColors.bodyText, fontSize: 13)),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 100),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (ctx, i) => _TimelineNode(
                        activity: _activities[i],
                        isLast: i == _activities.length - 1,
                        onRate: (rating) => setState(() => _activities[i].userRating = rating),
                      ),
                      childCount: _activities.length,
                    ),
                  ),
                ),
              ],
            ),

            // Floating toast
            AnimatedPositioned(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              bottom: _toastVisible ? 24 : -80,
              left: 20,
              right: 20,
              child: _StatusToast(onDismiss: () => setState(() => _toastVisible = false)),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Timeline node ──────────────────────────────────────────────────────────────

class _TimelineNode extends StatelessWidget {
  final TimelineActivity activity;
  final bool isLast;
  final ValueChanged<int> onRate;

  const _TimelineNode({required this.activity, required this.isLast, required this.onRate});

  @override
  Widget build(BuildContext context) {
    final Color nodeColor;
    final Color nodeBg;
    final IconData nodeIcon;

    switch (activity.status) {
      case ActivityStatus.completed:
        nodeColor = AppColors.teal;
        nodeBg = AppColors.tealLight;
        nodeIcon = Icons.check_rounded;
        break;
      case ActivityStatus.inProgress:
        nodeColor = AppColors.primary;
        nodeBg = AppColors.primaryLight;
        nodeIcon = Icons.play_arrow_rounded;
        break;
      case ActivityStatus.upcoming:
        nodeColor = AppColors.captionText;
        nodeBg = AppColors.background;
        nodeIcon = Icons.circle_outlined;
        break;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline spine
          Column(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(color: nodeBg, shape: BoxShape.circle, border: Border.all(color: nodeColor, width: 2)),
                child: Icon(nodeIcon, color: nodeColor, size: 16),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: AppColors.divider,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        activity.timeLabel,
                        style: const TextStyle(color: AppColors.captionText, fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                      if (activity.status == ActivityStatus.inProgress) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(6)),
                          child: const Text('Now', style: TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.w800)),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: activity.status == ActivityStatus.inProgress ? Colors.white : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: activity.status == ActivityStatus.inProgress ? AppColors.primary.withOpacity(0.3) : AppColors.cardBorder,
                        width: activity.status == ActivityStatus.inProgress ? 1.5 : 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(activity.title, style: const TextStyle(color: AppColors.charcoal, fontSize: 14, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            const Icon(Icons.place_outlined, size: 12, color: AppColors.captionText),
                            const SizedBox(width: 2),
                            Expanded(child: Text(activity.location, style: const TextStyle(color: AppColors.captionText, fontSize: 11), overflow: TextOverflow.ellipsis)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(activity.description, style: const TextStyle(color: AppColors.bodyText, fontSize: 12, height: 1.5)),

                        // Rating widget for completed rateable activities
                        if (activity.status == ActivityStatus.completed && activity.canRate) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Rate Your Experience', style: TextStyle(color: AppColors.charcoal, fontSize: 12, fontWeight: FontWeight.w700)),
                                const SizedBox(height: 8),
                                StarRating(
                                  rating: activity.userRating,
                                  interactive: true,
                                  size: 26,
                                  onChanged: onRate,
                                ),
                                if (activity.userRating > 0) ...[
                                  const SizedBox(height: 6),
                                  Text(
                                    _ratingLabel(activity.userRating),
                                    style: const TextStyle(color: AppColors.teal, fontSize: 11, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _ratingLabel(int r) {
    switch (r) {
      case 1: return 'Not great 😬';
      case 2: return 'It was okay 🤷';
      case 3: return 'Pretty good! 👍';
      case 4: return 'Really fun! 😄';
      case 5: return 'Absolutely loved it! 🔥';
      default: return '';
    }
  }
}

// ── Status toast ───────────────────────────────────────────────────────────────

class _StatusToast extends StatelessWidget {
  final VoidCallback onDismiss;
  const _StatusToast({required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.charcoal,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 20, offset: const Offset(0, 6))],
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(color: AppColors.teal, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 13, height: 1.4),
                children: [
                  const TextSpan(text: 'Dinner Together', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                  TextSpan(text: ' is in progress. All 5 members have checked in. 🎉', style: TextStyle(color: Colors.white.withOpacity(0.7))),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onDismiss,
            child: Icon(Icons.close_rounded, color: Colors.white.withOpacity(0.5), size: 18),
          ),
        ],
      ),
    );
  }
}
