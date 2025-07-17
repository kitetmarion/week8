import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/workout_service.dart'; // Make sure this path is correct

class WorkoutSummaryScreen extends StatelessWidget {
  const WorkoutSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workout Summary')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Workout Complete! 🎉',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 30),

            // 🔥 This is where your save button goes:
            ElevatedButton(
              onPressed: () async {
                final uid = FirebaseAuth.instance.currentUser?.uid;

                if (uid != null) {
                  await WorkoutService().addWorkoutEntry(
                    uid: uid,
                    type: 'Full Body Strength',
                    duration: 45,
                    date: DateTime.now(),
                    notes: 'Felt great today 💪',
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Workout saved ✅')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User not logged in ❌')),
                  );
                }
              },
              child: const Text('Save Workout'),
            ),
          ],
        ),
      ),
    );
  }
}
