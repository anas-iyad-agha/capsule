class Medicine {
  final int? id;
  final String name;
  final String description;
  final double currentSupply;
  final double dose;
  final double strength;

  Medicine({
    this.id,
    required this.name,
    required this.description,
    required this.currentSupply,
    required this.dose,
    required this.strength,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) => Medicine(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    currentSupply: json['current_supply'],
    dose: json['dose'],
    strength: json['strength'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'current_supply': currentSupply,
    'dose': dose,
    'strength': strength,
  };

  @override
  String toString() {
    return 'id : $id, name : $name, description : $description, currentSupply : $currentSupply, dose: $dose, strength : $strength';
  }
}
