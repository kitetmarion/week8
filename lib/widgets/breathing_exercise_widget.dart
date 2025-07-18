import 'package:flutter/material.dart';
import 'dart:async';
import '../theme/app_theme.dart';
import '../widgets/modern_card.dart';

class BreathingExerciseWidget extends StatefulWidget {
  final String exerciseName;
  final int inhaleCount;
  final int holdCount;
  final int exhaleCount;
  final int cycles;

  const BreathingExerciseWidget({
    super.key,
    required this.exerciseName,
    required this.inhaleCount,
    required this.holdCount,
    required this.exhaleCount,
    required this.cycles,
  });

  @override
  _BreathingExerciseWidgetState createState() => _BreathingExerciseWidgetState();
}

class _BreathingExerciseWidgetState extends State<BreathingExerciseWidget>
    with TickerProviderStateMixin {
  late AnimationController _breathingController;
  late AnimationController _progressController;
  late Animation<double> _breathingAnimation;
  late Animation<double> _progressAnimation;
  
  Timer? _timer;
  int _currentCycle = 0;
  int _currentPhase = 0; // 0: inhale, 1: hold, 2: exhale, 3: hold
  int _currentCount = 0;
  bool _isActive = false;
  bool _isPaused = false;

  final List<String> _phaseNames = ['Inhale', 'Hold', 'Exhale', 'Hold'];
  final List<Color> _phaseColors = [
    AppTheme.infoColor,
    AppTheme.warningColor,
    AppTheme.successColor,
    AppTheme.accentColor,
  ];

  @override
  void initState() {
    super.initState();
    _breathingController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    _progressController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    
    _breathingAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _breathingController,
      curve: Curves.easeInOut,
    ));
    
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.linear,
    ));
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _progressController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startExercise() {
    setState(() {
      _isActive = true;
      _isPaused = false;
      _currentCycle = 0;
      _currentPhase = 0;
      _currentCount = 0;
    });
    _startPhase();
  }

  void _pauseExercise() {
    setState(() {
      _isPaused = !_isPaused;
    });
    
    if (_isPaused) {
      _timer?.cancel();
      _breathingController.stop();
      _progressController.stop();
    } else {
      _startPhase();
    }
  }

  void _stopExercise() {
    setState(() {
      _isActive = false;
      _isPaused = false;
      _currentCycle = 0;
      _currentPhase = 0;
      _currentCount = 0;
    });
    _timer?.cancel();
    _breathingController.reset();
    _progressController.reset();
  }

  void _startPhase() {
    if (!_isActive || _isPaused) return;

    final phaseDurations = [
      widget.inhaleCount,
      widget.holdCount,
      widget.exhaleCount,
      widget.holdCount,
    ];

    final currentPhaseDuration = phaseDurations[_currentPhase];
    _currentCount = currentPhaseDuration;

    // Start breathing animation
    if (_currentPhase == 0) { // Inhale
      _breathingController.forward();
    } else if (_currentPhase == 2) { // Exhale
      _breathingController.reverse();
    }

    // Start progress animation
    _progressController.reset();
    _progressController.forward();

    // Start countdown timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentCount--;
      });

      if (_currentCount <= 0) {
        timer.cancel();
        _nextPhase();
      }
    });
  }

  void _nextPhase() {
    setState(() {
      _currentPhase = (_currentPhase + 1) % 4;
      
      if (_currentPhase == 0) {
        _currentCycle++;
        if (_currentCycle >= widget.cycles) {
          _completeExercise();
          return;
        }
      }
    });
    
    _startPhase();
  }

  void _completeExercise() {
    setState(() {
      _isActive = false;
    });
    _timer?.cancel();
    _breathingController.reset();
    _progressController.reset();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exercise Complete!'),
        content: Text('Great job! You completed ${widget.cycles} cycles of ${widget.exerciseName}.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _startExercise();
            },
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(widget.exerciseName),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.spaceL),
        child: Column(
          children: [
            // Progress indicator
            ModernCard(
              child: Column(
                children: [
                  Text(
                    'Cycle ${_currentCycle + 1} of ${widget.cycles}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppTheme.spaceS),
                  LinearProgressIndicator(
                    value: _currentCycle / widget.cycles,
                    backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  ),
                ],
              ),
            ),
            
            const Spacer(),
            
            // Breathing circle
            AnimatedBuilder(
              animation: _breathingAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _breathingAnimation.value,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          _phaseColors[_currentPhase].withOpacity(0.3),
                          _phaseColors[_currentPhase].withOpacity(0.1),
                          Colors.transparent,
                        ],
                      ),
                      border: Border.all(
                        color: _phaseColors[_currentPhase],
                        width: 3,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_isActive) ...[
                            Text(
                              _phaseNames[_currentPhase],
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: _phaseColors[_currentPhase],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: AppTheme.spaceS),
                            Text(
                              '$_currentCount',
                              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                color: _phaseColors[_currentPhase],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ] else ...[
                            Icon(
                              Icons.air,
                              size: 48,
                              color: AppTheme.primaryColor,
                            ),
                            const SizedBox(height: AppTheme.spaceS),
                            Text(
                              'Ready to breathe?',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            
            const Spacer(),
            
            // Instructions
            ModernCard(
              backgroundColor: AppTheme.primaryColor.withOpacity(0.05),
              child: Column(
                children: [
                  Text(
                    'Instructions',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spaceS),
                  Text(
                    'Inhale ${widget.inhaleCount}s → Hold ${widget.holdCount}s → Exhale ${widget.exhaleCount}s → Hold ${widget.holdCount}s',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppTheme.spaceL),
            
            // Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isActive) ...[
                  FloatingActionButton(
                    onPressed: _pauseExercise,
                    backgroundColor: AppTheme.warningColor,
                    child: Icon(
                      _isPaused ? Icons.play_arrow : Icons.pause,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spaceM),
                  FloatingActionButton(
                    onPressed: _stopExercise,
                    backgroundColor: AppTheme.errorColor,
                    child: const Icon(
                      Icons.stop,
                      color: Colors.white,
                    ),
                  ),
                ] else ...[
                  FloatingActionButton.extended(
                    onPressed: _startExercise,
                    backgroundColor: AppTheme.primaryColor,
                    icon: const Icon(Icons.play_arrow, color: Colors.white),
                    label: const Text(
                      'Start Exercise',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}