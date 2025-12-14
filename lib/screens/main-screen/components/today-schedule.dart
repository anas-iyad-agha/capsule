import 'package:capsule/providers/medicineReminderProvider.dart';
import 'package:capsule/screens/reminder-screen/components/reminderListItem.dart';
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
      padding: const EdgeInsets.only(top: 32, left: 8, right: 8, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "جدول اليوم",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: const Color(0xFF1B3558),
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Consumer<MedicineReminderProvider>(
              builder: (_, provider, _) {
                if (provider.kEvents.isEmpty) {
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
                          'لا يوجد تنبيهات اليوم',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: const Color(0xFF1B3558),
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'سيتم عرض التنبيهات هنا عند إضافتها',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: const Color(0xFF566E8A)),
                          textAlign: TextAlign.center,
                        ),
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
