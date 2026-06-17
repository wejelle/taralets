import 'package:flutter/material.dart';
import '../constants/colors.dart';

class MapContainer extends StatelessWidget {
  final double height;
  final bool showPin;
  final bool showCrosshairs;
  final String? pinLabel;

  const MapContainer({
    super.key,
    this.height = 220,
    this.showPin = true,
    this.showCrosshairs = false,
    this.pinLabel,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: height,
        child: Stack(
          children: [
            // Stylized map background
            _MockMapBackground(),
            // Grid lines overlay
            CustomPaint(
              size: Size(double.infinity, height),
              painter: _GridPainter(),
            ),
            // Roads overlay
            CustomPaint(
              size: Size(double.infinity, height),
              painter: _RoadsPainter(),
            ),
            if (showCrosshairs) _Crosshairs(),
            if (showPin) _MeetupPin(label: pinLabel ?? 'Eastwood City Mall'),
            // Branding overlay
            Positioned(
              top: 12,
              left: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.92),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.location_on, color: AppColors.primary, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'Meetup Map',
                      style: TextStyle(
                        color: AppColors.charcoal,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
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
}

// ── Internals ──────────────────────────────────────────────────────────────────

class _MockMapBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE8F4FD), Color(0xFFD6EAF8), Color(0xFFBFD7ED)],
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFB0C8DA).withOpacity(0.5)
      ..strokeWidth = 0.6;
    const spacing = 28.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RoadsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = Colors.white.withOpacity(0.85)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    final minorPaint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final w = size.width;
    final h = size.height;

    // Major horizontal road
    canvas.drawLine(Offset(0, h * 0.42), Offset(w, h * 0.38), roadPaint);
    // Major vertical road
    canvas.drawLine(Offset(w * 0.38, 0), Offset(w * 0.42, h), roadPaint);
    // Diagonal road
    canvas.drawLine(Offset(0, h * 0.7), Offset(w * 0.6, h * 0.3), minorPaint);
    // Minor horizontal
    canvas.drawLine(Offset(0, h * 0.65), Offset(w, h * 0.68), minorPaint);
    // Minor vertical
    canvas.drawLine(Offset(w * 0.7, 0), Offset(w * 0.72, h), minorPaint);

    // Blocks (filled rects to simulate city blocks)
    final blockPaint = Paint()..color = const Color(0xFFCADFEE).withOpacity(0.6);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.44, h * 0.04, w * 0.24, h * 0.32), const Radius.circular(4)), blockPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.06, h * 0.44, w * 0.3, h * 0.18), const Radius.circular(4)), blockPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.44, h * 0.44, w * 0.2, h * 0.5), const Radius.circular(4)), blockPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
              boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
          ),
          Container(
            width: 2,
            height: 12,
            color: AppColors.primary,
          ),
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
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
          Container(width: 40, height: 1.5, color: AppColors.charcoal.withOpacity(0.5)),
          Container(width: 1.5, height: 40, color: AppColors.charcoal.withOpacity(0.5)),
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.urgent, width: 2),
              shape: BoxShape.circle,
              color: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
