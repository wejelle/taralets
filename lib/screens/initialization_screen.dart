import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../widgets/map_container.dart';
import '../widgets/alert_modal.dart';
import '../screens/dashboard_screen.dart';
import '../main.dart';

class InitializationScreen extends StatefulWidget {
  const InitializationScreen({super.key});

  @override
  State<InitializationScreen> createState() => _InitializationScreenState();
}

class _InitializationScreenState extends State<InitializationScreen> {
  bool _alertVisible = false;
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
      backgroundColor: AppColors.charcoal,
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            Positioned.fill(
              child: MapContainer(
                  height: double.infinity,
                  showPin: _pinSet,
                  showCrosshairs: !_pinSet,
                  pinLabel: _pinnedLabel),
            ),

            // ── 2. Top bar ──
            Align(
              alignment: Alignment.topCenter,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Row(
                    children: [
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
                      GestureDetector(
                        onTap: () =>
                            setState(() => _alertVisible = !_alertVisible),
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
            ),

            // ── 3. Bottom panel ──
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // MODULE 3.0: Trip Name Input
                        GlassContainer(
                          borderRadius: 14,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 2),
                          child: TextField(
                            controller: _groupNameController,
                            style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                                fontWeight: FontWeight.w700),
                            decoration: const InputDecoration(
                              hintText: 'Enter Trip Name',
                              hintStyle: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                              border: InputBorder.none,
                              icon: Icon(Icons.flight_takeoff_rounded,
                                  color: Colors.black54, size: 20),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // MODULE 3.0: Target Arrival Time Picker
                        GestureDetector(
                          onTap: () => _selectTime(context),
                          child: GlassContainer(
                            borderRadius: 14,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            child: Row(
                              children: [
                                const Icon(Icons.access_time_rounded,
                                    color: Colors.black54, size: 20),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    _targetArrivalTime == null
                                        ? 'Set Target Arrival Time'
                                        : 'Arrival Time: ${_targetArrivalTime!.format(context)}',
                                    style: TextStyle(
                                      color: _targetArrivalTime == null
                                          ? Colors.black54
                                          : Colors.black87,
                                      fontSize: 14,
                                      fontWeight: _targetArrivalTime == null
                                          ? FontWeight.w600
                                          : FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // MODULE 3.0: Destination Pinning
                        GlassContainer(
                          borderRadius: 14,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              const Icon(Icons.location_on_rounded,
                                  color: Colors.black54, size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  _pinSet
                                      ? _pinnedLabel
                                      : 'Search or tap map to pin…',
                                  style: TextStyle(
                                      color: _pinSet
                                          ? Colors.black87
                                          : Colors.black54,
                                      fontSize: 14,
                                      fontWeight: _pinSet
                                          ? FontWeight.w700
                                          : FontWeight.w600),
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
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Confirm button
                        SizedBox(
                          width: double.infinity,
                          child: GestureDetector(
                            onTap: (_pinSet && _targetArrivalTime != null)
                                ? () {
                                    _showConfirmSnack(context);
                                    setState(() => _groupSessionVisible = true);
                                  }
                                : null,
                            child: GlassContainer(
                              borderRadius: 14,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              color: (_pinSet && _targetArrivalTime != null)
                                  ? AppColors.primary.withOpacity(0.85)
                                  : Colors.white.withOpacity(0.25),
                              child: Center(
                                child: Text(
                                  (_pinSet && _targetArrivalTime != null)
                                      ? 'Confirm Trip Details'
                                      : 'Complete Trip Info',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: (_pinSet &&
                                              _targetArrivalTime != null)
                                          ? Colors.white
                                          : Colors.black54),
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
            ),

            // ── 4. Alert modal overlay ──
            if (_alertVisible)
              Positioned.fill(
                child: GestureDetector(
                  onTap: () => setState(() => _alertVisible = false),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
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

            // ── 5. GROUP COORDINATION OVERLAY ──
            if (_groupSessionVisible)
              Positioned.fill(
                child: GestureDetector(
                  onTap: () => setState(() => _groupSessionVisible = false),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: Container(color: Colors.black.withOpacity(0.4)),
                  ),
                ),
              ),
            if (_groupSessionVisible)
              Positioned.fill(
                child: Center(
                  child: _buildGroupCoordinationPrototype(),
                ),
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
          borderRadius: 16,
          padding: const EdgeInsets.all(20),
          color: AppColors.background.withOpacity(0.95), // Clean off-white
          borderColor: AppColors.cardBorder,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.group_rounded, color: AppColors.primary),
                  SizedBox(width: 8),
                  Text(
                    'Group Coordination',
                    style: TextStyle(
                      color: AppColors.charcoal, // Dark blue-gray
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Group Name: ${_groupNameController.text.isNotEmpty ? _groupNameController.text : 'Your Group'}',
                style: const TextStyle(
                    color: AppColors.charcoal,
                    fontSize: 14,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.location_on_rounded,
                      color: AppColors.primary, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    _pinnedLabel,
                    style: const TextStyle(
                        color: AppColors.bodyText,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const Divider(height: 24, color: AppColors.divider),
              const Text(
                'Share Room Code',
                style: TextStyle(
                    color: AppColors.captionText,
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Room code copied to clipboard! 📋'),
                      backgroundColor: AppColors.teal,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                      color: AppColors.primaryLight, // Highlight color
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: AppColors.primary.withOpacity(0.2), width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        )
                      ]),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'PHX-92A',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 22,
                          letterSpacing: 4,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Icon(Icons.copy_rounded,
                          color: AppColors.primary, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Live Member List',
                style: TextStyle(
                    color: AppColors.captionText,
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
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
                child: Divider(height: 1, color: AppColors.divider),
              ),
              _buildMemberRow(
                  name: 'Denanajewaig',
                  status: 'On the way',
                  icon: Icons.directions_car_rounded,
                  iconColor: AppColors.bodyText,
                  statusColor: AppColors.urgent,
                  eta: 'ETA: 22 mins'),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Divider(height: 1, color: AppColors.divider),
              ),
              _buildMemberRow(
                  name: 'Waiting for others...',
                  status: 'Pending',
                  icon: Icons.more_horiz_rounded,
                  iconColor: AppColors.captionText,
                  statusColor: AppColors.captionText,
                  eta: '--'),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: () {
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
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'Start Group Sync',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: GestureDetector(
                  onTap: () => setState(() => _groupSessionVisible = false),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: AppColors.bodyText,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMemberRow({
    required String name,
    required String status,
    required IconData icon,
    required Color iconColor,
    required Color statusColor,
    required String eta,
  }) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: AppColors.cardBorder,
          child: Icon(icon, size: 18, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: AppColors.charcoal,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                eta,
                style: const TextStyle(
                  color: AppColors.captionText,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: statusColor.withOpacity(0.3)),
          ),
          child: Text(
            status,
            style: TextStyle(
              color: statusColor == AppColors.captionText
                  ? AppColors.bodyText
                  : statusColor,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
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
        color: Colors.white.withOpacity(0.35),
        child: Text(label,
            style: const TextStyle(
                color: Colors.black87,
                fontSize: 12,
                fontWeight: FontWeight.w700)),
      ),
    );
  }
}

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
            color: color ?? Colors.white.withOpacity(0.25),
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
