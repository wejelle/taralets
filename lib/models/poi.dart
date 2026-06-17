class POI {
  final String id;
  final String name;
  final String category;
  final String description;
  final String distanceLabel;
  final double rating;
  final int reviewCount;
  final String priceRange;
  final bool isOpen;
  final List<String> preferences;

  const POI({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.distanceLabel,
    required this.rating,
    required this.reviewCount,
    required this.priceRange,
    required this.isOpen,
    required this.preferences,
  });

  static const List<POI> mockPOIs = [
    POI(
      id: 'p1',
      name: 'SM North Sky Garden',
      category: 'Activities',
      description:
          'A long elevated walkway with lush greenery, water features, and open-air food stalls. Perfect for a refreshing stroll or barkada meetups.',
      distanceLabel: '0.1 km away',
      rating: 4.5,
      reviewCount: 3412,
      priceRange: '₱',
      isOpen: true,
      preferences: ['Outdoor', 'Chill', 'Scenic'],
    ),
    POI(
      id: 'p2',
      name: 'Yardstick Coffee - The Block',
      category: 'Cafes',
      description:
          'Specialty coffee hub featuring smooth espresso blends, aesthetic minimalist vibes, and great pastries. Ideal for catch-ups.',
      distanceLabel: '0.2 km away',
      rating: 4.6,
      reviewCount: 312,
      priceRange: '₱₱',
      isOpen: true,
      preferences: ['Drinks', 'Indoor', 'Chill'],
    ),
    POI(
      id: 'p3',
      name: 'Bake House - Main Mall',
      category: 'Budget',
      description:
          'Freshly baked artisanal breads, sweet pastries, and affordable light snacks. Great for a quick group bite.',
      distanceLabel: '0.3 km away',
      rating: 4.3,
      reviewCount: 245,
      priceRange: '₱',
      isOpen: true,
      preferences: ['Food', 'Budget', 'Quick'],
    ),
    POI(
      id: 'p4',
      name: 'Timezone - The Annex',
      category: 'Activities',
      description:
          'Massive arcade area featuring dynamic racing simulators, basketball hoops, karaoke booths, and bowling lanes. Full-on barkada fun.',
      distanceLabel: '0.4 km away',
      rating: 4.4,
      reviewCount: 945,
      priceRange: '₱₱',
      isOpen: true,
      preferences: ['Games', 'Indoor', 'Loud'],
    ),
    POI(
      id: 'p5',
      name: 'Seattle\'s Best Coffee - Sky Garden',
      category: 'Cafes',
      description:
          'Cozy coffee shop overlooking the park area. Great place to wait out the EDSA rush hour with a warm brew.',
      distanceLabel: '0.1 km away',
      rating: 4.2,
      reviewCount: 521,
      priceRange: '₱₱',
      isOpen: false,
      preferences: ['Drinks', 'Chill', 'Outdoor'],
    ),
    POI(
      id: 'p6',
      name: 'Bowlink - City Center',
      category: 'Activities',
      description:
          'Modern bowling alley and recreation spot right inside the mall. Complete with neon lights and snack booths for the ultimate group face-off.',
      distanceLabel: '0.5 km away',
      rating: 4.3,
      reviewCount: 418,
      priceRange: '₱₱',
      isOpen: true,
      preferences: ['Games', 'Sports', 'Indoor'],
    ),
  ];
}
