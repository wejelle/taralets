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
          // Full screen map
          Positioned.fill(
            child: MapContainer(
              height: double.infinity,
              showPin: _pinSet,
              showCrosshairs: !_pinSet,
              pinLabel: _pinnedLabel,
            ),
          ),

          // Top bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add_location_alt_rounded, color: AppColors.primary, size: 18),
                        SizedBox(width: 8),
                        Text('Set Meetup Point', style: TextStyle(color: AppColors.charcoal, fontSize: 14, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => setState(() => _alertVisible = !_alertVisible),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: _alertVisible ? AppColors.urgent : AppColors.urgentLight,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.warning_rounded, color: _alertVisible ? Colors.white : AppColors.urgent, size: 18),
                          const SizedBox(width: 6),
                          Text(
                            'Alerts',
                            style: TextStyle(
                              color: _alertVisible ? Colors.white : AppColors.urgent,
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

          // Bottom panel
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
                    // Location search field
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12)],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search_rounded, color: AppColors.captionText, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _pinSet ? _pinnedLabel : 'Search or tap map to pin…',
                              style: TextStyle(
                                color: _pinSet ? AppColors.charcoal : AppColors.captionText,
                                fontSize: 14,
                                fontWeight: _pinSet ? FontWeight.w600 : FontWeight.w400,
                              ),
                            ),
                          ),
                          if (_pinSet)
                            GestureDetector(
                              onTap: () => setState(() { _pinSet = false; _pinnedLabel = 'Custom Pin'; }),
                              child: const Icon(Icons.close_rounded, color: AppColors.captionText, size: 18),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Quick-pin suggestions
                    Row(
                      children: [
                        _QuickPin(label: 'Eastwood Mall', onTap: () => setState(() { _pinnedLabel = 'Eastwood City Mall'; _pinSet = true; })),
                        const SizedBox(width: 8),
                        _QuickPin(label: 'SM North EDSA', onTap: () => setState(() { _pinnedLabel = 'SM North EDSA'; _pinSet = true; })),
                        const SizedBox(width: 8),
                        _QuickPin(label: 'Trinoma', onTap: () => setState(() { _pinnedLabel = 'Trinoma Mall'; _pinSet = true; })),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Confirm button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _pinSet ? () => _showConfirmSnack(context) : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          disabledBackgroundColor: AppColors.divider,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                        ),
                        child: Text(
                          _pinSet ? 'Confirm Meetup Point' : 'Tap map to pin a location',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Alert modal overlay
          if (_alertVisible)
            Positioned.fill(
              child: GestureDetector(
                onTap: () => setState(() => _alertVisible = false),
                child: Container(color: Colors.black.withOpacity(0.4)),
              ),
            ),
          if (_alertVisible)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                top: false,
                child: UrgentDepartureModal(onDismiss: () => setState(() => _alertVisible = false)),
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.92),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6)],
        ),
        child: Text(label, style: const TextStyle(color: AppColors.charcoal, fontSize: 12, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
