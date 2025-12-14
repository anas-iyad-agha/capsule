import 'package:capsule/models/medicine.dart';
import 'package:capsule/screens/clinical-file-screen/medicine/components/delete-medicine-dialog.dart';
import 'package:capsule/screens/clinical-file-screen/medicine/edit-medicine-screen/edit-medicine-screen.dart';
import 'package:capsule/screens/clinical-file-screen/medicine/view-medicine-screen/components/info-card.dart';
import 'package:capsule/screens/components/curved-container.dart';
import 'package:capsule/theme.dart';
import 'package:flutter/material.dart';

class ViewMedicineScreen extends StatelessWidget {
  final Medicine medicine;
  const ViewMedicineScreen(this.medicine, {super.key});

  String formatDouble(double value) {
    if (value % 1 == 0) {
      // It's an integer value (e.g., 5.0), return as int string.
      return value.toInt().toString();
    } else {
      // It has a decimal part (e.g., 5.2), return as double string.
      return value.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        title: Text(medicine.name),
        actions: [
          MenuAnchor(
            menuChildren: [
              MenuItemButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditMedicineScreen(medicine),
                    ),
                  );
                },
                leadingIcon: Icon(Icons.edit),
                child: Text('تعديل'),
              ),
              MenuItemButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => DeleteMedicineDialog(medicine),
                  );
                },
                leadingIcon: Icon(Icons.delete),
                child: Text('حذف'),
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
      body: Column(
        children: [
          CurvedContainer(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: width / 2,
                    height: width / 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          MyColors.accentTeal.withOpacity(0.2),
                          MyColors.accentTeal.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: MyColors.accentTeal.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      Icons.medication_rounded,
                      color: MyColors.accentTeal,
                      size: width / 3,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                  child: Text(
                    medicine.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 0, 24),
                  child: Text(
                    medicine.description,
                    softWrap: true,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InfoCard(
                              title: 'الجرعة',
                              info: '${formatDouble(medicine.dose)} حبة/جرعة',
                              color: MyColors.lightRed,
                              iconData: Icons.timelapse,
                            ),
                            InfoCard(
                              title: 'العيار',
                              info:
                                  '${formatDouble(medicine.strength)} ميلي جرام',
                              color: Colors.purple,
                              iconData: Icons.hourglass_bottom,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
