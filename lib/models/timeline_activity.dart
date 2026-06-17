enum ActivityStatus { upcoming, inProgress, completed }

class TimelineActivity {
  final String id;
  final String title;
  final String location;
  final String timeLabel;
  final String description;
  ActivityStatus status; // Tanggalin ang final
  final bool canRate;
  int userRating;

  TimelineActivity({
    required this.id,
    required this.title,
    required this.location,
    required this.timeLabel,
    required this.description,
    required this.status,
    this.canRate = false,
    this.userRating = 0,
  });

// BAGO: Made a mutable variable instead of a static function for dynamic updates
  static List<TimelineActivity> mockActivitiesList = [
    TimelineActivity(
        id: 'a1',
        title: 'Initial Assembly',
        location: 'Cyberzone Tech Lounge (The Annex)',
        timeLabel: '3:00 PM',
        description:
            'Designated lounge meetup spot for everyone while checking out tech setups.',
        status: ActivityStatus.upcoming,
        canRate: true),
    TimelineActivity(
        id: 'a2',
        title: 'Escape Room Challenge',
        location: 'Left Behind Escape Rooms (4F)',
        timeLabel: '4:00 PM',
        description:
            'Cooperative puzzle solving! Group slot booked to test the crew\'s logic synergy.',
        status: ActivityStatus.upcoming,
        canRate: true),
    TimelineActivity(
        id: 'a3',
        title: 'Heavy Dinner Drop',
        location: 'Ramen Nagi (The Block)',
        timeLabel: '6:30 PM',
        description:
            'Filling premium ramen bowls to celebrate or wind down after the activities.',
        status: ActivityStatus.upcoming,
        canRate: true),
  ];
}
