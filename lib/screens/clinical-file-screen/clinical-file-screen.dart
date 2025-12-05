import 'package:flutter/material.dart';

class ClinicalFileScreen extends StatefulWidget {
  static const route = '/clinical-file';
  const ClinicalFileScreen({super.key});

  @override
  State<ClinicalFileScreen> createState() => _ClinicalFileScreenState();
}

class _ClinicalFileScreenState extends State<ClinicalFileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          GestureDetector(child: Text('معلومات المريض')),
          GestureDetector(child: Text('الأدوية')),
          GestureDetector(child: Text('الأمراض')),
          GestureDetector(child: Text('العمليات')),
          GestureDetector(child: Text('التحاليل')),
        ],
      ),
    );
  }
}
