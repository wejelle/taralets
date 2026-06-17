import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/group_member.dart';

class MapContainer extends StatefulWidget {
  final double height;
  final bool showPin;
  final bool showCrosshairs;
  final String? pinLabel;
  final List<GroupMember> members;
  final bool isReady;

  const MapContainer({
    super.key,
    this.height = 220,
    this.showPin = true,
    this.showCrosshairs = false,
    this.pinLabel,
    this.members = const [],
    this.isReady = false,
  });

  @override
  State<MapContainer> createState() => _MapContainerState();
}

class _MapContainerState extends State<MapContainer>
    with TickerProviderStateMixin {
  AnimationController? _lineController;
  AnimationController? _othersController;
  AnimationController? _userController;

  @override
  void initState() {
    super.initState();
    _lineController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _othersController =
        AnimationController(vsync: this, duration: const Duration(seconds: 45));
    _userController =
        AnimationController(vsync: this, duration: const Duration(seconds: 45));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _lineController?.repeat();
        _othersController?.forward();
        if (widget.isReady) _userController?.forward();
      }
    });
  }

  @override
  void didUpdateWidget(MapContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isReady != oldWidget.isReady) {
      if (widget.isReady) {
        _userController?.forward();
      } else {
        _userController?.stop();
      }
    }
  }

  @override
  void dispose() {
    _lineController?.dispose();
    _othersController?.dispose();
    _userController?.dispose();
    super.dispose();
  }

  Alignment _getOrthogonalAlignment(
      Alignment start, Alignment end, double progress, bool horizontalFirst) {
    Alignment corner =
        horizontalFirst ? Alignment(end.x, start.y) : Alignment(start.x, end.y);

    double dx1 = corner.x - start.x;
    double dy1 = corner.y - start.y;
    double dist1 = sqrt(dx1 * dx1 + dy1 * dy1);

    double dx2 = end.x - corner.x;
    double dy2 = end.y - corner.y;
    double dist2 = sqrt(dx2 * dx2 + dy2 * dy2);

    double totalDist = dist1 + dist2;
    if (totalDist == 0) return start;

    double currentDist = progress * totalDist;

    if (currentDist <= dist1) {
      double t = dist1 == 0 ? 0 : currentDist / dist1;
      return Alignment(start.x + dx1 * t, start.y + dy1 * t);
    } else {
      double t = dist2 == 0 ? 0 : (currentDist - dist1) / dist2;
      return Alignment(corner.x + dx2 * t, corner.y + dy2 * t);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: widget.height,
        child: Stack(
          children: [
            // ── 1. GOOGLE MAPS PLACEHOLDER ──
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFE5E9EA),
              ),
              child: const Center(
                child: Text(
                    'Google Maps Image Placeholder\n(Uncomment image code here)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black26,
                        fontWeight: FontWeight.bold,
                        fontSize: 12)),
              ),
            ),

            // ── 2. SIMULATED CLUSTERED PINS (Prototype) ──
            const Positioned(
              top: 40,
              right: 50,
              child: _ClusterMarker(count: 3, label: 'Cafes'),
            ),
            const Positioned(
              bottom: 60,
              left: 30,
              child: _ClusterMarker(count: 5, label: 'Activities'),
            ),

            // ── 3. ANIMATED ORTHOGONAL ROUTE LINES ──
            if (_lineController != null)
              AnimatedBuilder(
                  animation: _lineController!,
                  builder: (context, child) {
                    return CustomPaint(
                      size: Size(double.infinity, widget.height),
                      painter: _RoutePainter(
                        members: widget.members,
                        isReady: widget.isReady,
                        animationValue: _lineController!.value,
                      ),
                    );
                  }),

            if (widget.showCrosshairs) _Crosshairs(),

            // ── 4. GUMAGALAW NA MEMBERS (Avatars) ──
            if (_othersController != null && _userController != null)
              Positioned.fill(
                child: AnimatedBuilder(
                  animation:
                      Listenable.merge([_othersController!, _userController!]),
                  builder: (context, child) {
                    List<Widget> markers = [];

                    // BAGO: Finilter out natin yung isCurrentUser (You/Jewelle) para walang duplicate
                    final otherMembers =
                        widget.members.where((m) => !m.isCurrentUser).toList();

                    otherMembers.asMap().forEach((idx, member) {
                      double xOffset =
                          (idx % 2 == 0 ? 0.8 : -0.8) * (1 + (idx / 2) * 0.15);
                      double yOffset = (idx % 3 == 0 ? 0.75 : -0.75) *
                          (1 + (idx / 3) * 0.15);
                      Alignment startAlign = Alignment(
                          xOffset.clamp(-0.9, 0.9), yOffset.clamp(-0.9, 0.9));
                      bool horizontalFirst = idx % 2 == 0;

                      double progress = _othersController!.value * 0.85;
                      Alignment currentAlign = _getOrthogonalAlignment(
                          startAlign,
                          Alignment.center,
                          progress,
                          horizontalFirst);

                      markers.add(Align(
                        alignment: currentAlign,
                        child: _MemberMarker(
                            name: member.name.split(' ')[0],
                            isMoving: widget
                                .isReady, // BAGO: Aandar lang if 4/4 ready
                            color: member.avatarColor),
                      ));
                    });

                    // Ito yung dedicated marker para sa'yo
                    Alignment startAlignYou = const Alignment(0.0, 0.85);
                    double progressYou = _userController!.value * 0.85;
                    Alignment currentAlignYou = _getOrthogonalAlignment(
                        startAlignYou, Alignment.center, progressYou, true);

                    markers.add(Align(
                      alignment: currentAlignYou,
                      child: _MemberMarker(
                          name: 'You',
                          isMoving: widget.isReady,
                          color: widget.isReady
                              ? AppColors.teal
                              : AppColors.urgent),
                    ));

                    return Stack(children: markers);
                  },
                ),
              ),

            // Destination Pin
            if (widget.showPin)
              _MeetupPin(label: widget.pinLabel ?? 'Eastwood City Mall'),

            // UI Overlay Text
            Positioned(
              top: 12,
              left: 14,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.92),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 6)
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                        widget.isReady
                            ? Icons.radar_rounded
                            : Icons.location_on,
                        color:
                            widget.isReady ? AppColors.teal : AppColors.primary,
                        size: 14),
                    const SizedBox(width: 4),
                    Text(
                      widget.isReady ? 'Live Routing Active' : 'Meetup Map',
                      style: const TextStyle(
                          color: AppColors.charcoal,
                          fontSize: 12,
                          fontWeight: FontWeight.w700),
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
}

