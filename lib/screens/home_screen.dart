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

  void _logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                AuthService.logout();
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF1A1D29),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1A1D29),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadDashboardData,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with profile
                _buildHeader(),
                const SizedBox(height: 30),

                // Welcome message
                _buildWelcomeMessage(),
                const SizedBox(height: 30),

                // Stats row
                _buildStatsRow(),
                const SizedBox(height: 30),

                // Goal card
                _buildGoalCard(),
                const SizedBox(height: 30),

                // Excitings section
                _buildExcitingsSection(),
                const SizedBox(height: 30),

                // Weekly goal chart
                _buildWeeklyGoalChart(),
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
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.menu,
            color: Colors.white,
            size: 24,
          ),
        ),
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.blue[400],
          child: Text(
            currentUser?.fullName.isNotEmpty == true 
                ? currentUser!.fullName[0].toUpperCase()
                : 'U',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeMessage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Good Morning',
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          currentUser?.fullName ?? 'User',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatItem('Nagar', '201', Colors.white),
        _buildStatItem('Thakle', '24', Colors.white),
        _buildStatItem('Turd', '17', Colors.orange),
        _buildStatItem('You', '73', Colors.orange),
        _buildStatItem('Impure', '037', Colors.white),
        _buildStatItem('Sere', '9', Colors.white),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, Color valueColor) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildGoalCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.orange,
            child: const Icon(
              Icons.emoji_events,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Lauratic Goal',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'JCPPL',
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '#MYGOAL2024',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '#2024',
                        style: TextStyle(
                          color: Colors.purple,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                'Coins 04',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 12,
                ),
              ),
              const Text(
                '\$23',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExcitingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Excitings',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(
              Icons.search,
              color: Colors.white.withOpacity(0.6),
              size: 24,
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildExcitingItem(
          'Samaria Exercises',
          '\$15722.6',
          Icons.fitness_center,
          Colors.blue,
        ),
        const SizedBox(height: 15),
        _buildExcitingItem(
          'Progress',
          '\$45,831',
          Icons.trending_up,
          Colors.green,
        ),
        const SizedBox(height: 15),
        _buildExcitingItem(
          'Stermear',
          '\$2920.817',
          Icons.psychology,
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildExcitingItem(String title, String amount, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            amount,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyGoalChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Weekly goal',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '\$218,325',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          '5 habits',
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 20),
        
        // Chart bars
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildChartBar('Sun', 0.3, Colors.blue),
            _buildChartBar('M', 0.6, Colors.orange),
            _buildChartBar('Tue', 0.2, Colors.yellow),
            _buildChartBar('W', 0.8, Colors.purple),
            _buildChartBar('Thu', 0.4, Colors.orange),
            _buildChartBar('F', 0.9, Colors.yellow),
            _buildChartBar('Sat', 0.1, Colors.green),
          ],
        ),
        const SizedBox(height: 30),
        
        // Action button
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(25),
          ),
          child: const Text(
            'Mio Manbooth for Ropay',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChartBar(String day, double height, Color color) {
    return Column(
      children: [
        Container(
          width: 20,
          height: 100 * height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                color,
                color.withOpacity(0.3),
              ],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          day,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}