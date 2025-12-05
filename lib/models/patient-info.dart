import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PatientInfo {
  String fullName;
  String job;
  bool isMale;
  bool isMarried;
  double weight;
  double height;
  String bloodType;
  String allergies;
  bool isSmoking;

  PatientInfo({
    required this.fullName,
    required this.job,
    required this.isMale,
    required this.isMarried,
    required this.weight,
    required this.height,
    required this.bloodType,
    required this.allergies,
    required this.isSmoking,
  });

  Future saveInfo() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    sharedPref.setString('patient_info', jsonEncode(toJson()));
  }

  Map<String, dynamic> toJson() => {
    'full_name': fullName,
    'job': job,
    'is_male': isMale,
    'is_married': isMarried,
    'weight': weight,
    'height': height,
    'blood_type': bloodType,
    'allergies': allergies,
    'is_smoking': isSmoking,
  };

  factory PatientInfo.fromJson(Map<String, dynamic> json) => PatientInfo(
    fullName: json['full_name'],
    job: json['job'],
    isMale: json['is_male'],
    isMarried: json['is_married'],
    weight: json['weight'],
    height: json['height'],
    bloodType: json['blood_type'],
    allergies: json['allergies'],
    isSmoking: json['is_smoking'],
  );
}
