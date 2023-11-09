import 'package:plantaera/objectbox.g.dart';
import 'package:plantaera/user/model/reminder_model.dart';


//a class for catering objectBox related functions
class ObjectBox{
  late final Store _store;
  late final Box<Reminder> _reminderBox;

  ObjectBox._init(this._store){
    _reminderBox = Box<Reminder>(_store);
  }

  static Future<ObjectBox> init() async{
    final store = await openStore();

    return ObjectBox._init(store);
  }

  //fetch one reminder
  Reminder? getReminder(int id) => _reminderBox.get(id);

  Stream<List<Reminder>> getReminders() => _reminderBox
      .query()
      .watch(triggerImmediately: true)
      .map((query) => query.find());

  //fetch all reminder
  int newReminder(Reminder reminder) => _reminderBox.put(reminder);

  bool deleteReminder(int id) => _reminderBox.remove(id);

}
