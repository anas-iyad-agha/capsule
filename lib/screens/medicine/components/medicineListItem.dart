import 'package:Capsule/models/medicine.dart';
import 'package:Capsule/screens/medicine/components/delete-medicine-dialog.dart';
import 'package:Capsule/screens/medicine/edit-medicine-screen/edit-medicine-screen.dart';
import 'package:Capsule/screens/medicine/view-medicine-screen/view-medicine-screen.dart';
import 'package:flutter/material.dart';

class MedicineListItem extends StatelessWidget {
  final Medicine medicine;
  const MedicineListItem(this.medicine, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ListTile(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewMedicineScreen(medicine),
            ),
          ),
          leading: Image.asset('assets/icons/pills.png'),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(medicine.name),
              Text(
                medicine.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
          trailing: MenuAnchor(
            menuChildren: [
              MenuItemButton(
                child: Text('تعديل'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditMedicineScreen(medicine),
                    ),
                  );
                },
                leadingIcon: Icon(Icons.edit),
              ),
              MenuItemButton(
                child: Text('حذف'),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => DeleteMedicineDialog(medicine),
                  );
                },
                leadingIcon: Icon(Icons.delete),
              ),
            ],
            builder: (_, controller, _) => IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {
                if (controller.isOpen) {
                  controller.close();
                } else {
                  controller.open();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
