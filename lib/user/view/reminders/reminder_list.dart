import 'package:flutter/material.dart';
import 'package:plantaera/res/colors.dart';
import 'package:plantaera/user/view/reminders/new_reminder.dart';

class ReminderList extends StatefulWidget {
  const ReminderList({Key? key}) : super(key: key);

  @override
  State<ReminderList> createState() => _ReminderListState();
}

class _ReminderListState extends State<ReminderList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        "Reminder List",
                        style: TextStyle(
                          fontSize: 30,
                          color: darkGreen,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NewReminder())).then((_) => setState((){}));
          },
          foregroundColor: grass,
          backgroundColor: grass,
          child: const Icon(Icons.add, color: Colors.white, size: 45,),
        ),
      ),
    );
  }
}
