import 'package:Capsule/providers/medicineReminderProvider.dart';
import 'package:Capsule/screens/clinical-file-screen/medicine/add-medicine-screen/addMedicineScreen.dart';
import 'package:Capsule/screens/clinical-file-screen/medicine/components/medicineListItem.dart';
import 'package:Capsule/screens/components/curved-container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MedicineScreen extends StatefulWidget {
  static const route = '/clinical-file/medicine';

  const MedicineScreen({super.key});

  @override
  State<MedicineScreen> createState() => _MedicineScreenState();
}

class _MedicineScreenState extends State<MedicineScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MedicineReminderProvider>(context, listen: false).fetchData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text('أدويتي'),
        backgroundColor: Colors.cyan,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                Provider.of<MedicineReminderProvider>(
                  context,
                  listen: false,
                ).searchMedicine(value);
              },
              decoration: InputDecoration(
                hint: Text('البحث'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                fillColor: Colors.white,
                filled: true,
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          CurvedContainer(
            Consumer<MedicineReminderProvider>(
              builder: (context, provider, widget) {
                if (provider.medicines.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.medication_outlined),
                        Text('لم يتم اضافة ادوية بعد'),
                      ],
                    ),
                  );
                }
                return ListView.separated(
                  itemBuilder: (_, index) =>
                      MedicineListItem(provider.medicines[index]),
                  separatorBuilder: (_, _) => SizedBox(height: 16),
                  itemCount: provider.medicines.length,
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, AddMedicineScreen.route),
        label: Text('أضف دواء'),
        icon: Icon(Icons.add),
      ),
    );
  }
}
