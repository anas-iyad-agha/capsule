class PatientInfo {
  String fullName;
  String job;
  bool isMale;
  String familyStatus;
  double weight;
  double height;
  String bloodType;
  String allergies;
  bool isSmoking;

  PatientInfo({
    required this.fullName,
    required this.job,
    required this.isMale,
    required this.familyStatus,
    required this.weight,
    required this.height,
    required this.bloodType,
    required this.allergies,
    required this.isSmoking,
  });

  Map<String, dynamic> toJson() => {
    'full_name': fullName,
    'job': job,
    'is_male': isMale,
    'is_married': familyStatus,
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
    familyStatus: json['is_married'],
    weight: json['weight'],
    height: json['height'],
    bloodType: json['blood_type'],
    allergies: json['allergies'],
    isSmoking: json['is_smoking'],
  );
}
