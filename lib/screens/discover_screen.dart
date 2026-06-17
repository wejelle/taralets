import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/poi.dart';
import '../widgets/star_rating.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Budget', 'Cafes', 'Activities'];
  final Set<String> _itinerary = {};

  List<POI> get _filtered {
    if (_selectedCategory == 'All') return POI.mockPOIs;
    return POI.mockPOIs.where((p) => p.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Discover Places', style: TextStyle(color: AppColors.charcoal, fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
                  SizedBox(height: 2),
                  Text('Near Eastwood City Mall, QC', style: TextStyle(color: AppColors.bodyText, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Category chips
            SizedBox(
              height: 40,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (ctx, i) {
                  final cat = _categories[i];
                  final active = cat == _selectedCategory;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        color: active ? AppColors.primary : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: active ? AppColors.primary : AppColors.divider),
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                          color: active ? Colors.white : AppColors.bodyText,
                          fontSize: 13,
                          fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 4),

            // POI list
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                itemCount: _filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (ctx, i) => _POICard(
                  poi: _filtered[i],
                  inItinerary: _itinerary.contains(_filtered[i].id),
                  onAddToggle: () => setState(() {
                    final id = _filtered[i].id;
                    if (_itinerary.contains(id)) {
                      _itinerary.remove(id);
                    } else {
                      _itinerary.add(id);
                    }
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _POICard extends StatelessWidget {
  final POI poi;
  final bool inItinerary;
  final VoidCallback onAddToggle;

  const _POICard({required this.poi, required this.inItinerary, required this.onAddToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: AppColors.charcoal.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(poi.category, style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w700)),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: poi.isOpen ? AppColors.tealLight : AppColors.dangerLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    poi.isOpen ? 'Open Now' : 'Closed',
                    style: TextStyle(
                      color: poi.isOpen ? AppColors.teal : AppColors.danger,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(poi.name, style: const TextStyle(color: AppColors.charcoal, fontSize: 16, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text(poi.description, style: const TextStyle(color: AppColors.bodyText, fontSize: 13, height: 1.5)),
            const SizedBox(height: 12),
            Row(
              children: [
                StarDisplay(rating: poi.rating),
                const SizedBox(width: 6),
                Text(
                  poi.rating.toStringAsFixed(1),
                  style: const TextStyle(color: AppColors.charcoal, fontSize: 13, fontWeight: FontWeight.w700),
                ),
                const SizedBox(width: 4),
                Text('(${poi.reviewCount})', style: const TextStyle(color: AppColors.captionText, fontSize: 12)),
                const Spacer(),
                const Icon(Icons.near_me_outlined, size: 13, color: AppColors.captionText),
                const SizedBox(width: 3),
                Text(poi.distanceLabel, style: const TextStyle(color: AppColors.captionText, fontSize: 12)),
                const SizedBox(width: 8),
                Text(poi.priceRange, style: const TextStyle(color: AppColors.bodyText, fontSize: 13, fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: GestureDetector(
                onTap: onAddToggle,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  decoration: BoxDecoration(
                    color: inItinerary ? AppColors.teal : AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        inItinerary ? Icons.check_circle_rounded : Icons.add_circle_outline_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        inItinerary ? 'Added to Itinerary' : 'Add to Itinerary',
                        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