class _RoutePainter extends CustomPainter {
  final List<GroupMember> members;
  final bool isReady;
  final double animationValue;

  _RoutePainter(
      {required this.members,
      required this.isReady,
      required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    for (int idx = 0; idx < members.length; idx++) {
      double xOffset = (idx % 2 == 0 ? 0.8 : -0.8) * (1 + (idx / 2) * 0.15);
      double yOffset = (idx % 3 == 0 ? 0.75 : -0.75) * (1 + (idx / 3) * 0.15);
      Alignment startAlign =
          Alignment(xOffset.clamp(-0.9, 0.9), yOffset.clamp(-0.9, 0.9));

      final memberPos = Offset(
        (startAlign.x + 1) * size.width / 2,
        (startAlign.y + 1) * size.height / 2,
      );

      final paint = Paint()
        ..color = AppColors.primary.withOpacity(0.4)
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      bool horizontalFirst = idx % 2 == 0;
      Offset corner = horizontalFirst
          ? Offset(center.dx, memberPos.dy)
          : Offset(memberPos.dx, center.dy);

      _drawOrthogonalDashedLine(
          canvas, memberPos, corner, center, paint, animationValue);
    }

    Alignment startAlignYou = const Alignment(0.0, 0.85);
    final youPos = Offset(
      (startAlignYou.x + 1) * size.width / 2,
      (startAlignYou.y + 1) * size.height / 2,
    );

    final paintYou = Paint()
      ..color = isReady
          ? AppColors.teal.withOpacity(0.8)
          : AppColors.urgent.withOpacity(0.5)
      ..strokeWidth = isReady ? 3.0 : 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset cornerYou = Offset(center.dx, youPos.dy);
    _drawOrthogonalDashedLine(canvas, youPos, cornerYou, center, paintYou,
        isReady ? animationValue : 0);
  }

  void _drawOrthogonalDashedLine(Canvas canvas, Offset p1, Offset corner,
      Offset p2, Paint paint, double phase) {
    const double dashWidth = 6;
    const double dashSpace = 4;
    const double totalLength = dashWidth + dashSpace;

    double dist1 = (corner - p1).distance;
    double dist2 = (p2 - corner).distance;
    double totalDist = dist1 + dist2;

    double startOffset = -phase * totalLength;
    double currentDist = startOffset;

    while (currentDist < totalDist) {
      double drawStart = currentDist;
      double drawEnd = currentDist + dashWidth;

      if (drawStart < 0) drawStart = 0;
      if (drawEnd > totalDist) drawEnd = totalDist;

      if (drawStart < drawEnd) {
        canvas.drawLine(
            _getPointAlongPath(p1, corner, p2, dist1, dist2, drawStart),
            _getPointAlongPath(p1, corner, p2, dist1, dist2, drawEnd),
            paint);
      }
      currentDist += totalLength;
    }
  }

  Offset _getPointAlongPath(Offset p1, Offset corner, Offset p2, double dist1,
      double dist2, double d) {
    if (d <= dist1) {
      double t = dist1 == 0 ? 0 : d / dist1;
      return Offset.lerp(p1, corner, t)!;
    } else {
      double t = dist2 == 0 ? 0 : (d - dist1) / dist2;
      return Offset.lerp(corner, p2, t)!;
    }
  }

  @override
  bool shouldRepaint(covariant _RoutePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.isReady != isReady;
  }
}

class _MemberMarker extends StatelessWidget {
  final String name;
  final bool isMoving;
  final Color color;

