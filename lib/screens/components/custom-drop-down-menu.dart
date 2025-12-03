import 'package:flutter/material.dart';

class CustomDropDownMenu<T> extends StatelessWidget {
  final List<DropdownMenuEntry<T>> dropDownMenuEntries;
  final String? Function(T? value)? validator;
  final String label;
  final TextEditingController? controller;
  final List<DropdownMenuEntry<T>> Function(List<DropdownMenuEntry<T>>, String)?
  filterCallBack;
  final double? width;

  const CustomDropDownMenu({
    this.dropDownMenuEntries = const [],
    this.label = '',
    this.width,
    this.controller,
    this.validator,
    this.filterCallBack,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownMenuFormField<T>(
      width: width,
      controller: controller,
      requestFocusOnTap: true,
      validator: validator,
      label: Text(label),
      filterCallback: filterCallBack,
      enableFilter: filterCallBack != null,
      dropdownMenuEntries: dropDownMenuEntries,
    );
  }
}
