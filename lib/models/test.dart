class Test {
  final int? id;
  final String name;
  final DateTime date;
  final String? attachment;

  Test({
    this.id,
    required this.name,
    required this.date,
    required this.attachment,
  });

  factory Test.fromJson(Map<String, dynamic> json) => Test(
    id: json['id'],
    name: json['name'],
    date: DateTime.parse(json['date']),
    attachment: json['attachment'],
  );

  toJson() => {'id': id, 'name': name, 'date': date, 'attachment': attachment};
}
