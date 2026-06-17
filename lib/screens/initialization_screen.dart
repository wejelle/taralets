import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../widgets/map_container.dart';
import '../main.dart'; // Import para sa MainShell routing

class InitializationScreen extends StatefulWidget {
  const InitializationScreen({super.key});

  @override
  State<InitializationScreen> createState() => _InitializationScreenState();
}

class _InitializationScreenState extends State<InitializationScreen> {
  String _pinnedLabel = 'Custom Pin';
  bool _pinSet = false;

  bool _groupSessionVisible = false;

  final TextEditingController _groupNameController = TextEditingController();
  TimeOfDay? _targetArrivalTime;

  @override
  void dispose() {
    _groupNameController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _targetArrivalTime) {
      setState(() => _targetArrivalTime = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA), // Clean background
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            Column(
              children: [
                // ── 1. MAP SECTION (Nasa itaas, kumukuha ng natitirang space) ──
                Expanded(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: MapContainer(
                            height: double.infinity,
                            showPin: _pinSet,
                            showCrosshairs: !_pinSet,
                            pinLabel: _pinnedLabel),
                      ),

                      // Top bar indicator
                      Align(
                        alignment: Alignment.topLeft,
                        child: SafeArea(
                          bottom: false,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 8,
                                      offset: Offset(0, 2))
                                ],
                              ),
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
                                          color: AppColors.charcoal,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── 2. FORM SECTION (Solid Panel sa ibaba) ──
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, -4))
                    ],
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Padding(
                    // Dinagdag ang viewInsets para umangat pag lumabas ang keyboard
                    padding: EdgeInsets.fromLTRB(16, 24, 16,
                        MediaQuery.of(context).viewInsets.bottom + 24),
                    child: SafeArea(
                      top: false,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Trip Name Input (Solid Field)
                          Container(
                            decoration: BoxDecoration(
                                color: const Color(0xFFF3F4F6),
                                borderRadius: BorderRadius.circular(16)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 2),
                            child: TextField(
                              controller: _groupNameController,
                              style: const TextStyle(
                                  color: AppColors.charcoal,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800),
                              decoration: const InputDecoration(
                                hintText: 'Enter Trip Name',
                                hintStyle: TextStyle(
                                    color: AppColors.captionText,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700),
                                border: InputBorder.none,
                                icon: Icon(Icons.flight_takeoff_rounded,
                                    color: AppColors.primary, size: 22),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Target Arrival Time Picker (Solid Field)
                          GestureDetector(
                            onTap: () => _selectTime(context),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: const Color(0xFFF3F4F6),
                                  borderRadius: BorderRadius.circular(16)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              child: Row(
                                children: [
                                  const Icon(Icons.access_time_rounded,
                                      color: AppColors.primary, size: 22),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      _targetArrivalTime == null
                                          ? 'Set Target Arrival Time'
                                          : 'Arrival Time: ${_targetArrivalTime!.format(context)}',
                                      style: TextStyle(
                                        color: _targetArrivalTime == null
                                            ? AppColors.captionText
                                            : AppColors.charcoal,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Destination Pinning (Solid Field)
                          Container(
                            decoration: BoxDecoration(
                                color: const Color(0xFFF3F4F6),
                                borderRadius: BorderRadius.circular(16)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            child: Row(
                              children: [
                                const Icon(Icons.location_on_rounded,
                                    color: AppColors.primary, size: 22),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    _pinSet
                                        ? _pinnedLabel
                                        : 'Search or tap map to pin…',
                                    style: TextStyle(
                                        color: _pinSet
                                            ? AppColors.charcoal
                                            : AppColors.captionText,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ),
                                if (_pinSet)
                                  GestureDetector(
                                    onTap: () => setState(() {
                                      _pinSet = false;
                                      _pinnedLabel = 'Custom Pin';
                                    }),
                                    child: const Icon(Icons.close_rounded,
                                        color: AppColors.captionText, size: 20),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),

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
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Confirm button
                          SizedBox(
                            width: double.infinity,
                            child: GestureDetector(
                              onTap: (_pinSet && _targetArrivalTime != null)
                                  ? () {
                                      _showConfirmSnack(context);
                                      setState(
                                          () => _groupSessionVisible = true);
                                    }
                                  : null,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 18),
                                decoration: BoxDecoration(
                                    color:
                                        (_pinSet && _targetArrivalTime != null)
                                            ? AppColors.primary
                                            : const Color(0xFFE5E7EB),
                                    borderRadius: BorderRadius.circular(16)),
                                child: Center(
                                  child: Text(
                                    (_pinSet && _targetArrivalTime != null)
                                        ? 'Confirm Trip Details'
                                        : 'Complete Trip Info',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                        color: (_pinSet &&
                                                _targetArrivalTime != null)
                                            ? Colors.white
                                            : AppColors.captionText),
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
              ],
            ),

            // ── 3. GROUP COORDINATION OVERLAY ──
            if (_groupSessionVisible)
              Positioned.fill(
                child: GestureDetector(
                  onTap: () => setState(() => _groupSessionVisible = false),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                    child: Container(color: Colors.black.withOpacity(0.5)),
                  ),
                ),
              ),
            if (_groupSessionVisible)
              Positioned.fill(
                child: Center(child: _buildGroupCoordinationPrototype()),
              ),
          ],
        ),
      ),
    );
  }

  void _showConfirmSnack(BuildContext context) {
    final groupName = _groupNameController.text.isNotEmpty
        ? _groupNameController.text
        : 'Your Group';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$groupName meetup point set: $_pinnedLabel 📍'),
        backgroundColor: AppColors.teal,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildGroupCoordinationPrototype() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Material(
        color: Colors.transparent,
        child: GlassContainer(
          borderRadius: 20,
          padding: const EdgeInsets.all(24),
          color: Colors.white.withOpacity(0.9), // Clean glass popup
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.group_rounded, color: AppColors.primary, size: 28),
                  SizedBox(width: 10),
                  Text('Group Coordination',
                      style: TextStyle(
                          color: AppColors.charcoal,
                          fontSize: 18,
                          fontWeight: FontWeight.w900)),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Group Name: ${_groupNameController.text.isNotEmpty ? _groupNameController.text : 'Your Group'}',
                style: const TextStyle(
                    color: AppColors.charcoal,
                    fontSize: 14,
                    fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.location_on_rounded,
                      color: AppColors.primary, size: 16),
                  const SizedBox(width: 6),
                  Text(_pinnedLabel,
                      style: const TextStyle(
                          color: AppColors.bodyText,
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                ],
              ),
              const Divider(height: 32, color: AppColors.divider),
              const Text('Share Room Code',
                  style: TextStyle(
                      color: AppColors.captionText,
                      fontSize: 12,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            const Text('Room code copied to clipboard! 📋'),
                        backgroundColor: AppColors.teal,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppColors.primary.withOpacity(0.3), width: 1.5),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('PHX-92A',
                          style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 24,
                              letterSpacing: 6,
                              fontWeight: FontWeight.w900)),
                      Icon(Icons.copy_rounded,
                          color: AppColors.primary, size: 22),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text('Live Member List',
                  style: TextStyle(
                      color: AppColors.captionText,
                      fontSize: 12,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              _buildMemberRow(
                  name: 'You (Host)',
                  status: 'Ready',
                  icon: Icons.star_rounded,
                  iconColor: AppColors.starGold,
                  statusColor: AppColors.teal,
                  eta: 'ETA: 15 mins'),
              const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Divider(height: 1, color: AppColors.divider)),
              _buildMemberRow(
                  name: 'Denanajewaig',
                  status: 'On the way',
                  icon: Icons.directions_car_rounded,
                  iconColor: AppColors.bodyText,
                  statusColor: AppColors.urgent,
                  eta: 'ETA: 22 mins'),
              const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Divider(height: 1, color: AppColors.divider)),
              _buildMemberRow(
                  name: 'Waiting for others...',
                  status: 'Pending',
                  icon: Icons.more_horiz_rounded,
                  iconColor: AppColors.captionText,
                  statusColor: AppColors.captionText,
                  eta: '--'),
              const SizedBox(height: 32),

              // Confirm Start Button
              SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: () {
                    // Start navigation logic
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainShell(
                          tripName: _groupNameController.text.isNotEmpty
                              ? _groupNameController.text
                              : 'Taralets Trip',
                          location: _pinnedLabel,
                          targetTime: _targetArrivalTime,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.primary.withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4))
                      ],
                    ),
                    child: const Center(
                      child: Text('Start Group Sync',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w900)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Center(
                child: GestureDetector(
                  onTap: () => setState(() => _groupSessionVisible = false),
                  child: const Text('Cancel',
                      style: TextStyle(
                          color: AppColors.captionText,
                          fontSize: 14,
                          fontWeight: FontWeight.w700)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMemberRow(
      {required String name,
      required String status,
      required IconData icon,
      required Color iconColor,
      required Color statusColor,
      required String eta}) {
    return Row(
      children: [
        CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.cardBorder,
            child: Icon(icon, size: 18, color: iconColor)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: const TextStyle(
                      color: AppColors.charcoal,
                      fontSize: 14,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 2),
              Text(eta,
                  style: const TextStyle(
                      color: AppColors.captionText,
                      fontSize: 11,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
              color: statusColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: statusColor.withOpacity(0.3))),
          child: Text(status,
              style: TextStyle(
                  color: statusColor == AppColors.captionText
                      ? AppColors.bodyText
                      : statusColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w800)),
        ),
      ],
    );
  }
}

// Binago sa Solid Container imbes na GlassContainer
class _QuickPin extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _QuickPin({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5)),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Text(label,
            style: const TextStyle(
                color: AppColors.charcoal,
                fontSize: 12,
                fontWeight: FontWeight.w800)),
      ),
    );
  }
}

// 💡 Iniwan ko lang itong GlassContainer class dito sa baba dahil
// ginagamit pa rin ito ng _buildGroupCoordinationPrototype() para sa popup overlay!
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
            color: color ?? Colors.white.withOpacity(0.6),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: borderColor ?? Colors.white.withOpacity(0.8),
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
