import 'package:capsule/models/medicine.dart';
import 'package:capsule/providers/medicineReminderProvider.dart';
import 'package:capsule/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomDropdownMenu extends StatefulWidget {
  const CustomDropdownMenu({
    super.key,
    required this.controller,
    this.selectedMedicine,
  });

  final TextEditingController controller;
  final Medicine? selectedMedicine;

  @override
  _CustomDropdownMenuState createState() => _CustomDropdownMenuState();
}

class _CustomDropdownMenuState extends State<CustomDropdownMenu> {
  String searchString = '';
  bool dropdownShow = false;
  Medicine? selectedMedicine;

  @override
  void initState() {
    super.initState();
    selectedMedicine = widget.selectedMedicine;
    searchString = widget.selectedMedicine?.name ?? '';
    widget.controller.text = widget.selectedMedicine?.name ?? '';
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final curveSize = MediaQuery.of(context).size.width / 20;
    List<Medicine> allMedicine = Provider.of<MedicineReminderProvider>(
      context,
      listen: false,
    ).medicines;

    List<Medicine> filteredMedicines = allMedicine
        .where(
          (med) => med.name.toLowerCase().contains(searchString.toLowerCase()),
        )
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // حقل البحث والاختيار
        TextFormField(
          onChanged: (value) {
            setState(() {
              searchString = value;
              if (value.isEmpty) {
                dropdownShow = false;
              } else {
                dropdownShow = true;
              }
            });
          },
          onTap: () {
            setState(() {
              dropdownShow = true;
            });
          },
          validator: (value) {
            if (!allMedicine.any((med) => med.name == widget.controller.text)) {
              return 'الرجاء اختيار دواء من القائمة';
            }
            return null;
          },
          controller: widget.controller,
          decoration: InputDecoration(
            labelText: 'اختر الدواء',
            prefixIcon: const Icon(Icons.medication_rounded),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  dropdownShow = !dropdownShow;
                });
              },
              icon: Icon(
                dropdownShow
                    ? Icons.arrow_drop_up_rounded
                    : Icons.arrow_drop_down_rounded,
                color: dropdownShow
                    ? MyColors.primaryBlue
                    : MyColors.mediumGray,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),

        // قائمة الأدوية المنسدلة
        Visibility(
          visible: dropdownShow,
          child: Card(
            elevation: 8,
            shadowColor: MyColors.primaryBlue.withOpacity(0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: MyColors.white,
              ),
              child: filteredMedicines.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.medication_outlined,
                              color: MyColors.lightGray,
                              size: 32,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'لا توجد أدوية',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: MyColors.mediumGray),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: curveSize,
                      ),
                      itemCount: filteredMedicines.length,
                      separatorBuilder: (_, __) => const Divider(
                        height: 1,
                        color: MyColors.lightestBlue,
                      ),
                      itemBuilder: (context, index) {
                        Medicine med = filteredMedicines[index];
                        bool isSelected = widget.controller.text == med.name;
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          leading: Icon(
                            Icons.check_circle_rounded,
                            color: isSelected
                                ? MyColors.primaryBlue
                                : Colors.transparent,
                            size: 20,
                          ),
                          title: Text(
                            med.name,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: isSelected
                                      ? MyColors.primaryBlue
                                      : MyColors.darkNavyBlue,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                ),
                          ),
                          trailing: med.dosage != null
                              ? Text(
                                  med.dosage!,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: MyColors.mediumGray),
                                )
                              : null,
                          onTap: () {
                            setState(() {
                              widget.controller.text = med.name;
                              searchString = med.name;
                              selectedMedicine = med;
                              dropdownShow = false;
                            });
                          },
                          hoverColor: MyColors.lightSkyBlue.withOpacity(0.2),
                        );
                      },
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
