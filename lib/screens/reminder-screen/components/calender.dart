import 'package:capsule/models/reminder.dart';
import 'package:capsule/providers/medicineReminderProvider.dart';
import 'package:capsule/screens/components/curved-container.dart';
import 'package:capsule/screens/reminder-screen/components/reminderListItem.dart';
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
              formatButtonTextStyle: TextStyle(color: Colors.black),
              formatButtonDecoration: BoxDecoration(
                border: Border.fromBorderSide(BorderSide(color: Colors.black)),
                borderRadius: BorderRadius.circular(12),
              ),
              titleTextStyle: TextStyle(color: Colors.black),
              rightChevronIcon: Icon(Icons.chevron_right, color: Colors.black),
              leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black),
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
              todayTextStyle: TextStyle(color: Colors.black),
              selectedTextStyle: TextStyle(color: Colors.black),
              defaultTextStyle: TextStyle(color: Colors.black),
              weekendTextStyle: TextStyle(color: Colors.black),
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
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF9EC9FF).withOpacity(0.4),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.notifications_off_outlined,
                          size: 42,
                          color: Color(0xFF3F8CFF),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'لا يوجد تنبيهات',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: const Color(0xFF1B3558),
                              fontWeight: FontWeight.w600,
                            ),
                      ),
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
