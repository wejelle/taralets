enum ActivityStatus { upcoming, inProgress, completed }

class TimelineActivity {
  final String id;
  final String title;
  final String location;
  final String timeLabel;
  final String description;
  final ActivityStatus status;
  final bool canRate;
  int userRating; // 0-5, mutable for demo

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

  static List<TimelineActivity> mockActivities() => [
        TimelineActivity(
          id: 'a1',
          title: 'Meet-up at Eastwood Mall',
          location: 'Eastwood City Mall, QC',
          timeLabel: '3:00 PM',
          description: 'Everyone converges at the main atrium entrance near the fountain.',
          status: ActivityStatus.completed,
          canRate: false,
          userRating: 5,
        ),
        TimelineActivity(
          id: 'a2',
          title: 'Timezone Gaming Session',
          location: 'Timezone, 3F Eastwood Mall',
          timeLabel: '3:30 PM',
          description: '90-minute arcade session. Everyone gets ₱200 tokens to start.',
          status: ActivityStatus.completed,
          canRate: true,
          userRating: 4,
        ),
        TimelineActivity(
          id: 'a3',
          title: 'Merienda Break — Serenitea',
          location: 'Serenitea, GF Eastwood Citywalk',
          timeLabel: '5:00 PM',
          description: 'Milk tea and snacks break. Group order coordination via the app.',
          status: ActivityStatus.completed,
          canRate: true,
          userRating: 0,
        ),
        TimelineActivity(
          id: 'a4',
          title: 'Dinner Together',
          location: 'Kettle by Todd English, Eastwood',
          timeLabel: '7:00 PM',
          description: 'Reserved table for the full squad. Set menu available. ₱450/head.',
          status: ActivityStatus.inProgress,
          canRate: false,
        ),
        TimelineActivity(
          id: 'a5',
          title: 'Night Cap — Citywalk Stroll',
          location: 'Eastwood Citywalk Strip',
          timeLabel: '9:00 PM',
          description: 'Chill walk along the strip. Live band plays Fridays. Optional dessert stop.',
          status: ActivityStatus.upcoming,
          canRate: false,
        ),
        TimelineActivity(
          id: 'a6',
          title: 'Group Dispersal',
          location: 'Eastwood Mall Main Entrance',
          timeLabel: '10:30 PM',
          description: 'Trip officially ends. Safe travels, everyone!',
          status: ActivityStatus.upcoming,
          canRate: false,
        ),
      ];
}
