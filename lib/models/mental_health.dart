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

class GratitudeEntry {
  final String id;
  final DateTime date;
  final List<String> gratitudeItems;

  GratitudeEntry({
    required this.id,
    required this.date,
    required this.gratitudeItems,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'gratitudeItems': gratitudeItems,
    };
  }

  factory GratitudeEntry.fromJson(Map<String, dynamic> json) {
    return GratitudeEntry(
      id: json['id'],
      date: DateTime.parse(json['date']),
      gratitudeItems: List<String>.from(json['gratitudeItems']),
    );
  }
}

class Meditation {
  final String id;
  final String title;
  final String description;
  final int durationMinutes;
  final String category;
  final String audioUrl;
  final String imageUrl;
  final String instructor;
  final List<String> benefits;

  Meditation({
    required this.id,
    required this.title,
    required this.description,
    required this.durationMinutes,
    required this.category,
    required this.audioUrl,
    required this.imageUrl,
    required this.instructor,
    this.benefits = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'durationMinutes': durationMinutes,
      'category': category,
      'audioUrl': audioUrl,
      'imageUrl': imageUrl,
      'instructor': instructor,
      'benefits': benefits,
    };
  }

  factory Meditation.fromJson(Map<String, dynamic> json) {
    return Meditation(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      durationMinutes: json['durationMinutes'],
      category: json['category'],
      audioUrl: json['audioUrl'],
      imageUrl: json['imageUrl'],
      instructor: json['instructor'],
      benefits: List<String>.from(json['benefits'] ?? []),
    );
  }
}

class BreathingExercise {
  final String id;
  final String name;
  final String description;
  final String technique;
  final int inhaleCount;
  final int holdCount;
  final int exhaleCount;
  final int cycles;
  final String benefits;

  BreathingExercise({
    required this.id,
    required this.name,
    required this.description,
    required this.technique,
    required this.inhaleCount,
    required this.holdCount,
    required this.exhaleCount,
    required this.cycles,
    required this.benefits,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'technique': technique,
      'inhaleCount': inhaleCount,
      'holdCount': holdCount,
      'exhaleCount': exhaleCount,
      'cycles': cycles,
      'benefits': benefits,
    };
  }

  factory BreathingExercise.fromJson(Map<String, dynamic> json) {
    return BreathingExercise(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      technique: json['technique'],
      inhaleCount: json['inhaleCount'],
      holdCount: json['holdCount'],
      exhaleCount: json['exhaleCount'],
      cycles: json['cycles'],
      benefits: json['benefits'],
    );
  }
}

class MentalHealthChallenge {
  final String id;
  final String title;
  final String description;
  final int durationDays;
  final List<String> dailyTasks;
  final String category;
  final String badge;
  final List<String> benefits;

  MentalHealthChallenge({
    required this.id,
    required this.title,
    required this.description,
    required this.durationDays,
    required this.dailyTasks,
    required this.category,
    required this.badge,
    this.benefits = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'durationDays': durationDays,
      'dailyTasks': dailyTasks,
      'category': category,
      'badge': badge,
      'benefits': benefits,
    };
  }

  factory MentalHealthChallenge.fromJson(Map<String, dynamic> json) {
    return MentalHealthChallenge(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      durationDays: json['durationDays'],
      dailyTasks: List<String>.from(json['dailyTasks']),
      category: json['category'],
      badge: json['badge'],
      benefits: List<String>.from(json['benefits'] ?? []),
    );
  }
}

class ChallengeProgress {
  final String id;
  final String challengeId;
  final DateTime startDate;
  final int currentDay;
  final List<bool> completedDays;
  final bool isCompleted;

  ChallengeProgress({
    required this.id,
    required this.challengeId,
    required this.startDate,
    required this.currentDay,
    required this.completedDays,
    required this.isCompleted,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'challengeId': challengeId,
      'startDate': startDate.toIso8601String(),
      'currentDay': currentDay,
      'completedDays': completedDays,
      'isCompleted': isCompleted,
    };
  }

  factory ChallengeProgress.fromJson(Map<String, dynamic> json) {
    return ChallengeProgress(
      id: json['id'],
      challengeId: json['challengeId'],
      startDate: DateTime.parse(json['startDate']),
      currentDay: json['currentDay'],
      completedDays: List<bool>.from(json['completedDays']),
      isCompleted: json['isCompleted'],
    );
  }
}

class Affirmation {
  final String id;
  final String text;
  final String category;
  final String audioUrl;

  Affirmation({
    required this.id,
    required this.text,
    required this.category,
    this.audioUrl = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'category': category,
      'audioUrl': audioUrl,
    };
  }

  factory Affirmation.fromJson(Map<String, dynamic> json) {
    return Affirmation(
      id: json['id'],
      text: json['text'],
      category: json['category'],
      audioUrl: json['audioUrl'] ?? '',
    );
  }
}

class MotivationalQuote {
  final String id;
  final String quote;
  final String author;
  final String category;

  MotivationalQuote({
    required this.id,
    required this.quote,
    required this.author,
    required this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quote': quote,
      'author': author,
      'category': category,
    };
  }

  factory MotivationalQuote.fromJson(Map<String, dynamic> json) {
    return MotivationalQuote(
      id: json['id'],
      quote: json['quote'],
      author: json['author'],
      category: json['category'],
    );
  }
}
