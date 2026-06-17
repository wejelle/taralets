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

  // BAGO: Ginawang mutable variable imbes na static function para pwede madagdagan
  static List<TimelineActivity> mockActivitiesList = [
    TimelineActivity(
        id: 'a1',
        title: 'Meet-up at Eastwood',
        location: 'Eastwood Mall',
        timeLabel: '3:00 PM',
        description: 'Converge at atrium.',
        status: ActivityStatus.upcoming,
        canRate: true),
    TimelineActivity(
        id: 'a2',
        title: 'Timezone Gaming',
        location: '3F Eastwood',
        timeLabel: '3:30 PM',
        description: 'Arcade session.',
        status: ActivityStatus.upcoming,
        canRate: true),
    TimelineActivity(
        id: 'a3',
        title: 'Dinner Together',
        location: 'Kettle by Todd',
        timeLabel: '7:00 PM',
        description: 'Reserved table.',
        status: ActivityStatus.upcoming,
        canRate: true),
  ];
}
