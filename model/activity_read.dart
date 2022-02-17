class ActivityRead {
  final String timestamp;
  final String duration;

  ActivityRead({required this.timestamp, required this.duration});

  factory ActivityRead.fromRTDB(Map<dynamic, dynamic> data) {
    return ActivityRead(
        timestamp: data['timestamp'], duration: data['duration']);
  }

  String showData() {
    return 'Date $timestamp, duration $duration';
  }
}
