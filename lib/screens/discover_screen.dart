import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/poi.dart';
import '../widgets/star_rating.dart';
import '../models/timeline_activity.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final Set<String> _selectedPreferences = {};
  final List<String> _availablePreferences = [
    'Budget',
    'Food',
    'Drinks',
    'Chill',
    'Games',
    'Outdoor',
    'Indoor',
    'Nightlife'
  ];
  final Set<String> _itinerary = {};

  List<POI> get _filtered {
    if (_selectedPreferences.isEmpty) return POI.mockPOIs;
    return POI.mockPOIs.where((p) {
      return _selectedPreferences.any((pref) => p.preferences.contains(pref));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Sumusunod sa MainShell
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Discover & Filter',
                    style: TextStyle(
                      color: AppColors.charcoal,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Customize your group\'s vibe',
                    style: TextStyle(color: AppColors.bodyText, fontSize: 13),
                  ),
                ],
              ),
            ),
            
            // ── BAGO: Search Bar ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.6), width: 1.5),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search for cafes, activities, etc.',
                    hintStyle: TextStyle(color: AppColors.captionText, fontSize: 14),
                    prefixIcon: Icon(Icons.search_rounded, color: AppColors.primary),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
            // ──────────────────────────────────────────────────────────────

            SizedBox(
              height: 40,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: _availablePreferences.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (ctx, i) {
                  final pref = _availablePreferences[i];
                  final active = _selectedPreferences.contains(pref);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (active) {
                          _selectedPreferences.remove(pref);
                        } else {
                          _selectedPreferences.add(pref);
                        }
                      });
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 10),
                          decoration: BoxDecoration(
                            color: active
                                ? AppColors.primary.withOpacity(0.85)
                                : Colors.white.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: active
                                  ? AppColors.primary
                                  : Colors.white.withOpacity(0.5),
                            ),
                          ),
                          child: Text(
                            pref,
                            style: TextStyle(
                              color: active ? Colors.white : AppColors.charcoal,
                              fontSize: 13,
                              fontWeight:
                                  active ? FontWeight.w800 : FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                    20, 12, 20, 100), // Bottom padding para sa nav bar
                itemCount: _filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (ctx, i) => _POICard(
                  poi: _filtered[i],
                  inItinerary: _itinerary.contains(_filtered[i].id),
                  isOptimized: i == 0, // BAGO: Prototype logic, first item is always group-optimized
                  onAddToggle: () {
                    setState(() {
                      final id = _filtered[i].id;
                      if (!_itinerary.contains(id)) {
                        _itinerary.add(id);
                        TimelineActivity.mockActivitiesList.add(TimelineActivity(
                          id: id,
                          title: _filtered[i].name,
                          location: _filtered[i].category,
                          timeLabel: 'TBD',
                          description: _filtered[i].description,
                          status: ActivityStatus.upcoming,
                          canRate: true,
                        ));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Added to Timeline!'),
                              backgroundColor: Colors.green),
                        );
                      }
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _POICard extends StatefulWidget {
  final POI poi;
  final bool inItinerary;
  final bool isOptimized; // BAGO: Para sa Meet-in-the-middle badge
  final VoidCallback onAddToggle;

  const _POICard({
    required this.poi,
    required this.inItinerary,
    this.isOptimized = false,
    required this.onAddToggle,
  });

  @override
  State<_POICard> createState() => _POICardState();
}

class _POICardState extends State<_POICard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: GlassContainer(
          borderRadius: 18,
          padding: const EdgeInsets.all(16),
          color: Colors.white.withOpacity(_isHovered ? 0.6 : 0.4),
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
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(widget.poi.category,
                                  style: const TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800)),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: widget.poi.isOpen
                                    ? AppColors.teal.withOpacity(0.15)
                                    : AppColors.danger.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                widget.poi.isOpen ? 'Open Now' : 'Closed',
                                style: TextStyle(
                                  color: widget.poi.isOpen
                                      ? AppColors.teal
                                      : AppColors.danger,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            // ── BAGO: Group Optimized Badge ────────────────
                            if (widget.isOptimized)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.deepPurpleAccent.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.hub_rounded, size: 12, color: Colors.deepPurpleAccent),
                                    SizedBox(width: 4),
                                    Text(
                                      'Group Optimized',
                                      style: TextStyle(
                                        color: Colors.deepPurpleAccent,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            // ───────────────────────────────────────────────
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(widget.poi.name,
                            style: const TextStyle(
                                color: AppColors.charcoal,
                                fontSize: 16,
                                fontWeight: FontWeight.w900)),
                        const SizedBox(height: 6),
                        Text(widget.poi.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: AppColors.bodyText,
                                fontSize: 12,
                                height: 1.4)),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            StarDisplay(rating: widget.poi.rating, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              widget.poi.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                  color: AppColors.charcoal,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(width: 4),
                            Text('(${widget.poi.reviewCount})',
                                style: const TextStyle(
                                    color: AppColors.captionText,
                                    fontSize: 11)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(Icons.image_rounded,
                          color: Colors.black26, size: 30),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.near_me_outlined,
                          size: 14, color: AppColors.captionText),
                      const SizedBox(width: 4),
                      Text(widget.poi.distanceLabel,
                          style: const TextStyle(
                              color: AppColors.bodyText,
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                  Text(widget.poi.priceRange,
                      style: const TextStyle(
                          color: AppColors.charcoal,
                          fontSize: 13,
                          fontWeight: FontWeight.w800)),
                ],
              ),
              const SizedBox(height: 14),
              
              // ── BAGO: Propose & Add to Itinerary Row ─────────────────────
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: widget.onAddToggle,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        decoration: BoxDecoration(
                          color: widget.inItinerary
                              ? AppColors.teal.withOpacity(0.9)
                              : AppColors.primary.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              widget.inItinerary
                                  ? Icons.check_circle_rounded
                                  : Icons.add_circle_outline_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                            const SizedBox(width: 7),
                            Text(
                              widget.inItinerary
                                  ? 'Added to Itinerary'
                                  : 'Add to Itinerary',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Proposed to group! Pending votes.'),
                          backgroundColor: Colors.blueAccent,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6),
                        border: Border.all(color: AppColors.primary.withOpacity(0.4), width: 1.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.how_to_vote_rounded, color: AppColors.primary, size: 20),
                    ),
                  ),
                ],
              ),
              // ─────────────────────────────────────────────────────────────
            ],
          ),
        ),
      ),
    );
  }
}

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final Color? color;

  const GlassContainer({
    super.key,
    required this.child,
    this.borderRadius = 14.0,
    this.padding,
    this.color,
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
            color: color ?? Colors.white.withOpacity(0.4),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: Colors.white.withOpacity(0.6),
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}