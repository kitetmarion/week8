import 'package:flutter/material.dart';
import '../models/mental_health.dart';
import '../services/mental_health_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/modern_card.dart';
import '../widgets/mood_selector.dart';
import '../theme/app_theme.dart';

class MoodTrackerScreen extends StatefulWidget {
  const MoodTrackerScreen({super.key});

  @override
  _MoodTrackerScreenState createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends State<MoodTrackerScreen> {
  int _selectedMood = 0;
  final _notesController = TextEditingController();
  final _gratitudeController = TextEditingController();
  List<String> _selectedTags = [];
  bool _isLoading = false;

  final List<String> _availableTags = [
    'Work', 'Family', 'Friends', 'Exercise', 'Sleep', 'Health',
    'Stress', 'Anxiety', 'Happy', 'Tired', 'Motivated', 'Peaceful'
  ];

  @override
  void dispose() {
    _notesController.dispose();
    _gratitudeController.dispose();
    super.dispose();
  }

  Future<void> _saveMoodEntry() async {
    if (_selectedMood == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select your mood first'),
          backgroundColor: AppTheme.warningColor,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final moodData = MoodSelector.moods.firstWhere((m) => m['level'] == _selectedMood);
      
      final entry = MoodEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        date: DateTime.now(),
        moodLevel: _selectedMood,
        moodEmoji: moodData['emoji'],
        moodDescription: moodData['label'],
        notes: _notesController.text,
        tags: _selectedTags,
      );

      final success = await MentalHealthService.addMoodEntry(entry);

      if (success) {
        // Also save gratitude if provided
        if (_gratitudeController.text.isNotEmpty) {
          final gratitudeEntry = GratitudeEntry(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            date: DateTime.now(),
            gratitudeItems: [_gratitudeController.text],
          );
          await MentalHealthService.addGratitudeEntry(gratitudeEntry);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Mood entry saved! ${moodData['emoji']}'),
            backgroundColor: AppTheme.successColor,
          ),
        );

        // Reset form
        setState(() {
          _selectedMood = 0;
          _selectedTags.clear();
        });
        _notesController.clear();
        _gratitudeController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save mood entry'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Mood Check-in'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            ModernCard(
              backgroundColor: AppTheme.primaryColor.withOpacity(0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppTheme.spaceS),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                        ),
                        child: Icon(
                          Icons.mood,
                          color: AppTheme.primaryColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: AppTheme.spaceM),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'How are you feeling?',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Take a moment to check in with yourself',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppTheme.spaceL),

            // Mood Selection
            ModernCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select your mood',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spaceM),
                  MoodSelector(
                    selectedMood: _selectedMood,
                    onMoodSelected: (mood) {
                      setState(() {
                        _selectedMood = mood;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppTheme.spaceL),

            // Tags Selection
            ModernCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What influenced your mood?',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spaceM),
                  Wrap(
                    spacing: AppTheme.spaceS,
                    runSpacing: AppTheme.spaceS,
                    children: _availableTags.map((tag) {
                      final isSelected = _selectedTags.contains(tag);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedTags.remove(tag);
                            } else {
                              _selectedTags.add(tag);
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spaceM,
                            vertical: AppTheme.spaceS,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected 
                                ? AppTheme.primaryColor.withOpacity(0.1)
                                : AppTheme.backgroundColor,
                            borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                            border: Border.all(
                              color: isSelected 
                                  ? AppTheme.primaryColor
                                  : AppTheme.textTertiary,
                            ),
                          ),
                          child: Text(
                            tag,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: isSelected 
                                  ? AppTheme.primaryColor
                                  : AppTheme.textSecondary,
                              fontWeight: isSelected 
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppTheme.spaceL),

            // Notes Section
            ModernCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Additional thoughts (optional)',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spaceM),
                  TextField(
                    controller: _notesController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'What\'s on your mind? How was your day?',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppTheme.spaceL),

            // Gratitude Section
            ModernCard(
              backgroundColor: AppTheme.successColor.withOpacity(0.05),
              border: Border.all(color: AppTheme.successColor.withOpacity(0.2)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.favorite,
                        color: AppTheme.successColor,
                        size: 20,
                      ),
                      const SizedBox(width: AppTheme.spaceS),
                      Text(
                        'Gratitude moment',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.successColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spaceM),
                  TextField(
                    controller: _gratitudeController,
                    decoration: const InputDecoration(
                      hintText: 'What are you grateful for today?',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppTheme.spaceXL),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: _isLoading ? 'Saving...' : 'Save Mood Entry',
                onPressed: _isLoading ? null : _saveMoodEntry,
                isLoading: _isLoading,
                backgroundColor: AppTheme.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}