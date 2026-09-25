import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Auto-generated file

class ViewGoalsScreen extends StatefulWidget {
  @override
  _ViewGoalsScreenState createState() => _ViewGoalsScreenState();
}

class _ViewGoalsScreenState extends State<ViewGoalsScreen> {
  String _searchQuery = ""; // Store the search query
  TextEditingController _searchController = TextEditingController(); // Controller to manage input field

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.viewGoals),
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
          final activeGoals = goals
              .where((g) => g['status'] == 'active')
              .toList()
              .where((goal) => goal['goal']
                  .toString()
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
              .toList(); // Filtered based on search query
          final completedGoals =
              goals.where((g) => g['status'] == 'completed').toList();

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  _buildSearchField(), // Add search field
                  SizedBox(height: 10),
                  _buildGoalSection(AppLocalizations.of(context)!.activeGoals, activeGoals),
                  Divider(),
                  _buildGoalSection(AppLocalizations.of(context)!.completedGoals, completedGoals),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController, // Keep track of the input value
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.searchGoal,
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.search),
      ),
      onChanged: (value) {
        setState(() {
          _searchQuery = value; // Update search query dynamically
        });
      },
    );
  }

  Widget _buildGoalSection(String title, List<QueryDocumentSnapshot> goals) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(), // Disable internal scrolling
          itemCount: goals.length,
          itemBuilder: (context, index) {
            var goal = goals[index];
            return ListTile(
              title: Text(goal['goal']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (goal['status'] == 'active') ...[
                    IconButton(
                      icon: Icon(Icons.check, color: Colors.green),
                      onPressed: () {
                        goal.reference.update({'status': 'completed'});
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.remove_circle_outline, color: Colors.red),
                      onPressed: () {
                        goal.reference.delete();
                      },
                    ),
                  ] else
                    Icon(Icons.check, color: Colors.green),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose(); // Dispose of the controller when the screen is closed
    super.dispose();
  }
}
