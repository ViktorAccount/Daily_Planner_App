import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Auto-generated file


class SummaryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.summary),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('goals').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final goals = snapshot.data!.docs;

          // Calculate statistics
          int totalGoals = goals.length;
          int completedGoals =
              goals.where((g) => g['status'] == 'completed').length;
          int activeGoals =
              goals.where((g) => g['status'] == 'active').length;

          double completionPercentage =
              totalGoals == 0 ? 0 : (completedGoals / totalGoals) * 100;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.goalSummary,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                _buildStatCard(AppLocalizations.of(context)!.totalGoals, totalGoals.toString()),
                _buildStatCard(AppLocalizations.of(context)!.activeGoals, activeGoals.toString()),
                _buildStatCard(AppLocalizations.of(context)!.completedGoals, completedGoals.toString()),
                SizedBox(height: 20),
                _buildCompletionBar(completionPercentage),
                SizedBox(height: 10),
                Center(
                  child: Text(
                    'Completion: ${completionPercentage.toStringAsFixed(1)}%',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(height: 30),
                // Display Achievements
                _buildAchievementMessage(completedGoals),
              ],
            ),
          );
        },
      ),
    );
  }

  // Helper widget to display statistics as cards
  Widget _buildStatCard(String title, String value) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(title, style: TextStyle(fontSize: 18)),
        trailing: Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }

  // Helper widget to display a completion progress bar
  Widget _buildCompletionBar(double percentage) {
    return Column(
      children: [
        Text('Goal Completion Progress', style: TextStyle(fontSize: 16)),
        SizedBox(height: 10),
        LinearProgressIndicator(
          value: percentage / 100,
          minHeight: 10,
          backgroundColor: Colors.grey[300],
          color: Colors.green,
        ),
      ],
    );
  }

  // Helper widget to display the achievement message
  Widget _buildAchievementMessage(int completedGoals) {
    if (completedGoals == 0) return SizedBox.shrink();

    if (completedGoals % 10 == 0) {
      return Center(
        child: Text(
          '🎉 Congratulations! You have completed $completedGoals goals. Keep going! 🎉',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.orangeAccent,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }
    return SizedBox.shrink();
  }
}
