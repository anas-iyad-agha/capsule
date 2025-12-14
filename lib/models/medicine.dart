class Medicine {
  final int? id;
  final String name;
  final String description;
  final double dose;
  final double strength;
  final DateTime startDate;
  final DateTime endDate;

  Medicine({
    this.id,
    required this.name,
    required this.description,
    required this.dose,
    required this.strength,
    required this.startDate,
    required this.endDate,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) => Medicine(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    dose: json['dose'],
    strength: json['strength'],
    startDate: DateTime.parse(json['start_date']),
    endDate: DateTime.parse(json['end_date']),
  );

  get dosage => null;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'dose': dose,
    'strength': strength,
    'start_date': startDate.toString(),
    'end_date': endDate.toString(),
  };

  @override
  String toString() {
    return 'id : $id, name : $name, description : $description, dose: $dose, strength : $strength';
  }
}
