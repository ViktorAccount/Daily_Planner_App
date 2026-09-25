import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/auth_view_model.dart';
import 'login_screen.dart';
import 'settings_screen.dart';
import 'routine_screen.dart';
import 'summary_screen.dart';
import 'add_goal_screen.dart';
import 'view_goals_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Auto-generated file

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var user = context.watch<AuthViewModel>().user;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(''),
        actions: [
          TextButton(
            onPressed: () {
              context.read<AuthViewModel>().signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            child: Text(AppLocalizations.of(context)!.logout, style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          // User's email at the top
          Text(
            AppLocalizations.of(context)!.home,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 50),
          // Centered Title
          Text(
            'DAILY PLANNER',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          // Add Goal and View Goals buttons
          ElevatedButton(
            onPressed: () => _navigateTo(context, AddGoalScreen()),
            child: Text(AppLocalizations.of(context)!.addGoal),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _navigateTo(context, ViewGoalsScreen()),
            child: Text(AppLocalizations.of(context)!.viewGoals),
          ),
          Spacer(), // Pushes the Row to the bottom
          // Bottom Buttons: Settings, Routine, Summary
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _bottomButton(context, AppLocalizations.of(context)!.settingsTitle, SettingsScreen()),
                _bottomButton(context, AppLocalizations.of(context)!.routine, RoutineScreen()),
                _bottomButton(context, AppLocalizations.of(context)!.summary, SummaryScreen()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget to create bottom buttons
  Widget _bottomButton(BuildContext context, String title, Widget screen) {
    return ElevatedButton(
      onPressed: () => _navigateTo(context, screen),
      child: Text(title),
    );
  }

  // Helper function to navigate to screens
  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}
