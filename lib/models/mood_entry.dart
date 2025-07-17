class MoodEntry {
  final String id;
  final DateTime date;
  final int moodLevel; // 1-5 scale
  final String moodEmoji;
  final String moodDescription;
  final String notes;
  final List<String> tags;

  MoodEntry({
    required this.id,
    required this.date,
    required this.moodLevel,
    required this.moodEmoji,
    required this.moodDescription,
    this.notes = '',
    this.tags = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'moodLevel': moodLevel,
      'moodEmoji': moodEmoji,
      'moodDescription': moodDescription,
      'notes': notes,
      'tags': tags,
    };
  }

  factory MoodEntry.fromJson(Map<String, dynamic> json) {
    return MoodEntry(
      id: json['id'],
      date: DateTime.parse(json['date']),
      moodLevel: json['moodLevel'],
      moodEmoji: json['moodEmoji'],
      moodDescription: json['moodDescription'],
      notes: json['notes'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
    );
  }
}
