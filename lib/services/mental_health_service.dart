import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wellness/models/meditation_session.dart';
import '../models/mental_health.dart';
import 'firebase_service.dart';

class MentalHealthService {
  static final FirebaseFirestore _firestore = FirebaseService.firestore;
  static final FirebaseAuth _auth = FirebaseService.auth;

  // Mood Tracking
  static Future<bool> addMoodEntry(MoodEntry mood) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      await FirebaseService.getUserMentalHealth(currentUser.uid).add({
        'type': 'mood',
        'date': Timestamp.fromDate(mood.date),
        'moodLevel': mood.moodLevel,
        'moodEmoji': mood.moodEmoji,
        'moodDescription': mood.moodDescription,
        'notes': mood.notes,
        'tags': mood.tags,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      print('Error adding mood entry: $e');
      return false;
    }
  }

  static Future<List<MoodEntry>> getMoodEntries() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) return [];

      QuerySnapshot snapshot = await FirebaseService.getUserMentalHealth(currentUser.uid)
          .where('type', isEqualTo: 'mood')
          .orderBy('date', descending: true)
          .limit(50)
          .get();

      List<MoodEntry> moods = [];
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        
        moods.add(MoodEntry(
          id: doc.id,
          date: (data['date'] as Timestamp).toDate(),
          moodLevel: data['moodLevel'],
          moodEmoji: data['moodEmoji'],
          moodDescription: data['moodDescription'],
          notes: data['notes'] ?? '',
          tags: List<String>.from(data['tags'] ?? []),
        ));
      }

      return moods;
    } catch (e) {
      print('Error getting mood entries: $e');
      return [];
    }
  }

  static Future<List<MoodEntry>> getMoodEntriesForWeek() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) return [];

      final weekAgo = DateTime.now().subtract(const Duration(days: 7));

      QuerySnapshot snapshot = await FirebaseService.getUserMentalHealth(currentUser.uid)
          .where('type', isEqualTo: 'mood')
          .where('date', isGreaterThan: Timestamp.fromDate(weekAgo))
          .orderBy('date', descending: true)
          .get();

      List<MoodEntry> moods = [];
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        
        moods.add(MoodEntry(
          id: doc.id,
          date: (data['date'] as Timestamp).toDate(),
          moodLevel: data['moodLevel'],
          moodEmoji: data['moodEmoji'],
          moodDescription: data['moodDescription'],
          notes: data['notes'] ?? '',
          tags: List<String>.from(data['tags'] ?? []),
        ));
      }

      return moods;
    } catch (e) {
      print('Error getting mood entries for week: $e');
      return [];
    }
  }

  static Future<double> getAverageMoodThisWeek() async {
    final weekMoods = await getMoodEntriesForWeek();
    if (weekMoods.isEmpty) return 0.0;
    final int sum = weekMoods.fold<int>(0, (sum, mood) => sum + mood.moodLevel);
    return sum / weekMoods.length;
  }

  // Gratitude Journal
  static Future<bool> addGratitudeEntry(GratitudeEntry gratitude) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      await FirebaseService.getUserMentalHealth(currentUser.uid).add({
        'type': 'gratitude',
        'date': Timestamp.fromDate(gratitude.date),
        'gratitudeItems': gratitude.gratitudeItems,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      print('Error adding gratitude entry: $e');
      return false;
    }
  }

  static Future<List<GratitudeEntry>> getGratitudeEntries() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) return [];

      QuerySnapshot snapshot = await FirebaseService.getUserMentalHealth(currentUser.uid)
          .where('type', isEqualTo: 'gratitude')
          .orderBy('date', descending: true)
          .limit(30)
          .get();

      List<GratitudeEntry> entries = [];
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        
        entries.add(GratitudeEntry(
          id: doc.id,
          date: (data['date'] as Timestamp).toDate(),
          gratitudeItems: List<String>.from(data['gratitudeItems']),
        ));
      }

      return entries;
    } catch (e) {
      print('Error getting gratitude entries: $e');
      return [];
    }
  }

  static Future<GratitudeEntry?> getTodayGratitude() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) return null;

      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);

      QuerySnapshot snapshot = await FirebaseService.getUserMentalHealth(currentUser.uid)
          .where('type', isEqualTo: 'gratitude')
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        Map<String, dynamic> data = snapshot.docs.first.data() as Map<String, dynamic>;
        return GratitudeEntry(
          id: snapshot.docs.first.id,
          date: (data['date'] as Timestamp).toDate(),
          gratitudeItems: List<String>.from(data['gratitudeItems']),
        );
      }

      return null;
    } catch (e) {
      print('Error getting today\'s gratitude: $e');
      return null;
    }
  }

  // Meditation Sessions
  static Future<bool> completeMeditation(CompletedMeditation meditation) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      await FirebaseService.getUserMentalHealth(currentUser.uid).add({
        'type': 'meditation',
        'sessionId': meditation.sessionId,
        'completedAt': Timestamp.fromDate(meditation.completedAt),
        'actualDuration': meditation.actualDuration,
        'rating': meditation.rating,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      print('Error saving completed meditation: $e');
      return false;
    }
  }

  static Future<List<CompletedMeditation>> getCompletedMeditations() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) return [];

      QuerySnapshot snapshot = await FirebaseService.getUserMentalHealth(currentUser.uid)
          .where('type', isEqualTo: 'meditation')
          .orderBy('completedAt', descending: true)
          .limit(50)
          .get();

      List<CompletedMeditation> meditations = [];
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        
        meditations.add(CompletedMeditation(
          sessionId: data['sessionId'],
          completedAt: (data['completedAt'] as Timestamp).toDate(),
          actualDuration: data['actualDuration'],
          rating: data['rating'],
        ));
      }

      return meditations;
    } catch (e) {
      print('Error getting completed meditations: $e');
      return [];
    }
  }

  // Predefined content methods
  static Future<List<Meditation>> getMeditations() async {
    // Return predefined meditations
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
  static Future<bool> startChallenge(String challengeId) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      final challenge = (await getChallenges()).firstWhere((c) => c.id == challengeId);
      
      await FirebaseService.getUserMentalHealth(currentUser.uid).add({
        'type': 'challenge_progress',
        'challengeId': challengeId,
        'startDate': Timestamp.fromDate(DateTime.now()),
        'currentDay': 1,
        'completedDays': List.filled(challenge.durationDays, false),
        'isCompleted': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      print('Error starting challenge: $e');
      return false;
    }
  }

  static Future<List<ChallengeProgress>> getActiveChallenges() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) return [];

      QuerySnapshot snapshot = await FirebaseService.getUserMentalHealth(currentUser.uid)
          .where('type', isEqualTo: 'challenge_progress')
          .where('isCompleted', isEqualTo: false)
          .orderBy('startDate', descending: true)
          .get();

      List<ChallengeProgress> challenges = [];
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        
        challenges.add(ChallengeProgress(
          id: doc.id,
          challengeId: data['challengeId'],
          startDate: (data['startDate'] as Timestamp).toDate(),
          currentDay: data['currentDay'],
          completedDays: List<bool>.from(data['completedDays']),
          isCompleted: data['isCompleted'],
        ));
      }

      return challenges;
    } catch (e) {
      print('Error getting active challenges: $e');
      return [];
    }
  }

  static Future<bool> markDayComplete(String progressId, int day) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      DocumentSnapshot doc = await FirebaseService.getUserMentalHealth(currentUser.uid)
          .doc(progressId)
          .get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        List<bool> completedDays = List<bool>.from(data['completedDays']);
        
        if (day > 0 && day <= completedDays.length) {
          completedDays[day - 1] = true;
          
          await doc.reference.update({
            'completedDays': completedDays,
            'currentDay': data['currentDay'] + 1,
            'isCompleted': completedDays.every((completed) => completed),
            'updatedAt': FieldValue.serverTimestamp(),
          });
          
          return true;
        }
      }

      return false;
    } catch (e) {
      print('Error marking day complete: $e');
      return false;
    }
  }

  // Affirmations
  static Future<List<Affirmation>> getAffirmations() async {
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

  // Delete entries
  static Future<bool> deleteMoodEntry(String entryId) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      await FirebaseService.getUserMentalHealth(currentUser.uid).doc(entryId).delete();
      return true;
    } catch (e) {
      print('Error deleting mood entry: $e');
      return false;
    }
  }

  static Future<bool> deleteGratitudeEntry(String entryId) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      await FirebaseService.getUserMentalHealth(currentUser.uid).doc(entryId).delete();
      return true;
    } catch (e) {
      print('Error deleting gratitude entry: $e');
      return false;
    }
  }
}