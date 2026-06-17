import 'dart:ui'; // 1. Kailangan para sa ImageFilter.blur
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../widgets/map_container.dart';
import '../widgets/alert_modal.dart';

class InitializationScreen extends StatefulWidget {
  const InitializationScreen({super.key});

  @override
  State<InitializationScreen> createState() => _InitializationScreenState();
}

class _InitializationScreenState extends State<InitializationScreen> {
  bool _alertVisible = false;
  String _pinnedLabel = 'Custom Pin';
  bool _pinSet = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.charcoal,
      body: Stack(
        children: [
          // Full screen map (Ito mismo ang magiging background na mabu-blur sa ilalim ng glass)
          Positioned.fill(
            child: MapContainer(
              height: double.infinity,
              showPin: _pinSet,
              showCrosshairs: !_pinSet,
              pinLabel: _pinnedLabel,
            ),
          ),

          // ── Top bar ────────────────────────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  // Glassy Set Meetup Point
                  GlassContainer(
                    borderRadius: 14,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add_location_alt_rounded,
                            color: AppColors.primary, size: 18),
                        SizedBox(width: 8),
                        Text('Set Meetup Point',
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Glassy Alert Button
                  GestureDetector(
                    onTap: () => setState(() => _alertVisible = !_alertVisible),
                    child: GlassContainer(
                      borderRadius: 14,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      color: _alertVisible
                          ? AppColors.urgent.withOpacity(0.75)
                          : AppColors.urgent.withOpacity(0.15),
                      borderColor: _alertVisible
                          ? AppColors.urgent
                          : AppColors.urgent.withOpacity(0.4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.warning_rounded,
                              color: _alertVisible
                                  ? Colors.white
                                  : AppColors.urgent,
                              size: 18),
                          const SizedBox(width: 6),
                          Text(
                            'Alerts',
                            style: TextStyle(
                              color: _alertVisible
                                  ? Colors.white
                                  : AppColors.urgent,
                              fontSize: 13,
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
          ),

          // ── Bottom panel ───────────────────────────────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Location search field (Glassified)
                    GlassContainer(
                      borderRadius: 14,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          const Icon(Icons.search_rounded,
                              color: Colors.black54, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _pinSet
                                  ? _pinnedLabel
                                  : 'Search or tap map to pin…',
                              style: TextStyle(
                                color:
                                    _pinSet ? Colors.black87 : Colors.black54,
                                fontSize: 14,
                                fontWeight:
                                    _pinSet ? FontWeight.w700 : FontWeight.w600,
                              ),
                            ),
                          ),
                          if (_pinSet)
                            GestureDetector(
                              onTap: () => setState(() {
                                _pinSet = false;
                                _pinnedLabel = 'Custom Pin';
                              }),
                              child: const Icon(Icons.close_rounded,
                                  color: Colors.black54, size: 18),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Quick-pin suggestions
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _QuickPin(
                              label: 'Eastwood Mall',
                              onTap: () => setState(() {
                                    _pinnedLabel = 'Eastwood City Mall';
                                    _pinSet = true;
                                  })),
                          const SizedBox(width: 8),
                          _QuickPin(
                              label: 'SM North EDSA',
                              onTap: () => setState(() {
                                    _pinnedLabel = 'SM North EDSA';
                                    _pinSet = true;
                                  })),
                          const SizedBox(width: 8),
                          _QuickPin(
                              label: 'Trinoma',
                              onTap: () => setState(() {
                                    _pinnedLabel = 'Trinoma Mall';
                                    _pinSet = true;
                                  })),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Confirm button (Glassified Animated Button)
                    SizedBox(
                      width: double.infinity,
                      child: GestureDetector(
                        onTap:
                            _pinSet ? () => _showConfirmSnack(context) : null,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              if (_pinSet)
                                BoxShadow(
                                    color: AppColors.primary.withOpacity(0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4)),
                            ],
                          ),
                          child: GlassContainer(
                            borderRadius: 14,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            color: _pinSet
                                ? AppColors.primary.withOpacity(0.85)
                                : Colors.white.withOpacity(0.25),
                            borderColor: _pinSet
                                ? AppColors.primary
                                : Colors.white.withOpacity(0.4),
                            child: Center(
                              child: Text(
                                _pinSet
                                    ? 'Confirm Meetup Point'
                                    : 'Tap map to pin a location',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color:
                                      _pinSet ? Colors.white : Colors.black54,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Alert modal overlay (With Dark Glass Backdrop) ─────────────────
          if (_alertVisible)
            Positioned.fill(
              child: GestureDetector(
                onTap: () => setState(() => _alertVisible = false),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                      sigmaX: 5.0,
                      sigmaY: 5.0), // Blurred out background kapag may modal
                  child: Container(color: Colors.black.withOpacity(0.4)),
                ),
              ),
            ),
          if (_alertVisible)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                top: false,
                child: UrgentDepartureModal(
                    onDismiss: () => setState(() => _alertVisible = false)),
              ),
            ),
        ],
      ),
    );
  }

  void _showConfirmSnack(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Meetup point set: $_pinnedLabel 📍'),
        backgroundColor: AppColors.teal,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}

class _QuickPin extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _QuickPin({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        borderRadius: 10,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        color: Colors.white.withOpacity(
            0.35), // Mas mataas nang unti opacity para madaling basahin
        child: Text(label,
            style: const TextStyle(
                color: Colors.black87,
                fontSize: 12,
                fontWeight: FontWeight.w700)),
      ),
    );
  }
}

// ── Reusable Glass Container ─────────────────────────────────────────────────
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Color? borderColor;

  const GlassContainer({
    super.key,
    required this.child,
    this.borderRadius = 14.0,
    this.padding,
    this.color,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: color ??
                Colors.white.withOpacity(0.25), // Map-friendly default opacity
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: borderColor ?? Colors.white.withOpacity(0.4),
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
