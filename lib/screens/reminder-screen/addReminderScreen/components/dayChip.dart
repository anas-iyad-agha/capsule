import 'package:Capsule/theme.dart';
import 'package:flutter/material.dart';

class DayChip extends StatelessWidget {
  const DayChip({
    super.key,
    this.label = '',
    this.selected = false,
    this.onSelected,
  });

  final String label;
  final bool selected;
  final void Function(bool)? onSelected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 20),
        child: Text(label, style: const TextStyle(color: MyColors.lightWhite)),
      ),
      selected: selected,
      onSelected: onSelected,
      selectedColor: MyColors.lightBlue,
      backgroundColor: MyColors.lightGray,
      elevation: 4,
      showCheckmark: false,
    );
  }
}
