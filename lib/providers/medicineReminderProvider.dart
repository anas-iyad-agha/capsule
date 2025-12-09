import 'dart:collection';
import 'dart:convert';

import 'package:Capsule/local-db/localDB.dart';
import 'package:Capsule/models/medicine.dart';
import 'package:Capsule/models/reminder.dart';
import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:table_calendar/table_calendar.dart';

enum MedicineReminderState { initial, loading, loaded, error }

class MedicineReminderProvider with ChangeNotifier {
  List<Medicine> medicines = [];
  List<Reminder> reminders = [];

  LinkedHashMap<DateTime, List<Reminder>> kEvents =
      LinkedHashMap<DateTime, List<Reminder>>(
        equals: isSameDay,
        hashCode: (DateTime key) =>
            key.day * 1000000 + key.month * 10000 + key.year,
      );

  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  List<Reminder> selectedDayEvents = [];

  MedicineReminderState state = MedicineReminderState.initial;

  Future<void> fetchData() async {
    state = MedicineReminderState.loading;
    notifyListeners();

    try {
      await Localdb.db!.transaction((txn) async {
        var medicinesData = await txn.query('medicine');
        var remindersData = await txn.query('reminders');

        medicines = medicinesData
            .map((medicine) => Medicine.fromJson(medicine))
            .toList();

        print('medicines :: $medicinesData');

        reminders = remindersData
            .map((reminder) => Reminder.fromJson(reminder))
            .toList();
      });

      Map<DateTime, List<Reminder>> kEventSource = {
        for (var reminder in reminders)
          reminder.dateTime: reminders
              .where(
                (element) => isSameDay(element.dateTime, reminder.dateTime),
              )
              .toList(),
      };

      kEvents.clear();
      kEvents.addAll(kEventSource);

      selectedDayEvents = getEventsForDay(selectedDay);

      state = MedicineReminderState.loaded;
    } catch (e) {
      print(e.toString());
      state = MedicineReminderState.error;
    }
    notifyListeners();
  }

  Future searchMedicine(String name) async {
    var medicinesData = await Localdb.db!.query(
      'medicine',
      where: "name LIKE '%$name%'",
    );
    medicines = medicinesData
        .map((medicine) => Medicine.fromJson(medicine))
        .toList();
    notifyListeners();
  }

  Future insertMedicine(
    String name,
    String description,
    double dose,
    double strength,
    DateTime startDate,
    DateTime endDate,
  ) async {
    state = MedicineReminderState.loading;
    notifyListeners();

    // try {
    await Localdb.db!.insert('medicine', {
      'name': name,
      'description': description,
      'dose': dose,
      'strength': strength,
      'start_date': startDate.toString(),
      'end_date': endDate.toString(),
    });

    state = MedicineReminderState.loaded;
    // } catch (e) {
    state = MedicineReminderState.error;
    // }
    notifyListeners();
  }

  Future updateMedicine(Medicine medicine) async {
    state = MedicineReminderState.loading;
    notifyListeners();

    await Localdb.db!.transaction((txn) async {
      int effectedRows = await txn.update(
        'medicine',
        medicine.toJson(),
        where: 'id = ${medicine.id}',
      );

      if (effectedRows != 1) {
        throw Exception(
          'error when update medicine table value : ${medicine.toString()} effected rows : $effectedRows',
        );
      }
      await txn.update('reminders', {
        'medicine_name': medicine.name,
      }, where: 'medicine_id = ${medicine.id}');

      medicines.removeWhere((element) => element.id == medicine.id);
      medicines.add(medicine);
    });

    state = MedicineReminderState.loaded;
    notifyListeners();
  }

  Future deleteMedicine(int medicineId) async {
    int effectedMedicine = await Localdb.db!.delete(
      'medicine',
      where: 'id = $medicineId',
    );

    reminders.forEach((reminder) {
      if (reminder.medicineId == medicineId) {
        Alarm.stop(reminder.id!);
      }
    });

    await Localdb.db!.delete('reminders', where: 'medicine_id = $medicineId');

    if (effectedMedicine != 1) {
      throw Exception(
        'ERROR when deleting from data base table :: medicine, id = $medicineId, effected rows:: $effectedMedicine',
      );
    }
    medicines.removeWhere((medicine) => medicine.id == medicineId);
    notifyListeners();
  }

  List<Reminder> getEventsForDay(DateTime day) {
    return kEvents[day] ?? [];
  }

  onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(this.selectedDay, selectedDay)) {
      this.selectedDay = selectedDay;
      this.focusedDay = focusedDay;

      selectedDayEvents = getEventsForDay(selectedDay);
      notifyListeners();
    }
  }

  Future removeAllReminders() async {
    await Localdb.db!.delete('reminders');
    await Alarm.stopAll();
    reminders.clear();
    kEvents.clear();
    selectedDayEvents.clear();
    notifyListeners();
  }

  Future registerReminders(
    String label,
    Medicine medicine,
    TimeOfDay time,
    DateTimeRange dateRange,
    int repeat,
    int hourlyRepeat,
  ) async {
    if (TimeOfDay.now().isAfter(time)) {
      dateRange.start.add(Duration(days: 1));
    }
    List<DateTime> dates = [
      for (int i = 0; i < dateRange.duration.inDays; i += repeat)
        for (int j = time.hour; j < 24; j += hourlyRepeat)
          DateTime(
            dateRange.start.year,
            dateRange.start.month,
            dateRange.start.day,
            j,
            time.minute,
          ).add(Duration(days: i)),
    ];
    List<Reminder> reminders = [];
    await Localdb.db!.transaction((txn) async {
      Batch batch = txn.batch();
      for (DateTime date in dates) {
        Reminder reminder = Reminder(
          medicineId: medicine.id!,
          medicineName: medicine.name,
          label: label,
          dateTime: date,
          isTaken: false,
        );
        batch.insert('reminders', reminder.toJson());
        reminders.add(reminder);
      }

      var remindersIds = await batch.commit();
      for (int i = 0; i < remindersIds.length; i++) {
        reminders[i].id = remindersIds[i] as int;
        await Alarm.set(
          alarmSettings: AlarmSettings(
            id: remindersIds[i] as int,
            dateTime: dates[i],
            payload: JsonEncoder().convert({
              'reminder': reminders[i].toJson(),
              'medicine': medicine.toJson(),
            }),
            assetAudioPath: 'assets/audio/marimba.mp3',
            volumeSettings: VolumeSettings.fixed(),
            notificationSettings: NotificationSettings(
              title: 'منبه الدواء',
              body: '${medicine.name}, ${medicine.dose} حبة/جرعة',
              stopButton: 'ايقاف',
            ),
          ),
        );
      }
    });
  }

  Future deleteReminder(int reminderId) async {
    int effectedRow = await Localdb.db!.delete(
      'reminders',
      where: 'id = $reminderId',
    );
    if (effectedRow != 1) {
      throw Exception(
        'Error when deleting Rminder Id = $reminderId the effected Rows where $effectedRow',
      );
    }
    Alarm.stop(reminderId);
    await fetchData();
  }

  Future setIsTaken(bool isTaken, int reminderId) async {
    print('isTaken :: $isTaken');
    int effectedRow = await Localdb.db!.update('reminders', {
      'is_taken': isTaken ? 0 : 1,
    }, where: 'id = $reminderId');
    if (effectedRow != 1) {
      throw Exception(
        'Error when deleting Rminder Id = $reminderId the effected Rows where $effectedRow',
      );
    }
    await fetchData();
  }
}
