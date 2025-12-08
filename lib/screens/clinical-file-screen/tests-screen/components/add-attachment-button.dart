import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class AddAttachmentButton extends StatelessWidget {
  final void Function() onTap;
  const AddAttachmentButton(this.onTap, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          dashPattern: [12],
          padding: EdgeInsets.all(12),
          color: Colors.grey,
          strokeWidth: 2,
          radius: Radius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(Icons.attach_file), Text('اضافة مرفق')],
        ),
      ),
    );
  }
}
