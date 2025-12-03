import 'package:Capsule/screens/components/custom-drop-down-menu.dart';
import 'package:Capsule/screens/ddi-test-screen/components/drugs-interaction-meter.dart';
import 'package:Capsule/test-data/DDI-test-data.dart';
import 'package:flutter/material.dart';

// in this screen there should be 2 inputs that is the official name of the medicine and an output of how they interact with each other

class DDITestScreen extends StatefulWidget {
  static const route = '/DDI-test';

  const DDITestScreen({super.key});

  @override
  State<DDITestScreen> createState() => _DDITestScreenState();
}

class _DDITestScreenState extends State<DDITestScreen> {
  final _formKey = GlobalKey<FormState>();

  final _drug1Controller = TextEditingController();

  final _drug2Controller = TextEditingController();

  DDITestDataModel? result;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(title: Text('التفاعلات الدوائية')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomDropDownMenu<String>(
                    label: 'الدواء',
                    width: width / 2 - 16,
                    controller: _drug1Controller,
                    dropDownMenuEntries: [
                      for (var ddiTest in ddITestData)
                        DropdownMenuEntry(
                          value: ddiTest.drug1,
                          label: ddiTest.drug1,
                        ),
                    ],
                  ),
                  SizedBox(width: 16),
                  CustomDropDownMenu<String>(
                    label: 'الدواء',
                    width: width / 2 - 16,
                    controller: _drug2Controller,
                    dropDownMenuEntries: [
                      for (var ddiTest in ddITestData)
                        DropdownMenuEntry(
                          value: ddiTest.drug2,
                          label: ddiTest.drug2,
                        ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  bool exists = ddITestData.any(
                    (e) =>
                        e.drug1 == _drug1Controller.text &&
                        e.drug2 == _drug2Controller.text,
                  );
                  setState(() {
                    if (exists) {
                      result = ddITestData.firstWhere(
                        (e) =>
                            e.drug1 == _drug1Controller.text &&
                            e.drug2 == _drug2Controller.text,
                      );
                      print(result!.details);
                    } else {
                      result = DDITestDataModel(
                        drug1: _drug1Controller.text,
                        drug2: _drug2Controller.text,
                        interactionLevel: 0,
                        details: 'لا يوجد تفاعلات دوائية معروفة للدوائين',
                      );
                    }
                  });
                }
              },
              child: Text('التحقق'),
            ),
            SizedBox(height: 16),
            result != null && result!.interactionLevel != 0
                ? DrugsInteractionMeter(
                    result!.interactionLevel - 1,
                    width: width / 2,
                  )
                : SizedBox(),
            SizedBox(height: 16),
            result != null
                ? Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        result!.details,
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
