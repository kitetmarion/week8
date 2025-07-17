class MoodEntry {
  final String id;
  final DateTime date;
  final int moodLevel; // 1-5 scale
  final String moodType;
  final String notes;
  final List<String> activities;
  final List<String> emotions;

  MoodEntry({
    required this.id,
    required this.date,
    required this.moodLevel,
    required this.moodType,
    this.notes = '',
    this.activities = const [],
    this.emotions = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'moodLevel': moodLevel,
      'moodType': moodType,
      'notes': notes,
      'activities': activities,
      'emotions': emotions,
    };
  }

  factory MoodEntry.fromJson(Map<String, dynamic> json) {
    return MoodEntry(
      id: json['id'],
      date: DateTime.parse(json['date']),
      moodLevel: json['moodLevel'],
      moodType: json['moodType'],
      notes: json['notes'] ?? '',
      activities: List<String>.from(json['activities'] ?? []),
      emotions: List<String>.from(json['emotions'] ?? []),
    );
  }
}
