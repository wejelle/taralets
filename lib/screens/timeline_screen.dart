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
  bool _isOptimizing = false;

  @override
  void initState() {
    super.initState();
    _activities = TimelineActivity.mockActivitiesList;
    _toastTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) setState(() => _toastVisible = false);
    });
  }

  @override
  void dispose() {
    _toastTimer?.cancel();
    super.dispose();
  }

  // BAGO: Logic para ma-calculate ang dynamic ETA ng timeline elements (Image 5 logic)
  String _calculateDynamicTime(int index) {
    final now = TimeOfDay.now();
    // Default start time natin is Target Time or current time + 1 hour
    int baseMinutes = widget.targetTime != null
        ? (widget.targetTime!.hour * 60) + widget.targetTime!.minute
        : (now.hour * 60) + now.minute + 60;

    // Ina-apply natin ang reported delays para mag-adjust buong timeline
    baseMinutes += widget.reportedDelayMinutes;

    // Bawat sunod na activity ay ina-assume nating +75 mins away for demo
    int accumulatedMinutes = baseMinutes + (index * 75);

    final h = (accumulatedMinutes ~/ 60) % 24;
    final m = accumulatedMinutes % 60;

    final ampm = h >= 12 ? 'PM' : 'AM';
    final displayH = h > 12 ? h - 12 : (h == 0 ? 12 : h);

    return '$displayH:${m.toString().padLeft(2, '0')} $ampm';
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final TimelineActivity item = _activities.removeAt(oldIndex);
      _activities.insert(newIndex, item);
    });
  }

  void _optimizeSchedule() {
    setState(() => _isOptimizing = true);
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        setState(() {
          _isOptimizing = false;
          _activities.sort((a, b) => b.title.length.compareTo(a.title.length));
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Row(
            children: [
              Icon(Icons.auto_awesome, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Text('AI Route Optimization complete! Times recalculated.'),
            ],
          ),
          backgroundColor: AppColors.teal,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ));
      }
    });
  }

  // BAGO: Interactive Check for the "Play/Active" button to move downward
  void _markCurrentAsDone(int index) {
    setState(() {
      if (_activities[index].status == ActivityStatus.upcoming) {
        _activities[index].status = ActivityStatus.inProgress; // Simulan muna
      } else {
        _activities[index].status =
            ActivityStatus.completed; // Pag ni-click ulit, Done na
        if (index + 1 < _activities.length) {
          _activities[index + 1].status =
              ActivityStatus.inProgress; // Move sa next
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Sumusunod sa MainShell
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.tripName,
                          style: const TextStyle(
                              color: AppColors.charcoal,
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5)),
                      const SizedBox(height: 2),
                      Text(
                          'Dynamic Start based on ETA • ${widget.reportedDelayMinutes > 0 ? "Delayed" : "On Time"}',
                          style: TextStyle(
                              color: widget.reportedDelayMinutes > 0
                                  ? AppColors.urgent
                                  : AppColors.bodyText,
                              fontSize: 13,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _isOptimizing ? null : _optimizeSchedule,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.6),
                            foregroundColor: AppColors.primary,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                                side: BorderSide(
                                    color: AppColors.primary.withOpacity(0.3),
                                    width: 1.5)),
                          ),
                          icon: _isOptimizing
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: AppColors.primary))
                              : const Icon(Icons.auto_awesome, size: 18),
                          label: Text(
                            _isOptimizing
                                ? 'AI Analyzing Route Vectors...'
                                : 'AI Optimize Schedule',
                            style: const TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 13),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
                Expanded(
                  child: ReorderableListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                    itemCount: _activities.length,
                    onReorder: _onReorder,
                    buildDefaultDragHandles: false,
                    proxyDecorator:
                        (Widget child, int index, Animation<double> animation) {
                      return Material(
                        elevation: 12,
                        color: Colors.transparent,
                        shadowColor: Colors.black26,
                        borderRadius: BorderRadius.circular(16),
                        child: child,
                      );
                    },
                    itemBuilder: (context, index) {
                      final act = _activities[index];
                      // Kinukuha ang dynamic calculated time natin
                      final assignedTime = _calculateDynamicTime(index);

                      return ReorderableDragStartListener(
                        key: ValueKey(act.id),
                        index: index,
                        child: _TimelineNode(
                          activity: act,
                          displayTime: assignedTime,
                          isLast: index == _activities.length - 1,
                          onRate: (rating) =>
                              setState(() => act.userRating = rating),
                          onComplete: () => _markCurrentAsDone(
                              index), // Pinapasa yung action function
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            bottom: _toastVisible
                ? 100
                : -80, // Inangat ko pataas nang kaunti para di matakpan ng nav
            left: 20,
            right: 20,
            child: _StatusToast(
                onDismiss: () => setState(() => _toastVisible = false)),
          ),
        ],
      ),
    );
  }
}

