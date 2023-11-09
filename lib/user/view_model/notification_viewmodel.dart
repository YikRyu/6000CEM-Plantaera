//notification ref: https://www.youtube.com/watch?v=bRy5dmts3X8
//scheduled notif ref: https://pub.dev/packages/flutter_local_notifications#displaying-a-notification
//notification ref: https://www.youtube.com/watch?v=iKxrt4ASR5Y&t=251s


import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationVM{
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future _notificationDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'Planatera Reminder Alarm Notification',
        'Plantaera Reminder Alarm Notification',
        icon: 'plantaera_logo',
        importance: Importance.max,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('mixkit_flute_cell_phone_alert_2315'),
        largeIcon: DrawableResourceAndroidBitmap('plantaera_logo'),
      ),
    );
  }

  //initialize timezone for scheduling notif
  static Future init({bool initScheduled = true})async{
// initialise the flutter local notification plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('plantaera_logo');
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);

    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
    AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();


    if(initScheduled){
      tz.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation('Asia/Kuala_Lumpur'));
    }
  }


  static Future scheduleNotification(
    int id,
    String title,
    String payload,
      TimeOfDay pickedTime,
  ) async => flutterLocalNotificationsPlugin.zonedSchedule(
      id,
    title,
    "Reminder to take care of your plants! ",
    _scheduleDaily(pickedTime),
    await _notificationDetails(),
    payload: payload,
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.time,
  );

  static tz.TZDateTime _scheduleDaily(TimeOfDay time){
    final now = tz.TZDateTime.now(tz.local);
    final scheduledTime = tz.TZDateTime(tz.local, now.year, now.month, now.day,
        time.hour, time.minute);

    return scheduledTime.isBefore(now)
        ? scheduledTime.add(Duration(days: 1))
        : scheduledTime;
  }

}

void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
  final String? payload = notificationResponse.payload;
  if (notificationResponse.payload != null) {
    debugPrint('notification payload: $payload');
  }
}