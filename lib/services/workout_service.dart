import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/workout.dart';

class WorkoutService {
  static final List<WorkoutSession> _workoutSessions = [];

  static Future<List<Workout>> getWorkouts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      Workout(
        id: '1',
        title: 'Morning Cardio Blast',
        description: 'High-intensity cardio workout to kickstart your day',
        durationMinutes: 20,
        category: 'Cardio',
        difficulty: 'Beginner',
        videoUrl: '/placeholder-video.mp4',
        thumbnailUrl: '/placeholder.svg?height=200&width=300',
        equipment: ['None'],
        calories: 200,
      ),
      Workout(
        id: '2',
        title: 'Full Body Strength',
        description: 'Complete strength training for all muscle groups',
        durationMinutes: 45,
        category: 'Strength',
        difficulty: 'Intermediate',
        videoUrl: '/placeholder-video.mp4',
        thumbnailUrl: '/placeholder.svg?height=200&width=300',
        equipment: ['Dumbbells', 'Resistance Bands'],
        calories: 350,
      ),
      Workout(
        id: '3',
        title: 'Yoga Flow',
        description: 'Relaxing yoga sequence for flexibility and mindfulness',
        durationMinutes: 30,
        category: 'Yoga',
        difficulty: 'Beginner',
        videoUrl: '/placeholder-video.mp4',
        thumbnailUrl: '/placeholder.svg?height=200&width=300',
        equipment: ['Yoga Mat'],
        calories: 150,
      ),
      Workout(
        id: '4',
        title: 'HIIT Power Session',
        description: 'Intense interval training for maximum calorie burn',
        durationMinutes: 25,
        category: 'HIIT',
        difficulty: 'Advanced',
        videoUrl: '/placeholder-video.mp4',
        thumbnailUrl: '/placeholder.svg?height=200&width=300',
        equipment: ['None'],
        calories: 300,
      ),
      Workout(
        id: '5',
        title: 'Core Crusher',
        description: 'Targeted core workout for a strong midsection',
        durationMinutes: 15,
        category: 'Core',
        difficulty: 'Intermediate',
        videoUrl: '/placeholder-video.mp4',
        thumbnailUrl: '/placeholder.svg?height=200&width=300',
        equipment: ['Exercise Mat'],
        calories: 120,
      ),
    ];
  }

  static Future<List<Workout>> getWorkoutsByCategory(String category) async {
    final allWorkouts = await getWorkouts();
    if (category == 'All') return allWorkouts;
    return allWorkouts.where((workout) => workout.category == category).toList();
  }

  static Future<void> startWorkoutSession(WorkoutSession session) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _workoutSessions.add(session);
  }

  static Future<List<WorkoutSession>> getWorkoutSessions() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_workoutSessions);
  }

  static Future<List<WorkoutSession>> getRecentWorkouts() async {
    final sessions = await getWorkoutSessions();
    sessions.sort((a, b) => b.startTime.compareTo(a.startTime));
    return sessions.take(5).toList();
  }

  static int getTotalWorkoutsThisWeek() {
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    return _workoutSessions.where((session) => session.startTime.isAfter(weekAgo)).length;
  }

  static int getTotalCaloriesBurnedThisWeek() {
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    return _workoutSessions
        .where((session) => session.startTime.isAfter(weekAgo))
        .fold(0, (sum, session) => sum + session.caloriesBurned);
  }

  static int getTotalWorkoutMinutesThisWeek() {
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    return _workoutSessions
        .where((session) => session.startTime.isAfter(weekAgo))
        .fold(0, (sum, session) => sum + session.actualDuration);
  }
  Future<void> addWorkoutEntry({
  required String uid,
  required String type,
  required int duration,
  required DateTime date,
  String? notes,
}) async {
  try {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('workouts')
        .add({
      'type': type,
      'duration': duration,
      'date': Timestamp.fromDate(date), // ✅ Use Timestamp
      'notes': notes ?? '',
      'createdAt': FieldValue.serverTimestamp(),
    });
  } catch (e) {
    print('Error adding workout entry: $e');
    rethrow;
  }
}





}
