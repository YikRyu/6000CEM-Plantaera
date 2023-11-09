//notif remove ref: https://pub.dev/packages/flutter_local_notifications#scheduled-notifications-and-daylight-saving-time
//object box ref: https://www.youtube.com/watch?v=BBlr8F8m9lo

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plantaera/main.dart';
import 'package:plantaera/res/colors.dart';
import 'package:plantaera/user/view/reminders/new_reminder.dart';
import 'package:plantaera/user/model/reminder_model.dart';

class ReminderList extends StatefulWidget {
  const ReminderList({Key? key}) : super(key: key);

  @override
  State<ReminderList> createState() => _ReminderListState();
}

class _ReminderListState extends State<ReminderList> {
  late Stream<List<Reminder>> streamReminders;

  @override
  void initState() {
    super.initState();
    streamReminders = objectBox.getReminders();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: SafeArea(
          child: Column(
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
              StreamBuilder(
                  stream: streamReminders,
                  builder: (context, snapshots) {
                    if (!snapshots.hasData) {
                      return Container(
                        child: Center(
                          child: Text(
                            "There is no reminder set for now.",
                            style: TextStyle(
                              fontSize: 25,
                              color: darkGreen,
                            ),
                          ),
                        ),
                      );
                    } else {
                      final reminders = snapshots.data;

                      return Expanded(
                        child: ListView.builder(
                            itemCount: reminders!.length,
                            itemBuilder: (context, index) {
                              final reminderModel = reminders[index];
                              int reminderId = reminderModel.id;

                              return Center(
                                child: Container(
                                  width: 320,
                                  height: 80,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(reminderModel.reminderTitle!, style: TextStyle(fontSize: 18, color: Colors.black),),
                                              Text("${reminderModel.reminderHour} : ${reminderModel.reminderMinutes} ${reminderModel.reminderDayOrNight}" ,style: TextStyle(fontSize: 15, color: darkgrey,),),
                                            ],
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              await objectBox.deleteReminder(reminderId);
                                              await flutterLocalNotificationsPlugin.cancel(reminderId);
                                              setState(() {
                                                Fluttertoast.showToast(
                                                  msg: "Reminder deleted...",
                                                  toastLength: Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                );
                                              });
                                            },
                                            child: Icon(Icons.delete, size: 30, color: darkGreen,),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      );
                    }
                  }),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => NewReminder())).then((_) => setState(() {}));
          },
          foregroundColor: grass,
          backgroundColor: grass,
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 45,
          ),
        ),
      ),
    );
  }
}
