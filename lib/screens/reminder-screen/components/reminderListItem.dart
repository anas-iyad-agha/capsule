import 'package:Capsule/models/reminder.dart';
import 'package:Capsule/providers/medicineReminderProvider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ReminderListItem extends StatelessWidget {
  final Reminder reminder;
  const ReminderListItem(this.reminder, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ListTile(
          leading: Column(
            children: [
              Text(
                DateFormat.jm('ar').format(reminder.dateTime),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              reminder.dateTime.isAfter(DateTime.now())
                  ? Icon(Icons.timer_outlined, color: Colors.teal)
                  : reminder.isTaken
                  ? Icon(Icons.check_circle_outline, color: Colors.green)
                  : Icon(Icons.close, color: Colors.redAccent),
            ],
          ),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(reminder.medicineName, overflow: TextOverflow.ellipsis),
              reminder.label == null
                  ? const SizedBox.shrink()
                  : Text(
                      reminder.label!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ],
          ),
          trailing: MenuAnchor(
            menuChildren: [
              DateTime.now().isAfter(reminder.dateTime)
                  ? MenuItemButton(
                      leadingIcon: Icon(Icons.check),
                      child: Text("تم"),
                      onPressed: () {
                        Provider.of<MedicineReminderProvider>(
                          context,
                          listen: false,
                        ).setIsTaken(reminder.isTaken, reminder.id!);
                      },
                    )
                  : SizedBox(),
              MenuItemButton(
                leadingIcon: Icon(Icons.delete),
                child: Text("حذف"),
                onPressed: () {
                  Provider.of<MedicineReminderProvider>(
                    context,
                    listen: false,
                  ).deleteReminder(reminder.id!);
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
        ),
      ),
    );
  }
}
