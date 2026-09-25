import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Auto-generated file


class RoutineScreen extends StatefulWidget {
  @override
  _RoutineScreenState createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen> {
  final TextEditingController _goalController = TextEditingController();
  String _selectedDay = _getDayName(); // Default to the current day

  static String _getDayName() {
    return [
      "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
    ][DateTime.now().weekday % 7];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.routineGoals),
      ),
      body: Column(
        children: [
          // Day Selection and Add Goal Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Goals for $_selectedDay',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _goalController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.addGoal,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _addGoal,
                      child: Text(AppLocalizations.of(context)!.addGoal),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Dropdown for Day Selection
                Row(
                  children: [
                    Text(
                      'Select Day:',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(width: 10),
                    DropdownButton<String>(
                      value: _selectedDay,
                      items: [
                        'Sunday',
                        'Monday',
                        'Tuesday',
                        'Wednesday',
                        'Thursday',
                        'Friday',
                        'Saturday'
                      ].map((day) {
                        return DropdownMenuItem(
                          value: day,
                          child: Text(day),
                        );
                      }).toList(),
                      onChanged: (newDay) {
                        setState(() {
                          _selectedDay = newDay!;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('routine_goals')
                  .doc(_selectedDay)
                  .collection('goals')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final goals = snapshot.data!.docs;

                if (goals.isEmpty) {
                  return Center(child: Text('No goals for $_selectedDay.'));
                }

                return ListView.builder(
                  itemCount: goals.length,
                  itemBuilder: (context, index) {
                    var goal = goals[index];
                    return ListTile(
                      title: Text(
                        goal['goal'],
                        style: TextStyle(
                          decoration: goal['completed']
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              goal['completed']
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              color: Colors.green,
                            ),
                            onPressed: () {
                              _toggleGoalCompletion(goal);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _removeGoal(goal);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _addGoal() async {
    String goal = _goalController.text.trim();
    if (goal.isEmpty) return;

    // Add goal to Firestore for the selected day
    await FirebaseFirestore.instance
        .collection('routine_goals')
        .doc(_selectedDay)
        .collection('goals')
        .add({'goal': goal, 'completed': false});

    _goalController.clear();
  }

  void _removeGoal(QueryDocumentSnapshot goal) async {
    await goal.reference.delete();
  }

  void _toggleGoalCompletion(QueryDocumentSnapshot goal) async {
    await goal.reference.update({'completed': !goal['completed']});
  }
}
