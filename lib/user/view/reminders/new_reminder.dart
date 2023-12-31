//reference time picker: https://www.dhiwise.com/post/craft-amazing-user-experiences-with-flutter-time-picker
//notification ref: https://www.youtube.com/watch?v=bRy5dmts3X8

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plantaera/main.dart';
import 'package:plantaera/res/colors.dart';
import 'package:plantaera/user/model/reminder_model.dart';
import 'package:plantaera/user/view_model/notification_viewmodel.dart';
import 'package:plantaera/helper/object_box.dart';

class NewReminder extends StatefulWidget {
  const NewReminder({Key? key}) : super(key: key);

  @override
  State<NewReminder> createState() => _NewReminderState();
}

class _NewReminderState extends State<NewReminder> {
  final newReminderFormKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  String? _typeController;
  TimeOfDay? pickedTime;

  String newReminderStatusText = '';
  String timeText = 'Pick a time for reminder';
  bool _loading = false;
  String typeText = 'Pick a reminder type';
  String tempHour = '';
  String tempMinute = '';
  String dayOrNight = '';


  timePicker() async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext? context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context!).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );
    if (time != null) {
      pickedTime = time;
      tempHour = time.hour.toString();
      tempMinute = time.minute.toString();

      //change to int for comparing
      int intTempHour = int.parse(tempHour);
      int intTempMinute = int.parse(tempMinute);

      if (intTempHour > 12) {
        dayOrNight = 'P.M.'; //set to night
        intTempHour = intTempHour - 12; //minus 12 hours
        tempHour = intTempHour.toString(); //change to string fr display
      } else {
        dayOrNight = 'A.M.';
      }
      if(intTempMinute < 10){
        tempMinute = "0${tempMinute}";
      }

      setState(() {
        timeText = "$tempHour : $tempMinute $dayOrNight";
      });
    }
  }

  hintTextColor(hint) {
    //for changing hint color
    if (hint != "Pick a time for reminder" && hint != "Pick a reminder type") {
      return Colors.black;
    } else {
      return lightgrey;
    }
  }

  int notificationIdGenerator() {
    int idGenerator = Random().nextInt(100000);

    return idGenerator;
  }

  handleSubmit() async{
    if(newReminderFormKey.currentState!.validate() && pickedTime != null){
      String title = _titleController.value.text;
      int notificationId = notificationIdGenerator();

      await NotificationVM.scheduleNotification(notificationId, title, title, pickedTime!);

      final reminder = Reminder(
        id: notificationId,
        reminderTitle: title,
        reminderHour: tempHour,
        reminderMinutes: tempMinute,
        reminderDayOrNight: dayOrNight,
      );
      await objectBox.newReminder(reminder); //insert reminder into objectBox db

      Fluttertoast.showToast(
        msg: "Added new reminder.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      Navigator.pop(context);

    }else if(pickedTime == null){
      newReminderStatusText = 'Please select a time!';
    }
    else{
      newReminderStatusText = "Please insert all fields!";
    }

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: null,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: darkGreen,
              size: 35,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Form(
                  key: newReminderFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          "New Reminder",
                          style: TextStyle(
                            fontSize: 30,
                            color: darkGreen,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        height: 30,
                      ),

                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Title: ",
                            style: TextStyle(
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 300,
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          controller: _titleController,
                          enableSuggestions: false,
                          autocorrect: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the title for reminder';
                            }
                            return null;
                          },
                          style: TextStyle(
                            fontSize: 17,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Enter title for reminder",
                            hintStyle: const TextStyle(
                              fontSize: 17,
                              color: lightgrey,
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: darkGreen,
                                width: 1.0,
                                style: BorderStyle.none,
                              ),
                              borderRadius: BorderRadius.circular(7.0),
                            ),
                          ),
                        ),
                      ), //reminder title textfield
                      SizedBox(
                        height: 30,
                      ), //spacing

                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Select Time: ",
                            style: TextStyle(
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          timePicker();
                        },
                        child: Container(
                          width: 300,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 1.0,
                              color: darkGreen,
                            ),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Center(
                            child: Text(
                              timeText,
                              style: TextStyle(
                                  color: hintTextColor(timeText), fontSize: 17),
                            ),
                          ),
                        ),
                      ), //reminder time textfield
                      SizedBox(
                        height: 30,
                      ), //spacing

                      /*Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Select Type: ",
                            style: TextStyle(
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        //text field for gender
                        padding: const EdgeInsets.fromLTRB(10, 7, 10, 8),
                        width: 300,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            width: 1.0,
                            color: darkGreen,
                          ),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: DropdownButton(
                          hint: Center(
                            child: Text(
                              typeText,
                              style: TextStyle(
                                  fontSize: 17, color: hintTextColor(typeText)),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          value: _typeController,
                          isExpanded: true,
                          items: ["Notification", "Alarm"]
                              .map(
                                (v) => DropdownMenuItem(
                                  value: v,
                                  child: Center(child: Text(v)),
                                ),
                              )
                              .toList(),
                          onChanged: (v) {
                            _typeController = v!;
                            setState(() {});
                          },
                        ),
                      ), //text field notification type

                      SizedBox(
                        height: 30,
                      ),*/

                      Text(
                        newReminderStatusText,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: 250,
                        height: 50,
                        child: ElevatedButton(
                          //sign in button
                          onPressed: () {
                            handleSubmit();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: grass,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                            shadowColor: Colors.grey.withOpacity(0.9),
                          ),
                          child: Center(
                            child: _loading
                                ? const SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: CircularProgressIndicator(
                                      color: pastelGreen,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    "Create Reminder",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                          ),
                        ),
                      ), //change username button
                      SizedBox(
                        height: 15,
                      ), //logout button
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
