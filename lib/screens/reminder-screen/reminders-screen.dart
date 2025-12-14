import 'package:capsule/providers/medicineReminderProvider.dart';
import 'package:capsule/screens/reminder-screen/addReminderScreen/addReminderScreen.dart';
import 'package:capsule/screens/reminder-screen/components/calender.dart';
import 'package:capsule/screens/reminder-screen/components/delete-all-reminders-dialog.dart';
import 'package:capsule/screens/reminder-screen/components/no-medicine-dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RemindersScreen extends StatefulWidget {
  static const route = '/reminders';

  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 168, 213, 252),
      appBar: AppBar(
        title: Text(
          'التنبيهات',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: const Color(0xFF1B3558),
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 168, 213, 252),
        iconTheme: IconThemeData(
          color: const Color(0xFF1B3558), // لون أيقونة العودة
        ),
        actions: [
          MenuAnchor(
            menuChildren: [
              MenuItemButton(
                leadingIcon: Icon(
                  Icons.delete,
                  color: const Color(0xFF1B3558), // لون الأيقونة
                ),
                child: Text('ازالة جميع التنبيهات'),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => DeleteAllRemindersDialog(),
                  );
                },
              ),
            ],
            builder: (_, controller, __) => IconButton(
              onPressed: () {
                if (controller.isOpen) {
                  controller.close();
                } else {
                  controller.open();
                }
              },
              icon: Icon(
                Icons.more_vert,
                color: const Color(0xFF1B3558), // لون الأيقونة
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            // colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB), Color(0xFFE1F5FE)],
            colors: [
              Color.fromARGB(255, 168, 213, 252), // أغمق قليلًا
              Color.fromARGB(255, 163, 208, 253),
              Color.fromARGB(255, 194, 220, 238),
            ],
          ),
        ),
        child: Calender(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (Provider.of<MedicineReminderProvider>(
            context,
            listen: false,
          ).medicines.isNotEmpty) {
            Navigator.pushNamed(context, AddReminderScreen.route);
          } else {
            showDialog(context: context, builder: (_) => NoMedicineDialog());
          }
        },

        label: Text(
          'أضف منبها',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: const Color(0xFF1B3558),
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 168, 213, 252),
        icon: Icon(Icons.timer_outlined, color: const Color(0xFF1B3558)),
      ),
    );
  }
}
