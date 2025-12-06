class Illness {
  final int? id;
  final String name;
  final String description;
  final String type;

  static const List<String> illnessTypes = [
    'حالي',
    'مؤقت',
    'تم التعافي',
    'وراثي',
  ];

  Illness({
    required this.name,
    required this.description,
    required this.type,
    this.id,
  });

  factory Illness.fromJson(Map<String, dynamic> json) => Illness(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    type: json['type'],
  );

  toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'type': type,
  };
}
