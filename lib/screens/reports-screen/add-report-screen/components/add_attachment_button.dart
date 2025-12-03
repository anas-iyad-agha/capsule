import 'package:Capsule/providers/reports-provider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddAttachmentButton extends StatelessWidget {
  const AddAttachmentButton({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    return MaterialButton(
      onPressed: () async {
        await Provider.of<ReportsProvider>(
          context,
          listen: false,
        ).selectAttachments();
      },
      padding: EdgeInsets.zero,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: screenWidth * 0.45,
          maxWidth: screenWidth * 0.45,
        ),
        child: Card(
          elevation: 6,
          child: DottedBorder(
            options: RoundedRectDottedBorderOptions(
              borderPadding: EdgeInsets.all(8),
              radius: Radius.circular(8),
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 16,
              ),
              dashPattern: [6],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Icon(Icons.attach_file), Text('اضافة مرفق')],
            ),
          ),
        ),
      ),
    );
  }
}
