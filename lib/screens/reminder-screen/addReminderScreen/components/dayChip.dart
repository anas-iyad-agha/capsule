import 'package:capsule/theme.dart';
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
        constraints: const BoxConstraints(minWidth: 40),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: selected ? MyColors.white : MyColors.darkNavyBlue,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              fontSize: 13,
              fontFamily: 'Tajawal',
            ),
          ),
        ),
      ),
      selected: selected,
      onSelected: onSelected,
      backgroundColor: MyColors.veryLightGray,
      selectedColor: MyColors.primaryBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: selected
              ? MyColors.primaryBlue
              : MyColors.lightSkyBlue.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      elevation: selected ? 4 : 0,
      shadowColor: selected ? MyColors.primaryBlue.withOpacity(0.3) : null,
      showCheckmark: false,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    );
  }
}
