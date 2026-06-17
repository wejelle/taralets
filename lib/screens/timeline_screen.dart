import 'dart:async';
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

  // SAMPLE TIME SLOTS: Dito manggagaling ang dynamic time coordination natin
  final List<String> _dynamicTimeSlots = [
    '3:00 PM',
    '4:15 PM',
    '5:30 PM',
    '7:00 PM',
    '8:45 PM',
    '10:15 PM'
  ];

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

  // SAMPLE FUNCTION: Dynamic updating of sequence on item drop
  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final TimelineActivity item = _activities.removeAt(oldIndex);
      _activities.insert(newIndex, item);
    });
  }

  // SAMPLE AI FLOW: Iniaayos ang schedule sa pinaka-efficient na pagkakasunod-sunod
  void _optimizeSchedule() {
    setState(() => _isOptimizing = true);
    
    // Inayos natin into 2.5 seconds para mabilis makita sa demo niyo!
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        setState(() {
          _isOptimizing = false;
          
          // AI Sort simulation: Inilalagay ang mahahalagang activities sa pinaka-swak na oras
          _activities.sort((a, b) => b.title.length.compareTo(a.title.length));
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.auto_awesome, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text('AI Route Optimization complete! Times recalculated.'),
              ],
            ),
            backgroundColor: AppColors.teal,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          )
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ── PREMIUM ACCENT BACKGROUND ──────────────────────────────────
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(88, 255, 99, 151), // 0.35 opacity ng E0C3FC
              ),
            ),
          ),
          Positioned(
            bottom: 150,
            left: -150,
            child: Container(
              width: 350,
              height: 350,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(64, 255, 170, 113), // 0.25 opacity ng 8EC5FC
              ),
            ),
          ),

          // ── MAIN CONTENT LAYER ─────────────────────────────────────────
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
                              color: Colors.black87,
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5)),
                      const SizedBox(height: 2),
                      const Text('Saturday, Jun 21 · Eastwood City',
                          style: TextStyle(color: Colors.black54, fontSize: 13)),
                      const SizedBox(height: 16),
                      
                      // AI Action Trigger Panel
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _isOptimizing ? null : _optimizeSchedule,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary.withOpacity(0.08),
                            foregroundColor: AppColors.primary,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                              side: BorderSide(color: AppColors.primary.withOpacity(0.2), width: 1.5)
                            ),
                          ),
                          icon: _isOptimizing 
                            ? SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.primary))
                            : const Icon(Icons.auto_awesome, size: 18),
                          label: Text(
                            _isOptimizing ? 'AI Analyzing Group Vectors...' : 'AI Optimize Schedule',
                            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // Instructions Label
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade200)
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.swap_vert_rounded, size: 16, color: AppColors.primary),
                            const SizedBox(width: 6),
                            Text(
                              'Drag cards to rearrange. Times adjust automatically.',
                              style: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Interactive Drag & Drop Board List
                Expanded(
                  child: ReorderableListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                    itemCount: _activities.length,
                    onReorder: _onReorder,
                    buildDefaultDragHandles: false, 
                    proxyDecorator: (Widget child, int index, Animation<double> animation) {
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
                      // Kinukuha ang time label mula sa fixed chronological slots natin para magbago pwesto man siya!
                      final assignedTime = index < _dynamicTimeSlots.length 
                          ? _dynamicTimeSlots[index] 
                          : act.timeLabel;

                      return ReorderableDragStartListener(
                        key: ValueKey(act.id),
                        index: index,
                        child: _TimelineNode(
                          activity: act,
                          displayTime: assignedTime, // Dynamic allocation inject
                          isLast: index == _activities.length - 1,
                          onRate: (rating) => setState(() => act.userRating = rating),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Real-time notification layer overlay
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
    );
  }
}

// ── Timeline Node Structural Element ──────────────────────────────────────────

class _TimelineNode extends StatelessWidget {
  final TimelineActivity activity;
  final String displayTime; // Dynamic time placeholder object
  final bool isLast;
  final ValueChanged<int> onRate;

  const _TimelineNode({
    required this.activity,
    required this.displayTime,
    required this.isLast,
    required this.onRate,
  });

  @override
  Widget build(BuildContext context) {
    final Color nodeColor;
    final Color nodeBg;
    final IconData nodeIcon;

    switch (activity.status) {
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
        nodeBg = Colors.grey.shade100;
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
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                    color: nodeBg,
                    shape: BoxShape.circle,
                    border: Border.all(color: nodeColor, width: 2)),
                child: Icon(nodeIcon, color: nodeColor, size: 15),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: Colors.grey.shade200,
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
                      // Dynamic parsed timestamp wrapper
                      Text(
                        displayTime,
                        style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 12,
                            fontWeight: FontWeight.w800),
                      ),
                      if (activity.status == ActivityStatus.inProgress) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(6)),
                          child: Text('ACTIVE NOW',
                              style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.2)),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: activity.status == ActivityStatus.inProgress
                            ? AppColors.primary.withOpacity(0.35)
                            : Colors.grey.shade200,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 12,
                          offset: const Offset(0, 4)
                        )
                      ]
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(activity.title,
                                      style: const TextStyle(
                                          color: Colors.black87,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800)),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on_outlined,
                                          size: 13, color: Colors.black45),
                                      const SizedBox(width: 3),
                                      Expanded(
                                          child: Text(activity.location,
                                              style: const TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w500),
                                              overflow: TextOverflow.ellipsis)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 6.0, top: 2.0),
                              child: Icon(Icons.drag_indicator_rounded, color: Colors.black26, size: 20),
                            )
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(activity.description,
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.65),
                                fontSize: 12,
                                height: 1.45)),
                        if (activity.status == ActivityStatus.completed &&
                            activity.canRate) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
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
                                  size: 24,
                                  onChanged: onRate,
                                ),
                                if (activity.userRating > 0) ...[
                                  const SizedBox(height: 6),
                                  Text(
                                    _ratingLabel(activity.userRating),
                                    style: const TextStyle(
                                        color: AppColors.teal,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800),
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

// ── Toast Status Component ─────────────────────────────────────────────────────

class _StatusToast extends StatelessWidget {
  final VoidCallback onDismiss;
  const _StatusToast({required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 16,
              offset: const Offset(0, 6))
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
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
                          fontWeight: FontWeight.w700)),
                  TextSpan(
                      text:
                          ' is currently active. 5 members marked arrived.',
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
    );
  }
}