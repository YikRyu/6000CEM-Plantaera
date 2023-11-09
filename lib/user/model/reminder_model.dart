import 'package:objectbox/objectbox.dart';

@Entity()
class Reminder{
  @Id(assignable: true)
  int id;

  String? reminderTitle;
  String? reminderHour;
  String? reminderMinutes;
  String? reminderDayOrNight;

  Reminder({
    required this.id,
    required this.reminderTitle,
    required this.reminderHour,
    required this.reminderMinutes,
    required this.reminderDayOrNight,
  });
}