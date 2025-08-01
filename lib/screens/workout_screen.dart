import 'package:flutter/material.dart';
import '../models/workout.dart';
import '../services/workout_service.dart';
import '../theme/app_theme.dart';
import '../widgets/modern_card.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  List<Workout> _workouts = [];
  List<Workout> _filteredWorkouts = [];
  List<WorkoutSession> _recentSessions = [];
  bool _isLoading = true;
  String _selectedCategory = 'All';

  final List<String> _categories = ['All', 'Cardio', 'Strength', 'Yoga', 'HIIT', 'Core'];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final workouts = await WorkoutService.getWorkouts();
      final recentSessions = await WorkoutService.getRecentWorkouts();
      
      setState(() {
        _workouts = workouts;
        _filteredWorkouts = workouts;
        _recentSessions = recentSessions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterWorkouts(String category) {
    setState(() {
      _selectedCategory = category;
      if (category == 'All') {
        _filteredWorkouts = _workouts;
      } else {
        _filteredWorkouts = _workouts.where((workout) => workout.category == category).toList();
      }
    });
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
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Category filters
            _buildCategoryFilters(),
            
            // Workouts list
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadData,
                child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: _filteredWorkouts.length,
                  itemBuilder: (context, index) {
                    return _buildWorkoutCard(_filteredWorkouts[index]);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          const Icon(
            Icons.fitness_center,
            color: AppTheme.primaryColor,
            size: 32,
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Workouts',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Choose your fitness adventure',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _loadData,
            icon: const Icon(
              Icons.refresh,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;
          
          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => _filterWorkouts(category),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primaryColor : Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: isSelected ? AppTheme.primaryColor : AppTheme.textTertiary,
                  ),
                  boxShadow: isSelected ? [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ] : null,
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppTheme.textSecondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWorkoutCard(Workout workout) {
    return ModernCard(
      margin: const EdgeInsets.only(bottom: 16),
      onTap: () => _startWorkout(workout),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Workout image placeholder
          Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _getCategoryColor(workout.category).withOpacity(0.8),
                  _getCategoryColor(workout.category),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      workout.difficulty,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _getCategoryColor(workout.category),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Icon(
                    Icons.play_circle_filled,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            workout.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            workout.description,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildWorkoutStat(Icons.timer, '${workout.durationMinutes} min'),
              const SizedBox(width: 16),
              _buildWorkoutStat(Icons.local_fire_department, '${workout.calories} cal'),
              const SizedBox(width: 16),
              _buildWorkoutStat(Icons.category, workout.category),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getCategoryColor(workout.category).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.arrow_forward,
                  color: _getCategoryColor(workout.category),
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutStat(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppTheme.textTertiary,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'cardio':
        return AppTheme.accentColor;
      case 'strength':
        return AppTheme.primaryColor;
      case 'yoga':
        return AppTheme.secondaryColor;
      case 'hiit':
        return AppTheme.warningColor;
      case 'core':
        return AppTheme.successColor;
      default:
        return AppTheme.primaryColor;
    }
  }

  void _startWorkout(Workout workout) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutPlayerScreen(workout: workout),
      ),
    );
  }
}

class WorkoutPlayerScreen extends StatefulWidget {
  final Workout workout;

  const WorkoutPlayerScreen({super.key, required this.workout});

  @override
  _WorkoutPlayerScreenState createState() => _WorkoutPlayerScreenState();
}

class _WorkoutPlayerScreenState extends State<WorkoutPlayerScreen> {
  bool _isPlaying = false;
  int _currentSeconds = 0;
  int _totalSeconds = 0;

  @override
  void initState() {
    super.initState();
    _totalSeconds = widget.workout.durationMinutes * 60;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(widget.workout.title),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(),
            
            // Video Placeholder
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryColor.withOpacity(0.8),
                    AppTheme.primaryColor,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppTheme.elevatedShadow,
              ),
              child: Icon(
                Icons.play_circle_filled,
                size: 80,
                color: Colors.white,
              ),
            ),
            
            const SizedBox(height: 40),
            
            Text(
              widget.workout.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 8),
            
            Text(
              widget.workout.description,
              style: const TextStyle(
                fontSize: 16,
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 40),
            
            // Progress
            Text(
              '${(_currentSeconds ~/ 60).toString().padLeft(2, '0')}:${(_currentSeconds % 60).toString().padLeft(2, '0')} / ${(_totalSeconds ~/ 60).toString().padLeft(2, '0')}:${(_totalSeconds % 60).toString().padLeft(2, '0')}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            
            const SizedBox(height: 20),
            
            LinearProgressIndicator(
              value: _totalSeconds > 0 ? _currentSeconds / _totalSeconds : 0,
              backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
              borderRadius: BorderRadius.circular(8),
            ),
            
            const SizedBox(height: 40),
            
            // Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _currentSeconds = 0;
                    });
                  },
                  icon: const Icon(Icons.replay, size: 32),
                  color: AppTheme.textSecondary,
                ),
                
                const SizedBox(width: 20),
                
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.primaryColor,
                    boxShadow: AppTheme.elevatedShadow,
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _isPlaying = !_isPlaying;
                      });
                      
                      if (_isPlaying) {
                        _startTimer();
                      }
                    },
                    icon: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
                
                const SizedBox(width: 20),
                
                IconButton(
                  onPressed: () {
                    _completeWorkout();
                  },
                  icon: const Icon(Icons.stop, size: 32),
                  color: AppTheme.textSecondary,
                ),
              ],
            ),
            
            const Spacer(),
          ],
        ),
      ),
    );
  }

  void _startTimer() {
    if (_isPlaying && _currentSeconds < _totalSeconds) {
      Future.delayed(const Duration(seconds: 1), () {
        if (_isPlaying && mounted) {
          setState(() {
            _currentSeconds++;
          });
          
          if (_currentSeconds < _totalSeconds) {
            _startTimer();
          } else {
            _completeWorkout();
          }
        }
      });
    }
  }

  void _completeWorkout() {
    final session = WorkoutSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      workoutId: widget.workout.id,
      startTime: DateTime.now().subtract(Duration(seconds: _currentSeconds)),
      endTime: DateTime.now(),
      actualDuration: _currentSeconds ~/ 60,
      caloriesBurned: (widget.workout.calories * (_currentSeconds / _totalSeconds)).round(),
      notes: '',
    );
    
    WorkoutService.startWorkoutSession(session);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Workout Complete!'),
        content: Text('Great job! You burned ${session.caloriesBurned} calories in ${session.actualDuration} minutes.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}