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

  // SIGURADUHIN NA NASA LOOB ITO NG CONSTRUCTOR
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
    required this.preferences, // <- Ito yung hinahanap ng error
  });

  static const List<POI> mockPOIs = [
    POI(
      id: 'p1',
      name: 'Eastwood Citywalk',
      category: 'Activities',
      description: 'Open-air lifestyle strip with live performances, street food, and al fresco dining. Perfect for group hangs.',
      distanceLabel: '0.1 km away',
      rating: 4.5,
      reviewCount: 1284,
      priceRange: '₱₱',
      isOpen: true,
      preferences: ['Outdoor', 'Nightlife', 'Chill'],
    ),
    POI(
      id: 'p2',
      name: 'Serenitea QC',
      category: 'Cafes',
      description: 'Popular milk tea chain with cozy seating and customizable drinks. Group orders welcome.',
      distanceLabel: '0.3 km away',
      rating: 4.3,
      reviewCount: 876,
      priceRange: '₱',
      isOpen: true,
      preferences: ['Drinks', 'Budget', 'Chill'],
    ),
    POI(
      id: 'p3',
      name: 'Jollibee Eastwood',
      category: 'Budget',
      description: 'Iconic Filipino fast food. Affordable, quick, and always a crowd pleaser for barkadas on a budget.',
      distanceLabel: '0.4 km away',
      rating: 4.1,
      reviewCount: 2103,
      priceRange: '₱',
      isOpen: true,
      preferences: ['Food', 'Budget', 'Quick'],
    ),
    POI(
      id: 'p4',
      name: 'Timezone Eastwood',
      category: 'Activities',
      description: 'Large arcade with the latest games, VR stations, and redemption counters. Great for groups.',
      distanceLabel: '0.2 km away',
      rating: 4.4,
      reviewCount: 645,
      priceRange: '₱₱',
      isOpen: true,
      preferences: ['Games', 'Indoor', 'Loud'],
    ),
    POI(
      id: 'p5',
      name: 'Bo\'s Coffee',
      category: 'Cafes',
      description: 'Homegrown Philippine specialty coffee. Single-origin brews, pastries, and a calm atmosphere.',
      distanceLabel: '0.5 km away',
      rating: 4.2,
      reviewCount: 432,
      priceRange: '₱₱',
      isOpen: false,
      preferences: ['Drinks', 'Chill', 'Indoor'],
    ),
    POI(
      id: 'p6',
      name: 'Mineski Infinity',
      category: 'Activities',
      description: 'Premier esports café with high-end gaming rigs, private rooms, and snack bar. Ideal for gamer crews.',
      distanceLabel: '0.7 km away',
      rating: 4.6,
      reviewCount: 918,
      priceRange: '₱₱',
      isOpen: true,
      preferences: ['Games', 'Indoor', 'Esports'],
    ),
  ];
}