  const _MemberMarker(
      {required this.name, required this.isMoving, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: isMoving ? color.withOpacity(0.5) : Colors.black26,
                  blurRadius: isMoving ? 10 : 4,
                  offset: const Offset(0, 2))
            ],
          ),
          child: CircleAvatar(
            radius: 12,
            backgroundColor: isMoving ? color : AppColors.secondary,
            child: Icon(isMoving ? Icons.directions_car_rounded : Icons.person,
                size: 14, color: Colors.white),
          ),
        ),
        const SizedBox(height: 2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(4)),
          child: Text(
            name,
            style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: AppColors.charcoal),
          ),
        ),
      ],
    );
  }
}

class _MeetupPin extends StatelessWidget {
  final String label;
  const _MeetupPin({required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: AppColors.primary.withOpacity(0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4))
              ],
            ),
            child: Text(label,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700)),
          ),
          Container(width: 2, height: 12, color: AppColors.primary),
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2)),
          ),
        ],
      ),
    );
  }
}

class _Crosshairs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
              width: 40,
              height: 1.5,
              color: AppColors.charcoal.withOpacity(0.5)),
          Container(
              width: 1.5,
              height: 40,
              color: AppColors.charcoal.withOpacity(0.5)),
          Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.urgent, width: 2),
                  shape: BoxShape.circle)),
        ],
      ),
    );
  }
}

// BAGO: Widget para sa Simulated Clustered Pins
class _ClusterMarker extends StatelessWidget {
  final int count;
  final String label;

  const _ClusterMarker({required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.teal.withOpacity(0.9), // Cluster color
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
            ],
          ),
          child: Text(
            count.toString(),
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
        const SizedBox(height: 2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(4)),
          child: Text(label,
              style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87)),
        )
      ],
    );
  }
}
