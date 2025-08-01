import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/modern_card.dart';
import '../services/auth_service.dart';
import '../services/workout_service.dart';
import '../services/food_service.dart';
import '../services/mental_health_service.dart';
import '../models/user.dart';
import '../models/workout.dart';
import '../models/food_entry.dart';
import '../models/mental_health.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? currentUser;
  bool _isLoading = true;
  
  // Dashboard data
  List<WorkoutSession> _recentWorkouts = [];
  List<MealEntry> _todayMeals = [];
  List<MoodEntry> _recentMoods = [];
  Map<String, int> _todayNutrition = {};
  Map<String, int> _weeklyStats = {};
  double _averageMood = 0.0;
  String _dailyTip = '';

  @override
  void initState() {
    super.initState();
    _initializeUser();
    _loadDashboardData();
  }

  void _initializeUser() {
    final firebaseUser = AuthService.getCurrentUser();
    if (firebaseUser != null) {
      currentUser = User(
        fullName: firebaseUser.displayName ?? '',
        username: firebaseUser.email?.split('@').first ?? '',
        email: firebaseUser.email ?? '',
        phoneNumber: firebaseUser.phoneNumber ?? '',
        password: '',
      );
    }
  }

  Future<void> _loadDashboardData() async {
    try {
      final results = await Future.wait([
        WorkoutService.getRecentWorkouts(),
        FoodService.getMealEntriesForDate(DateTime.now()),
        MentalHealthService.getMoodEntriesForWeek(),
        FoodService.getTodayNutrition(),
        _getWeeklyStats(),
        MentalHealthService.getAverageMoodThisWeek(),
        MentalHealthService.getDailyMindfulnessTip(),
      ]);

      setState(() {
        _recentWorkouts = results[0] as List<WorkoutSession>;
        _todayMeals = results[1] as List<MealEntry>;
        _recentMoods = results[2] as List<MoodEntry>;
        _todayNutrition = results[3] as Map<String, int>;
        _weeklyStats = results[4] as Map<String, int>;
        _averageMood = results[5] as double;
        _dailyTip = results[6] as String;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading dashboard data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<Map<String, int>> _getWeeklyStats() async {
    final workouts = await WorkoutService.getTotalWorkoutsThisWeek();
    final calories = await WorkoutService.getTotalCaloriesBurnedThisWeek();
    final minutes = await WorkoutService.getTotalWorkoutMinutesThisWeek();
    
    return {
      'workouts': workouts,
      'calories': calories,
      'minutes': minutes,
    };
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadDashboardData,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with greeting
                _buildHeader(),
                const SizedBox(height: 30),

                // Quick stats cards
                _buildQuickStats(),
                const SizedBox(height: 30),

                // Today's progress
                _buildTodaysProgress(),
                const SizedBox(height: 30),

                // Recent activity
                _buildRecentActivity(),
                const SizedBox(height: 30),

                // Quick actions
                _buildQuickActions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good ${_getTimeOfDay()}',
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              currentUser?.fullName ?? 'Welcome',
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        CircleAvatar(
          radius: 25,
          backgroundColor: AppTheme.primaryColor,
          child: Text(
            currentUser?.fullName.isNotEmpty == true 
                ? currentUser!.fullName[0].toUpperCase()
                : 'U',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats() {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            title: 'Workouts',
            value: '${_weeklyStats['workouts'] ?? 0}',
            subtitle: 'This week',
            icon: Icons.fitness_center,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: StatCard(
            title: 'Calories',
            value: '${_weeklyStats['calories'] ?? 0}',
            subtitle: 'Burned',
            icon: Icons.local_fire_department,
            color: AppTheme.accentColor,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: StatCard(
            title: 'Minutes',
            value: '${_weeklyStats['minutes'] ?? 0}',
            subtitle: 'Active',
            icon: Icons.timer,
            color: AppTheme.successColor,
          ),
        ),
      ],
    );
  }

  Widget _buildTodaysProgress() {
    final caloriesGoal = 2000;
    final currentCalories = _todayNutrition['calories'] ?? 0;
    final progress = currentCalories / caloriesGoal;

    return ModernCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Today\'s Progress',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildProgressItem('Calories', '$currentCalories', 'kcal'),
              _buildProgressItem('Protein', '${_todayNutrition['protein'] ?? 0}', 'g'),
              _buildProgressItem('Carbs', '${_todayNutrition['carbs'] ?? 0}', 'g'),
              _buildProgressItem('Fat', '${_todayNutrition['fat'] ?? 0}', 'g'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressItem(String label, String value, String unit) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        Text(
          unit,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_recentWorkouts.isEmpty && _recentMoods.isEmpty)
          ModernCard(
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.timeline,
                    size: 48,
                    color: AppTheme.textTertiary,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No recent activity',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Start your wellness journey today!',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Column(
            children: [
              ..._recentWorkouts.take(3).map((workout) => 
                ModernCard(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.fitness_center,
                          color: AppTheme.primaryColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Workout Completed',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            Text(
                              '${workout.actualDuration} minutes • ${workout.caloriesBurned} calories',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        _formatTime(workout.startTime),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textTertiary,
                        ),
                      ),
                    ],
                  ),
                )
              ),
              ..._recentMoods.take(2).map((mood) => 
                ModernCard(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          mood.moodEmoji,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Mood: ${mood.moodDescription}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            if (mood.notes.isNotEmpty)
                              Text(
                                mood.notes,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                      Text(
                        _formatTime(mood.date),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textTertiary,
                        ),
                      ),
                    ],
                  ),
                )
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ActionCard(
                title: 'Start Workout',
                subtitle: 'Begin your fitness journey',
                icon: Icons.play_arrow,
                color: AppTheme.primaryColor,
                onTap: () => _navigateToWorkouts(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ActionCard(
                title: 'Log Food',
                subtitle: 'Track your nutrition',
                icon: Icons.restaurant,
                color: AppTheme.successColor,
                onTap: () => _navigateToFoodLog(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ActionCard(
                title: 'Mood Check',
                subtitle: 'How are you feeling?',
                icon: Icons.mood,
                color: AppTheme.accentColor,
                onTap: () => _navigateToMoodTracker(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ActionCard(
                title: 'Meditate',
                subtitle: 'Find your peace',
                icon: Icons.self_improvement,
                color: AppTheme.secondaryColor,
                onTap: () => _navigateToMeditation(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _getTimeOfDay() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    return 'Evening';
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  void _navigateToWorkouts() {
    // Navigate to workouts tab
    DefaultTabController.of(context)?.animateTo(1);
  }

  void _navigateToFoodLog() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FoodLogScreen()),
    );
  }

  void _navigateToMoodTracker() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MoodTrackerScreen()),
    );
  }

  void _navigateToMeditation() {
    // Navigate to meditation tab
    DefaultTabController.of(context)?.animateTo(2);
  }
}