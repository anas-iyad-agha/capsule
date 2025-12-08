import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as p;

class FileCard extends StatelessWidget {
  final File file;
  final bool isDeletable;
  final Function()? onDeleteCallback;
  const FileCard(
    this.file, {
    this.isDeletable = true,
    this.onDeleteCallback,
    super.key,
  });

  String getFileSize() {
    int fileSize = file.lengthSync();
    String unit = 'bytes';
    switch (fileSize) {
      case > 1024:
        unit = 'KB';
        fileSize = fileSize ~/ 1024;
      case > 1024 * 1023:
        unit = 'MB';
        fileSize = fileSize ~/ (1024 * 1024);
      case > 1024 * 1024 * 1023:
        unit = 'GB';
        fileSize = fileSize ~/ 1024 * 1024 * 1024;
    }

    return '$fileSize $unit';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        OpenFilex.open(file.path);
      },
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              isDeletable
                  ? IconButton(
                      onPressed: onDeleteCallback,
                      icon: Icon(Icons.close),
                    )
                  : SizedBox(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p.basename(file.path)),
                  Text(getFileSize(), textDirection: TextDirection.ltr),
                ],
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.file_copy),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
