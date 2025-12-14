import 'dart:async';
import 'dart:convert';

import 'package:capsule/models/medicine.dart';
import 'package:capsule/models/reminder.dart';
import 'package:capsule/providers/medicineReminderProvider.dart';
import 'package:alarm/alarm.dart';
import 'package:alarm/utils/alarm_set.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen(this.alarmSettings, {super.key});

  final AlarmSettings alarmSettings;

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  StreamSubscription<AlarmSet>? _ringingSubscription;
  late Medicine medicine;
  late Reminder reminder;

  @override
  void initState() {
    super.initState();
    var payload = JsonDecoder().convert(widget.alarmSettings.payload!);
    medicine = Medicine.fromJson(payload['medicine']);
    reminder = Reminder.fromJson(payload['reminder']);
    _ringingSubscription = Alarm.ringing.listen((alarms) {
      if (alarms.containsId(widget.alarmSettings.id)) return;
      _ringingSubscription?.cancel();
      if (mounted) Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    _ringingSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: Color(0xffF6F8F6),
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'حان موعد دوائك!',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Card(
                child: Container(
                  height: height / 3,
                  width: width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(8),
                          color: Colors.cyan.withAlpha(60),
                          width: width,
                          alignment: Alignment.center,
                          child: FaIcon(
                            FontAwesomeIcons.pills,
                            size: 100,
                            color: Colors.cyan,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              medicine.name,
                              style: Theme.of(context).textTheme.titleLarge!
                                  .copyWith(color: Color(0xff475569)),
                            ),
                            Text(
                              '${medicine.strength}ميلي جرام, ${medicine.dose} حبة',
                              style: Theme.of(context).textTheme.titleMedium!
                                  .copyWith(color: Color(0xff475569)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RawMaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    onPressed: () async {
                      Alarm.stop(widget.alarmSettings.id);
                      Provider.of<MedicineReminderProvider>(
                        context,
                        listen: false,
                      ).setIsTaken(reminder.isTaken, reminder.id!);
                    },
                    fillColor: Colors.cyan,
                    padding: EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.ideographic,
                      children: [
                        Icon(Icons.check_circle_outline, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'أخذ الدواء',
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge!.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  RawMaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.all(8),
                    fillColor: Color(0xffE2E8F0),
                    onPressed: () async => Alarm.set(
                      alarmSettings: widget.alarmSettings.copyWith(
                        dateTime: DateTime.now().add(
                          const Duration(minutes: 5),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.ideographic,
                      children: [
                        Icon(Icons.timer_outlined),
                        SizedBox(width: 8),
                        Text(
                          'التذكير بعد 5 دقائق',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  RawMaterialButton(
                    onPressed: () async => Alarm.stop(widget.alarmSettings.id),
                    child: Text(
                      'ايقاف',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Color(0xff475569),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
