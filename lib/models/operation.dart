class Operation {
  final int? id;
  final String name;
  final String description;

  Operation({this.id, required this.name, required this.description});

  factory Operation.fromJson(Map<String, dynamic> json) => Operation(
    id: json['id'],
    name: json['name'],
    description: json['description'],
  );

  toJson() => {'id': id, 'name': name, 'description': description};
}
