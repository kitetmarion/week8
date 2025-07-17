import '../models/mental_health.dart';

class MentalHealthService {
  static final List<MoodEntry> _moodEntries = [];
  static final List<GratitudeEntry> _gratitudeEntries = [];
  static final List<ChallengeProgress> _challengeProgress = [];

  // Mood Tracking
  static Future<void> addMoodEntry(MoodEntry mood) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _moodEntries.add(mood);
  }

  static Future<List<MoodEntry>> getMoodEntries() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_moodEntries);
  }

  static Future<List<MoodEntry>> getMoodEntriesForWeek() async {
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    final allMoods = await getMoodEntries();
    return allMoods.where((mood) => mood.date.isAfter(weekAgo)).toList();
  }

  static Future<double> getAverageMoodThisWeek() async {
    final weekMoods = await getMoodEntriesForWeek();
    if (weekMoods.isEmpty) return 0.0;
    final int sum = weekMoods.fold<int>(0, (sum, mood) => sum + (mood.moodLevel ?? 0));
    return sum / weekMoods.length;
  }

  // Gratitude Journal
  static Future<void> addGratitudeEntry(GratitudeEntry gratitude) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _gratitudeEntries.add(gratitude);
  }

  static Future<List<GratitudeEntry>> getGratitudeEntries() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_gratitudeEntries);
  }

  static Future<GratitudeEntry?> getTodayGratitude() async {
    final today = DateTime.now();
    final allEntries = await getGratitudeEntries();
    
    for (var entry in allEntries) {
      if (entry.date.year == today.year &&
          entry.date.month == today.month &&
          entry.date.day == today.day) {
        return entry;
      }
    }
    return null;
  }

  // Meditations
  static Future<List<Meditation>> getMeditations() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      Meditation(
        id: '1',
        title: 'Morning Mindfulness',
        description: 'Start your day with clarity and intention',
        durationMinutes: 10,
        category: 'Morning',
        audioUrl: '/placeholder-audio.mp3',
        imageUrl: '/placeholder.svg?height=200&width=300',
        instructor: 'Sarah Johnson',
        benefits: ['Reduces stress', 'Improves focus', 'Boosts energy'],
      ),
      Meditation(
        id: '2',
        title: 'Stress Relief',
        description: 'Release tension and find inner peace',
        durationMinutes: 15,
        category: 'Stress',
        audioUrl: '/placeholder-audio.mp3',
        imageUrl: '/placeholder.svg?height=200&width=300',
        instructor: 'Michael Chen',
        benefits: ['Reduces anxiety', 'Calms mind', 'Improves sleep'],
      ),
      Meditation(
        id: '3',
        title: 'Sleep Preparation',
        description: 'Gentle meditation to prepare for restful sleep',
        durationMinutes: 12,
        category: 'Sleep',
        audioUrl: '/placeholder-audio.mp3',
        imageUrl: '/placeholder.svg?height=200&width=300',
        instructor: 'Emma Wilson',
        benefits: ['Better sleep quality', 'Reduces insomnia', 'Relaxes body'],
      ),
      Meditation(
        id: '4',
        title: 'Anxiety Relief',
        description: 'Calm your mind and ease anxious thoughts',
        durationMinutes: 8,
        category: 'Anxiety',
        audioUrl: '/placeholder-audio.mp3',
        imageUrl: '/placeholder.svg?height=200&width=300',
        instructor: 'David Kumar',
        benefits: ['Reduces anxiety', 'Improves confidence', 'Calms nerves'],
      ),
      Meditation(
        id: '5',
        title: 'Energy Boost',
        description: 'Revitalize your mind and body',
        durationMinutes: 5,
        category: 'Energy',
        audioUrl: '/placeholder-audio.mp3',
        imageUrl: '/placeholder.svg?height=200&width=300',
        instructor: 'Lisa Park',
        benefits: ['Increases energy', 'Improves motivation', 'Enhances focus'],
      ),
    ];
  }

  static Future<List<Meditation>> getMeditationsByCategory(String category) async {
    final allMeditations = await getMeditations();
    if (category == 'All') return allMeditations;
    return allMeditations.where((meditation) => meditation.category == category).toList();
  }

  // Breathing Exercises
  static Future<List<BreathingExercise>> getBreathingExercises() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      BreathingExercise(
        id: '1',
        name: '4-7-8 Breathing',
        description: 'A powerful technique for relaxation and sleep',
        technique: 'Inhale for 4, hold for 7, exhale for 8',
        inhaleCount: 4,
        holdCount: 7,
        exhaleCount: 8,
        cycles: 4,
        benefits: 'Reduces anxiety, promotes sleep, calms nervous system',
      ),
      BreathingExercise(
        id: '2',
        name: 'Box Breathing',
        description: 'Equal breathing for focus and calm',
        technique: 'Inhale, hold, exhale, hold - all for equal counts',
        inhaleCount: 4,
        holdCount: 4,
        exhaleCount: 4,
        cycles: 6,
        benefits: 'Improves focus, reduces stress, enhances performance',
      ),
      BreathingExercise(
        id: '3',
        name: 'Deep Belly Breathing',
        description: 'Simple deep breathing for instant calm',
        technique: 'Breathe deeply into your belly',
        inhaleCount: 6,
        holdCount: 2,
        exhaleCount: 6,
        cycles: 8,
        benefits: 'Activates relaxation response, reduces tension',
      ),
    ];
  }

  // Mental Health Challenges
  static Future<List<MentalHealthChallenge>> getChallenges() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      MentalHealthChallenge(
        id: '1',
        title: '7-Day Anxiety Reduction Challenge',
        description: 'Daily practices to help manage and reduce anxiety',
        durationDays: 7,
        category: 'Anxiety',
        badge: '🧘‍♀️',
        dailyTasks: [
          'Practice 5-minute morning meditation',
          'Write down 3 things causing anxiety and challenge them',
          'Do 10 minutes of deep breathing exercises',
          'Take a mindful walk in nature',
          'Practice gratitude journaling',
          'Try progressive muscle relaxation',
          'Reflect on your progress and celebrate wins',
        ],
        benefits: ['Reduced anxiety levels', 'Better coping strategies', 'Improved self-awareness'],
      ),
      MentalHealthChallenge(
        id: '2',
        title: 'Mindful Mornings Challenge',
        description: 'Start each day with intention and mindfulness',
        durationDays: 14,
        category: 'Mindfulness',
        badge: '🌅',
        dailyTasks: [
          'Wake up 10 minutes earlier',
          'Practice morning meditation',
          'Set daily intentions',
          'Mindful breakfast eating',
          'Gratitude practice',
          'Gentle morning stretches',
          'Positive affirmations',
          'Mindful breathing',
          'Journal your thoughts',
          'Listen to calming music',
          'Practice self-compassion',
          'Mindful shower routine',
          'Connect with nature',
          'Celebrate your progress',
        ],
        benefits: ['Better morning routine', 'Increased mindfulness', 'Improved mood'],
      ),
      MentalHealthChallenge(
        id: '3',
        title: 'Digital Detox Challenge',
        description: 'Reduce screen time and reconnect with yourself',
        durationDays: 5,
        category: 'Digital Wellness',
        badge: '📱',
        dailyTasks: [
          'No phone for first hour after waking',
          'Take regular screen breaks every hour',
          'No devices during meals',
          'Replace scrolling with reading',
          'Phone-free evening routine',
        ],
        benefits: ['Better sleep', 'Reduced anxiety', 'Improved focus', 'More present moments'],
      ),
    ];
  }

  // Challenge Progress
  static Future<void> startChallenge(String challengeId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final challenge = (await getChallenges()).firstWhere((c) => c.id == challengeId);
    
    final progress = ChallengeProgress(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      challengeId: challengeId,
      startDate: DateTime.now(),
      currentDay: 1,
      completedDays: List.filled(challenge.durationDays, false),
      isCompleted: false,
    );
    
    _challengeProgress.add(progress);
  }

  static Future<List<ChallengeProgress>> getActiveChallenges() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _challengeProgress.where((progress) => !progress.isCompleted).toList();
  }

  static Future<void> markDayComplete(String progressId, int day) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final progressIndex = _challengeProgress.indexWhere((p) => p.id == progressId);
    if (progressIndex != -1) {
      final progress = _challengeProgress[progressIndex];
      final updatedCompletedDays = List<bool>.from(progress.completedDays);
      updatedCompletedDays[day - 1] = true;
      
      final updatedProgress = ChallengeProgress(
        id: progress.id,
        challengeId: progress.challengeId,
        startDate: progress.startDate,
        currentDay: progress.currentDay + 1,
        completedDays: updatedCompletedDays,
        isCompleted: updatedCompletedDays.every((completed) => completed),
      );
      
      _challengeProgress[progressIndex] = updatedProgress;
    }
  }

  // Affirmations
  static Future<List<Affirmation>> getAffirmations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      Affirmation(
        id: '1',
        text: 'I am capable of handling whatever comes my way',
        category: 'Confidence',
      ),
      Affirmation(
        id: '2',
        text: 'I choose peace over worry',
        category: 'Anxiety',
      ),
      Affirmation(
        id: '3',
        text: 'I am worthy of love and respect',
        category: 'Self-Love',
      ),
      Affirmation(
        id: '4',
        text: 'Every day I am growing stronger and wiser',
        category: 'Growth',
      ),
      Affirmation(
        id: '5',
        text: 'I trust in my ability to make good decisions',
        category: 'Confidence',
      ),
    ];
  }

  static Future<Affirmation> getDailyAffirmation() async {
    final affirmations = await getAffirmations();
    final today = DateTime.now();
    final index = today.day % affirmations.length;
    return affirmations[index];
  }

  // Motivational Quotes
  static Future<List<MotivationalQuote>> getMotivationalQuotes() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      MotivationalQuote(
        id: '1',
        quote: 'The only way out is through.',
        author: 'Robert Frost',
        category: 'Resilience',
      ),
      MotivationalQuote(
        id: '2',
        quote: 'You are braver than you believe, stronger than you seem, and smarter than you think.',
        author: 'A.A. Milne',
        category: 'Self-Belief',
      ),
      MotivationalQuote(
        id: '3',
        quote: 'Mental health is not a destination, but a process.',
        author: 'Noam Shpancer',
        category: 'Mental Health',
      ),
      MotivationalQuote(
        id: '4',
        quote: 'Your mental health is a priority. Your happiness is essential. Your self-care is a necessity.',
        author: 'Unknown',
        category: 'Self-Care',
      ),
      MotivationalQuote(
        id: '5',
        quote: 'It\'s okay to not be okay. It\'s not okay to stay that way.',
        author: 'Unknown',
        category: 'Hope',
      ),
    ];
  }

  static Future<MotivationalQuote> getDailyQuote() async {
    final quotes = await getMotivationalQuotes();
    final today = DateTime.now();
    final index = today.day % quotes.length;
    return quotes[index];
  }

  // Mindfulness Tips
  static Future<String> getDailyMindfulnessTip() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final tips = [
      'Take 1 minute to pause and observe your breath',
      'Notice 5 things you can see, 4 you can hear, 3 you can touch, 2 you can smell, 1 you can taste',
      'Practice eating one meal mindfully today',
      'Take three deep breaths before responding to stress',
      'Set a reminder to check in with your emotions every few hours',
      'Practice gratitude by naming three things you appreciate right now',
      'Take a mindful walk, focusing on each step',
      'Listen to sounds around you for 2 minutes without judgment',
      'Practice loving-kindness by sending good wishes to someone',
      'Notice your posture and gently adjust it with awareness',
    ];
    
    final today = DateTime.now();
    final index = today.day % tips.length;
    return tips[index];
  }

  // Professional Help Resources
  static Future<Map<String, dynamic>> getProfessionalHelpResources() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {
      'helplines': [
        {
          'name': 'National Suicide Prevention Lifeline',
          'number': '988',
          'description': '24/7 crisis support',
          'region': 'US',
        },
        {
          'name': 'Crisis Text Line',
          'number': 'Text HOME to 741741',
          'description': '24/7 text-based crisis support',
          'region': 'US',
        },
        {
          'name': 'SAMHSA National Helpline',
          'number': '1-800-662-4357',
          'description': 'Treatment referral and information service',
          'region': 'US',
        },
      ],
      'tips': [
        'It\'s okay to ask for help - it shows strength, not weakness',
        'Consider talking to a trusted friend, family member, or counselor',
        'Professional therapy can provide valuable tools and support',
        'Many employers offer Employee Assistance Programs (EAP)',
        'Online therapy platforms make mental health support more accessible',
      ],
    };
  }
}
