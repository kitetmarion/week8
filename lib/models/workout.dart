class Workout {
  final String id;
  final String title;
  final String description;
  final int durationMinutes;
  final String category;
  final String difficulty;
  final String videoUrl;
  final String thumbnailUrl;
  final List<String> equipment;
  final int calories;

  Workout({
    required this.id,
    required this.title,
    required this.description,
    required this.durationMinutes,
    required this.category,
    required this.difficulty,
    required this.videoUrl,
    required this.thumbnailUrl,
    this.equipment = const [],
    required this.calories,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'durationMinutes': durationMinutes,
      'category': category,
      'difficulty': difficulty,
      'videoUrl': videoUrl,
      'thumbnailUrl': thumbnailUrl,
      'equipment': equipment,
      'calories': calories,
    };
  }

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      durationMinutes: json['durationMinutes'],
      category: json['category'],
      difficulty: json['difficulty'],
      videoUrl: json['videoUrl'],
      thumbnailUrl: json['thumbnailUrl'],
      equipment: List<String>.from(json['equipment'] ?? []),
      calories: json['calories'],
    );
  }
}

class WorkoutSession {
  final String id;
  final String workoutId;
  final DateTime startTime;
  final DateTime? endTime;
  final int actualDuration;
  final int caloriesBurned;
  final String notes;

  WorkoutSession({
    required this.id,
    required this.workoutId,
    required this.startTime,
    this.endTime,
    required this.actualDuration,
    required this.caloriesBurned,
    this.notes = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'workoutId': workoutId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'actualDuration': actualDuration,
      'caloriesBurned': caloriesBurned,
      'notes': notes,
    };
  }

  factory WorkoutSession.fromJson(Map<String, dynamic> json) {
    return WorkoutSession(
      id: json['id'],
      workoutId: json['workoutId'],
      startTime: DateTime.parse(json['startTime']),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      actualDuration: json['actualDuration'],
      caloriesBurned: json['caloriesBurned'],
      notes: json['notes'] ?? '',
    );
  }
}
