import 'dart:convert';

import 'package:Capsule/models/patient-info.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PatientInfoProvider with ChangeNotifier {
  PatientInfo? patientInfo;

  Future getPatientInfo() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    String? patientInfoJson = sharedPref.getString('patient_info');
    if (patientInfoJson != null) {
      patientInfo = PatientInfo.fromJson(jsonDecode(patientInfoJson));
    }
    notifyListeners();
  }

  Future saveInfo(PatientInfo newPatientInfo) async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    sharedPref.setString('patient_info', jsonEncode(newPatientInfo.toJson()));
    patientInfo = newPatientInfo;
    notifyListeners();
  }
}
