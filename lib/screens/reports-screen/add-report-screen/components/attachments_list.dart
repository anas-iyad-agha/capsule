import 'package:Capsule/providers/reports-provider.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';

class AttachmentsList extends StatelessWidget {
  final bool showRemoveIcon;

  const AttachmentsList({super.key, this.showRemoveIcon = false});

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thumbVisibility: true,
      child: Consumer<ReportsProvider>(
        builder: (context, provider, widget) => ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) => Card(
            elevation: 6,
            child: ListTile(
              contentPadding: EdgeInsets.all(8),
              onTap: () {
                OpenFilex.open(provider.selectedAttachments[index].path);
              },
              leading: Image.asset('assets/icons/pdf.png'),
              title: Text(p.basename(provider.selectedAttachments[index].path)),
              trailing: showRemoveIcon
                  ? IconButton(
                      onPressed: () {
                        provider.removeSelectedAttachment(
                          provider.selectedAttachments[index],
                        );
                      },
                      icon: Icon(Icons.close),
                    )
                  : null,
            ),
          ),
          itemCount: provider.selectedAttachments.length,
        ),
      ),
    );
  }
}
