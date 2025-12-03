import 'package:Capsule/models/medicine.dart';
import 'package:Capsule/providers/medicineReminderProvider.dart';
import 'package:Capsule/theme.dart';
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
    setState(() {
      selectedMedicine = widget.selectedMedicine;
      searchString = widget.selectedMedicine?.name ?? '';
      widget.controller.text = widget.selectedMedicine?.name ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final curveSize = MediaQuery.of(context).size.width / 20;
    List<Medicine> allMedicine = Provider.of<MedicineReminderProvider>(
      context,
      listen: false,
    ).medicines;

    return Column(
      children: [
        TextFormField(
          onChanged: (value) {
            setState(() {
              searchString = value;
            });
          },
          onTap: () {
            setState(() {
              dropdownShow = true;
            });
          },
          validator: (value) {
            if (!allMedicine.any((med) => med.name == widget.controller.text)) {
              return 'الرجاء اختيار الدواء';
            }
            return null;
          },
          controller: widget.controller,
          decoration: InputDecoration(
            labelText: 'اختر دواء',
            labelStyle: TextStyle(
              color: dropdownShow ? MyColors.lightBlue : Colors.black54,
            ),
            errorStyle: const TextStyle(color: MyColors.lightRed),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  dropdownShow = !dropdownShow;
                });
              },
              icon: Icon(
                Icons.arrow_drop_down_outlined,
                color: dropdownShow ? MyColors.lightBlue : Colors.grey,
              ),
            ),
            disabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: dropdownShow ? MyColors.lightBlue : Colors.grey,
              ),
            ),
          ),
        ),

        //This Widget is the dropdown List
        Visibility(
          visible: dropdownShow,
          child: LimitedBox(
            maxHeight: 150,
            child: Card(
              elevation: 8,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: curveSize),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: allMedicine.length,
                  itemBuilder: (context, index) {
                    Medicine med = allMedicine[index];
                    return med.name.toLowerCase().contains(
                          searchString.toLowerCase(),
                        )
                        ? TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.black,
                              padding: EdgeInsets.zero,
                              alignment: Alignment.centerLeft,
                              textStyle: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(fontSize: 16),
                            ),
                            onPressed: () {
                              setState(() {
                                widget.controller.text = med.name;
                                searchString = med.name;
                                selectedMedicine = med;
                                dropdownShow = false;
                              });
                            },
                            child: Text(med.name),
                          )
                        : Container();
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
