import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class MoodSelector extends StatelessWidget {
  final int selectedMood;
  final Function(int) onMoodSelected;
  final bool isCompact;

  const MoodSelector({
    super.key,
    required this.selectedMood,
    required this.onMoodSelected,
    this.isCompact = false,
  });

  static const List<Map<String, dynamic>> moods = [
    {
      'level': 1,
      'emoji': '😢',
      'label': 'Terrible',
      'color': Color(0xFFEF4444),
      'description': 'Having a really tough day',
    },
    {
      'level': 2,
      'emoji': '😔',
      'label': 'Bad',
      'color': Color(0xFFF97316),
      'description': 'Not feeling great',
    },
    {
      'level': 3,
      'emoji': '😐',
      'label': 'Okay',
      'color': Color(0xFFF59E0B),
      'description': 'Feeling neutral',
    },
    {
      'level': 4,
      'emoji': '😊',
      'label': 'Good',
      'color': Color(0xFF10B981),
      'description': 'Having a good day',
    },
    {
      'level': 5,
      'emoji': '😄',
      'label': 'Amazing',
      'color': Color(0xFF059669),
      'description': 'Feeling fantastic!',
    },
  ];

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: moods.map((mood) => _buildCompactMoodButton(context, mood)).toList(),
      );
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: moods.map((mood) => _buildMoodButton(context, mood)).toList(),
        ),
        const SizedBox(height: AppTheme.spaceM),
        if (selectedMood > 0)
          Container(
            padding: const EdgeInsets.all(AppTheme.spaceM),
            decoration: BoxDecoration(
              color: moods[selectedMood - 1]['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              border: Border.all(
                color: moods[selectedMood - 1]['color'].withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Text(
                  moods[selectedMood - 1]['emoji'],
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: AppTheme.spaceM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        moods[selectedMood - 1]['label'],
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: moods[selectedMood - 1]['color'],
                        ),
                      ),
                      Text(
                        moods[selectedMood - 1]['description'],
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildMoodButton(BuildContext context, Map<String, dynamic> mood) {
    final isSelected = selectedMood == mood['level'];
    
    return GestureDetector(
      onTap: () => onMoodSelected(mood['level']),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppTheme.spaceM),
        decoration: BoxDecoration(
          color: isSelected 
              ? mood['color'].withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: Border.all(
            color: isSelected 
                ? mood['color']
                : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              mood['emoji'],
              style: TextStyle(
                fontSize: isSelected ? 32 : 28,
              ),
            ),
            const SizedBox(height: AppTheme.spaceXS),
            Text(
              mood['label'],
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? mood['color'] : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactMoodButton(BuildContext context, Map<String, dynamic> mood) {
    final isSelected = selectedMood == mood['level'];
    
    return GestureDetector(
      onTap: () => onMoodSelected(mood['level']),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppTheme.spaceS),
        decoration: BoxDecoration(
          color: isSelected 
              ? mood['color'].withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          border: Border.all(
            color: isSelected 
                ? mood['color']
                : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          mood['emoji'],
          style: TextStyle(
            fontSize: isSelected ? 24 : 20,
          ),
        ),
      ),
    );
  }
}