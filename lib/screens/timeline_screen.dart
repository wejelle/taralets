import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/timeline_activity.dart';
import '../widgets/star_rating.dart';

class TimelineScreen extends StatefulWidget {
  final String tripName;
  final String location;
  final TimeOfDay? targetTime;
  final int reportedDelayMinutes;

  const TimelineScreen({
    super.key,
    this.tripName = 'Trip Timeline',
    this.location = 'Target Destination',
    this.targetTime,
    this.reportedDelayMinutes = 0,
  });

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

  String _calculateDepartureTime() {
    if (widget.targetTime == null) return "Not set";

    int travelTime = 30;
    int totalMinutes = widget.targetTime!.hour * 60 + widget.targetTime!.minute;
    int currentDelay = widget.reportedDelayMinutes;
    int departureMinutes = totalMinutes - travelTime + currentDelay;

    while (departureMinutes < 0) {
      departureMinutes += 24 * 60;
    }
    departureMinutes = departureMinutes % (24 * 60);

    int hour = (departureMinutes / 60).floor();
    int minute = (departureMinutes % 60).toInt();

    final period = hour >= 12 ? "PM" : "AM";
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    final displayMinute = minute.toString().padLeft(2, '0');

    return "$displayHour:$displayMinute $period";
  }

  @override
  void dispose() {
    _toastTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // FIX: Nilagyan ng explicitly 'userRating: 0' at 'canRate: false' para
    // maiwasan ang "type 'Null' is not a subtype of type 'int'" crash!
    if (widget.targetTime != null && _activities.isNotEmpty) {
      _activities[0] = TimelineActivity(
        id: 'a1',
        title: 'Meet-up at ${widget.location}',
        location: widget.location,
        timeLabel: widget.targetTime!.format(context),
        description: 'Everyone converges here at the target arrival time.',
        status: ActivityStatus.inProgress,
        userRating: 0,
        canRate: false,
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFE0C3FC), Color(0xFF8EC5FC)],
              ),
            ),
          ),
          SafeArea(
            child: Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.tripName,
                                style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 26,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.5)),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Leave by: ${_calculateDepartureTime()} 🚗',
                                style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
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
                            onRate: (rating) => setState(
                                () => _activities[i].userRating = rating),
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
                  child: _StatusToast(
                      onDismiss: () => setState(() => _toastVisible = false)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineNode extends StatelessWidget {
  final TimelineActivity activity;
  final bool isLast;
  final ValueChanged<int> onRate;

  const _TimelineNode(
      {required this.activity, required this.isLast, required this.onRate});

  @override
  Widget build(BuildContext context) {
    final Color nodeColor;
    final Color nodeBg;
    final IconData nodeIcon;

    switch (activity.status) {
      case ActivityStatus.completed:
        nodeColor = AppColors.teal;
        nodeBg = AppColors.teal.withOpacity(0.2);
        nodeIcon = Icons.check_rounded;
        break;
      case ActivityStatus.inProgress:
        nodeColor = AppColors.primary;
        nodeBg = AppColors.primary.withOpacity(0.2);
        nodeIcon = Icons.play_arrow_rounded;
        break;
      case ActivityStatus.upcoming:
        nodeColor = Colors.black38;
        nodeBg = Colors.white.withOpacity(0.2);
        nodeIcon = Icons.circle_outlined;
        break;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                    color: nodeBg,
                    shape: BoxShape.circle,
                    border: Border.all(color: nodeColor, width: 2)),
                child: Icon(nodeIcon, color: nodeColor, size: 16),
              ),
              if (!isLast)
                Expanded(
                    child: Container(
                        width: 2,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        color: Colors.black12)),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text(activity.timeLabel,
                          style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                              fontWeight: FontWeight.w700)),
                      if (activity.status == ActivityStatus.inProgress) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6)),
                          child: const Text('Now',
                              style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800)),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: activity.status == ActivityStatus.inProgress
                              ? Colors.white.withOpacity(0.45)
                              : Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color:
                                  activity.status == ActivityStatus.inProgress
                                      ? AppColors.primary.withOpacity(0.5)
                                      : Colors.white.withOpacity(0.4),
                              width: 1.5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(activity.title,
                                style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700)),
                            const SizedBox(height: 3),
                            Row(
                              children: [
                                const Icon(Icons.place_outlined,
                                    size: 12, color: Colors.black54),
                                const SizedBox(width: 2),
                                Expanded(
                                    child: Text(activity.location,
                                        style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 11),
                                        overflow: TextOverflow.ellipsis)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(activity.description,
                                style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 12,
                                    height: 1.5)),
                            if (activity.status == ActivityStatus.completed &&
                                activity.canRate) ...[
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.white.withOpacity(0.2))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Rate Your Experience',
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700)),
                                    const SizedBox(height: 8),
                                    StarRating(
                                        rating: activity.userRating,
                                        interactive: true,
                                        size: 26,
                                        onChanged: onRate),
                                    if (activity.userRating > 0) ...[
                                      const SizedBox(height: 6),
                                      Text(_ratingLabel(activity.userRating),
                                          style: const TextStyle(
                                              color: AppColors.teal,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w800)),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
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
      case 1:
        return 'Not great 😬';
      case 2:
        return 'It was okay 🤷';
      case 3:
        return 'Pretty good! 👍';
      case 4:
        return 'Really fun! 😄';
      case 5:
        return 'Absolutely loved it! 🔥';
      default:
        return '';
    }
  }
}

class _StatusToast extends StatelessWidget {
  final VoidCallback onDismiss;
  const _StatusToast({required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.55),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 6))
            ],
          ),
          child: Row(
            children: [
              Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                      color: AppColors.teal, shape: BoxShape.circle)),
              const SizedBox(width: 10),
              Expanded(
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 13, height: 1.4),
                    children: [
                      TextSpan(
                          text: 'Travel Monitoring',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700)),
                      TextSpan(
                          text: ' is active. Real-time updates enabled. 📡',
                          style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                  onTap: onDismiss,
                  child: Icon(Icons.close_rounded,
                      color: Colors.white.withOpacity(0.6), size: 18)),
            ],
          ),
        ),
      ),
    );
  }
}
