import 'package:capsule/providers/medicineReminderProvider.dart';
import 'package:capsule/screens/reminder-screen/components/reminderListItem.dart';
import 'package:capsule/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ==================== ServiceNavigationCard ====================
class ServiceNavigationCard extends StatelessWidget {
  final String route;
  final String title;
  final IconData icon;
  final String description;
  final Color color;

  const ServiceNavigationCard({
    super.key,
    required this.route,
    required this.title,
    required this.icon,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shadowColor: color.withOpacity(0.25),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.2), width: 1),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, color.withOpacity(0.05)],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: MyColors.darkNavyBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: MyColors.mediumGray),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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

// ==================== TodayScheduleWidget ====================
class TodayScheduleWidget extends StatefulWidget {
  const TodayScheduleWidget({super.key});

  @override
  State<TodayScheduleWidget> createState() => _TodayScheduleWidgetState();
}

class _TodayScheduleWidgetState extends State<TodayScheduleWidget> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MedicineReminderProvider>(context, listen: false).fetchData();
    });
    super.initState();
  }

  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "جدول اليوم",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: MyColors.darkNavyBlue,
              fontWeight: FontWeight.w700,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Consumer<MedicineReminderProvider>(
              builder: (_, provider, __) {
                if (provider.kEvents.isEmpty) {
                  return _buildEmptyState(context);
                }
                return Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  thickness: 6,
                  radius: const Radius.circular(3),
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(8),
                    itemCount: provider.kEvents[DateTime.now()]?.length ?? 0,
                    itemBuilder: (_, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ReminderListItem(
                        provider.kEvents[DateTime.now()]![index],
                      ),
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

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: MyColors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: MyColors.primaryBlue.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              size: 48,
              color: MyColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد تنبيهات اليوم',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: MyColors.darkNavyBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'جدولك خالي اليوم',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: MyColors.mediumGray),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
