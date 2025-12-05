import 'package:Capsule/models/reminder.dart';
import 'package:Capsule/providers/medicineReminderProvider.dart';
import 'package:Capsule/screens/components/curved-container.dart';
import 'package:Capsule/screens/reminder-screen/components/reminderListItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class Calender extends StatefulWidget {
  const Calender({super.key});

  @override
  State<Calender> createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  CalendarFormat _calendarFormat = CalendarFormat.week;

  @override
  initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var provider = Provider.of<MedicineReminderProvider>(
        context,
        listen: false,
      );
      await provider.fetchData();
      provider.onDaySelected(provider.selectedDay, provider.focusedDay);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer<MedicineReminderProvider>(
          builder: (_, provider, _) => TableCalendar<Reminder>(
            locale: 'ar',
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2050, 12, 31),
            focusedDay: provider.focusedDay,
            selectedDayPredicate: (day) => isSameDay(provider.selectedDay, day),
            calendarFormat: _calendarFormat,
            availableCalendarFormats: {
              CalendarFormat.month: 'شهر',
              CalendarFormat.week: 'أسبوع',
            },
            eventLoader: provider.getEventsForDay,
            headerStyle: HeaderStyle(
              formatButtonTextStyle: TextStyle(color: Colors.white),
              formatButtonDecoration: BoxDecoration(
                border: Border.fromBorderSide(BorderSide(color: Colors.white)),
                borderRadius: BorderRadius.circular(12),
              ),
              titleTextStyle: TextStyle(color: Colors.white),
              rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
              leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
            ),
            calendarStyle: const CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: Colors.cyanAccent,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.lightBlueAccent,
                shape: BoxShape.circle,
              ),
              todayTextStyle: TextStyle(color: Colors.white),
              selectedTextStyle: TextStyle(color: Colors.black),
              defaultTextStyle: TextStyle(color: Colors.white),
              weekendTextStyle: TextStyle(color: Colors.white),
            ),
            onDaySelected: provider.onDaySelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              provider.focusedDay = focusedDay;
            },
          ),
        ),
        const SizedBox(height: 8.0),
        CurvedContainer(
          Consumer<MedicineReminderProvider>(
            builder: (_, provider, _) {
              if (provider.selectedDayEvents.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.notifications_off_outlined),
                      Text('لايوجد تنبيعا'),
                    ],
                  ),
                );
              }
              return ListView.builder(
                itemCount: provider.selectedDayEvents.length,
                itemBuilder: (_, index) {
                  return ReminderListItem(provider.selectedDayEvents[index]);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
