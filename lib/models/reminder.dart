class Reminder {
  int? id;
  final int medicineId;
  final String medicineName;

  final DateTime dateTime;
  final String? label;

  final bool isTaken;

  Reminder({
    this.id,
    required this.medicineId,
    this.medicineName = '',
    required this.dateTime,
    this.label = '',
    required this.isTaken,
  });

  factory Reminder.fromJson(Map<String, dynamic> json) => Reminder(
    id: json['id'],
    medicineId: json['medicine_id'],
    medicineName: json['medicine_name'],
    dateTime: DateTime.parse(json['date_time']),
    label: json['label'],
    isTaken: json['is_taken'] == 1,
  );

  toJson() => {
    'id': id,
    'medicine_id': medicineId,
    'medicine_name': medicineName,
    'date_time': dateTime.toString(),
    'label': label,
    'is_taken': isTaken,
  };

  @override
  String toString() {
    // TODO: implement toString
    return 'id: $id, medicineName: $medicineName, label: $label, dateTime: $dateTime';
  }
}
