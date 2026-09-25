import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Auto-generated file

class AddGoalScreen extends StatelessWidget {
  final TextEditingController _goalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.addGoal),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _goalController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.enterGoal,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String goal = _goalController.text.trim();
                if (goal.isNotEmpty) {
                  // Save goal to Firestore
                  await FirebaseFirestore.instance.collection('goals').add({
                    'goal': goal,
                    'status': 'active', // Mark the goal as active
                    'createdAt': Timestamp.now(),
                  });
                  Navigator.pop(context); // Go back to the previous screen
                }
              },
              child: Text(AppLocalizations.of(context)!.addGoal),
            ),
          ],
        ),
      ),
    );
  }
}
