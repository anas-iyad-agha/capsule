import 'package:Capsule/providers/medicineReminderProvider.dart';
import 'package:Capsule/screens/reminder-screen/components/reminderListItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TodaySchedule extends StatefulWidget {
  const TodaySchedule({super.key});

  @override
  State<TodaySchedule> createState() => _TodayScheduleState();
}

class _TodayScheduleState extends State<TodaySchedule> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MedicineReminderProvider>(context, listen: false).fetchData();
    });
    super.initState();
  }

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("جدول اليوم", style: Theme.of(context).textTheme.titleLarge),
          Expanded(
            child: Consumer<MedicineReminderProvider>(
              builder: (_, provider, _) {
                if (provider.kEvents.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.notifications_off_outlined),
                        Text('لا يوجد تنبيهات'),
                      ],
                    ),
                  );
                }
                return Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(8),
                    shrinkWrap: true,
                    itemCount: provider.kEvents[DateTime.now()]?.length ?? 0,
                    itemBuilder: (_, index) => ReminderListItem(
                      provider.kEvents[DateTime.now()]![index],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
