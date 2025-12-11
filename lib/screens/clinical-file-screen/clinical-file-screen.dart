import 'package:Capsule/screens/clinical-file-screen/illnesses-screen/illnesses-screen.dart';
import 'package:Capsule/screens/clinical-file-screen/medicine/medicine-screen.dart';
import 'package:Capsule/screens/clinical-file-screen/operations-screen/operations-screen.dart';
import 'package:Capsule/screens/clinical-file-screen/patient-info-screen/patient-info-screen.dart';
import 'package:Capsule/screens/clinical-file-screen/tests-screen/tests-screen.dart';
import 'package:Capsule/screens/clinical-file-screen/view-all-info-screen/view-all-info-screen.dart';
import 'package:Capsule/screens/components/curved-container.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
          CurvedContainer(
            ListView(
              children: [
                Card(
                  child: ListTile(
                    minVerticalPadding: 32,
                    onTap: () =>
                        Navigator.pushNamed(context, PatientInfoScreen.route),
                    trailing: Icon(Icons.arrow_forward_ios),
                    leading: Icon(Icons.person, color: Colors.cyan),
                    title: Text('معلومات المريض'),
                  ),
                ),
                Card(
                  child: ListTile(
                    minVerticalPadding: 32,
                    onTap: () =>
                        Navigator.pushNamed(context, MedicineScreen.route),
                    trailing: Icon(Icons.arrow_forward_ios),
                    leading: FaIcon(FontAwesomeIcons.pills, color: Colors.cyan),
                    title: Text('الأدوية'),
                  ),
                ),
                Card(
                  child: ListTile(
                    minVerticalPadding: 32,
                    onTap: () =>
                        Navigator.pushNamed(context, IllnessesScreen.route),
                    trailing: Icon(Icons.arrow_forward_ios),
                    leading: FaIcon(FontAwesomeIcons.virus, color: Colors.cyan),
                    title: Text('الامراض'),
                  ),
                ),
                Card(
                  child: ListTile(
                    minVerticalPadding: 32,
                    onTap: () =>
                        Navigator.pushNamed(context, OperationsScreen.route),
                    trailing: Icon(Icons.arrow_forward_ios),
                    leading: FaIcon(
                      FontAwesomeIcons.stethoscope,
                      color: Colors.cyan,
                    ),
                    title: Text('العمليات'),
                  ),
                ),
                Card(
                  child: ListTile(
                    minVerticalPadding: 32,
                    onTap: () =>
                        Navigator.pushNamed(context, TestsScreen.route),
                    trailing: Icon(Icons.arrow_forward_ios),
                    leading: FaIcon(FontAwesomeIcons.flask, color: Colors.cyan),
                    title: Text('التحاليل'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, ViewAllInfoScreen.route),
        label: Text('عرض الملف كامل'),
      ),
    );
  }
}