// ── Timeline Node Structural Element ──────────────────────────────────────────

class _TimelineNode extends StatefulWidget {
  final TimelineActivity activity;
  final String displayTime;
  final bool isLast;
  final ValueChanged<int> onRate;
  final VoidCallback onComplete;

  const _TimelineNode({
    required this.activity,
    required this.displayTime,
    required this.isLast,
    required this.onRate,
    required this.onComplete,
  });

  @override
  State<_TimelineNode> createState() => _TimelineNodeState();
}

class _TimelineNodeState extends State<_TimelineNode> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final Color nodeColor;
    final Color nodeBg;
    final IconData nodeIcon;

    switch (widget.activity.status) {
      case ActivityStatus.completed:
        nodeColor = AppColors.teal;
        nodeBg = AppColors.teal.withOpacity(0.12);
        nodeIcon = Icons.check_rounded;
        break;
      case ActivityStatus.inProgress:
        nodeColor = AppColors.primary;
        nodeBg = AppColors.primary.withOpacity(0.12);
        nodeIcon = Icons.play_arrow_rounded;
        break;
      case ActivityStatus.upcoming:
        nodeColor = Colors.black38;
        nodeBg = Colors.white.withOpacity(0.5);
        nodeIcon = Icons.circle_outlined;
        break;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                      color: nodeBg,
                      shape: BoxShape.circle,
                      border: Border.all(color: nodeColor, width: 2)),
                  child: Icon(nodeIcon, color: nodeColor, size: 15),
                ),
                if (!widget.isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: widget.activity.status == ActivityStatus.completed
                          ? AppColors.teal
                          : Colors.white.withOpacity(0.5),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          widget.displayTime,
                          style: const TextStyle(
                              color: AppColors.charcoal,
                              fontSize: 12,
                              fontWeight: FontWeight.w900),
                        ),
                        if (widget.activity.status ==
                            ActivityStatus.inProgress) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(6)),
                            child: const Text('ACTIVE NOW',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.5)),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    AnimatedScale(
                      scale: _isHovered ? 1.02 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white
                                  .withOpacity(_isHovered ? 0.7 : 0.4),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: widget.activity.status ==
                                        ActivityStatus.inProgress
                                    ? AppColors.primary.withOpacity(0.5)
                                    : Colors.white.withOpacity(0.6),
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(widget.activity.title,
                                              style: const TextStyle(
                                                  color: AppColors.charcoal,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w900)),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              const Icon(
                                                  Icons.location_on_outlined,
                                                  size: 13,
                                                  color: AppColors.captionText),
                                              const SizedBox(width: 3),
                                              Expanded(
                                                  child: Text(
                                                      widget.activity.location,
                                                      style: const TextStyle(
                                                          color: AppColors
                                                              .bodyText,
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                      overflow: TextOverflow
                                                          .ellipsis)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(left: 6.0, top: 2.0),
                                      child: Icon(Icons.drag_indicator_rounded,
                                          color: Colors.black26, size: 20),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(widget.activity.description,
                                    style: TextStyle(
                                        color:
                                            AppColors.charcoal.withOpacity(0.8),
                                        fontSize: 12,
                                        height: 1.45)),

                                // BAGO: Interactive Checkbox for "In Progress" activities
                                if (widget.activity.status ==
                                    ActivityStatus.inProgress) ...[
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      onPressed: widget.onComplete,
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.teal,
                                          foregroundColor: Colors.white,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10))),
                                      icon: const Icon(
                                          Icons.check_circle_rounded,
                                          size: 16),
                                      label: const Text("Mark as Completed",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 12)),
                                    ),
                                  )
                                ],

                                if (widget.activity.status ==
                                        ActivityStatus.completed &&
                                    widget.activity.canRate) ...[
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.6),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.white),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('Rate Your Experience',
                                            style: TextStyle(
                                                color: AppColors.charcoal,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w800)),
                                        const SizedBox(height: 8),
                                        StarRating(
                                          rating: widget.activity.userRating,
                                          interactive: true,
                                          size: 24,
                                          onChanged: widget.onRate,
                                        ),
                                        if (widget.activity.userRating > 0) ...[
                                          const SizedBox(height: 6),
                                          Text(
                                            _ratingLabel(
                                                widget.activity.userRating),
                                            style: const TextStyle(
                                                color: AppColors.teal,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w900),
                                          ),
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
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.black87.withOpacity(0.8),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                    color: AppColors.teal, shape: BoxShape.circle),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 12, height: 1.4),
                    children: [
                      TextSpan(
                          text: 'Dinner Together',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800)),
                      TextSpan(
                          text:
                              ' is currently active. 4 members marked arrived.',
                          style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onDismiss,
                child: Icon(Icons.close_rounded,
                    color: Colors.white.withOpacity(0.6), size: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
