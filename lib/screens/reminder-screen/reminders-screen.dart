import 'package:Capsule/providers/medicineReminderProvider.dart';
import 'package:Capsule/screens/reminder-screen/addReminderScreen/addReminderScreen.dart';
import 'package:Capsule/screens/reminder-screen/components/calender.dart';
import 'package:Capsule/screens/reminder-screen/components/delete-all-reminders-dialog.dart';
import 'package:Capsule/screens/reminder-screen/components/no-medicine-dialog.dart';
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
      backgroundColor: Colors.cyan,
      appBar: AppBar(
        title: Text('التنبيهات'),
        actions: [
          MenuAnchor(
            menuChildren: [
              MenuItemButton(
                leadingIcon: Icon(Icons.delete),
                child: Text('ازالة جميع التنبيهات'),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => DeleteAllRemindersDialog(),
                  );
                },
              ),
            ],
            builder: (_, controller, _) => IconButton(
              onPressed: () {
                if (controller.isOpen) {
                  controller.close();
                } else {
                  controller.open();
                }
              },
              icon: Icon(Icons.more_vert),
            ),
          ),
        ],
      ),
      body: Calender(),
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
        backgroundColor: Colors.cyan,
        label: Text('أضف منبها'),
        icon: Icon(Icons.timer_outlined),
      ),
    );
  }
}
