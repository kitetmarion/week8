class MeditationSession {
  final String id;
  final String title;
  final String description;
  final int durationMinutes;
  final String category;
  final String audioUrl;
  final String imageUrl;
  final int difficulty; // 1-3 (Beginner, Intermediate, Advanced)
  final List<String> benefits;

  MeditationSession({
    required this.id,
    required this.title,
    required this.description,
    required this.durationMinutes,
    required this.category,
    required this.audioUrl,
    required this.imageUrl,
    required this.difficulty,
    this.benefits = const [],
  });

  String get difficultyText {
    switch (difficulty) {
      case 1:
        return 'Beginner';
      case 2:
        return 'Intermediate';
      case 3:
        return 'Advanced';
      default:
        return 'Beginner';
    }
  }
}

class CompletedMeditation {
  final String sessionId;
  final DateTime completedAt;
  final int actualDuration;
  final int rating; // 1-5 stars

  CompletedMeditation({
    required this.sessionId,
    required this.completedAt,
    required this.actualDuration,
    required this.rating,
  });

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'completedAt': completedAt.toIso8601String(),
      'actualDuration': actualDuration,
      'rating': rating,
    };
  }

  factory CompletedMeditation.fromJson(Map<String, dynamic> json) {
    return CompletedMeditation(
      sessionId: json['sessionId'],
      completedAt: DateTime.parse(json['completedAt']),
      actualDuration: json['actualDuration'],
      rating: json['rating'],
    );
  }
}
