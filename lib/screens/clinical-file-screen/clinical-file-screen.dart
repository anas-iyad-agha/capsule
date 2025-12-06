import 'package:Capsule/screens/clinical-file-screen/patient-info-screen/patient-info-screen.dart';
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
      appBar: AppBar(title: Text('الملف السريري')),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, PatientInfoScreen.route);
            },
            child: Text('معلومات المريض'),
          ),
          GestureDetector(child: Text('الأدوية')),
          GestureDetector(child: Text('الأمراض')),
          GestureDetector(child: Text('العمليات')),
          GestureDetector(child: Text('التحاليل')),
        ],
      ),
    );
  }
}
