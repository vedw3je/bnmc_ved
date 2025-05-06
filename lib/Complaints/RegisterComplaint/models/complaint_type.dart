class ComplaintType {
  String id;
  String name;

  ComplaintType({required this.id, required this.name});

  // Create a ComplaintType instance from JSON
  factory ComplaintType.fromJson(Map<String, dynamic> json) {
    return ComplaintType(id: json['id'], name: json['name']);
  }

  // Convert a ComplaintType instance to JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }

  @override
  String toString() {
    return 'ComplaintType{id: $id, name: $name}';
  }
}
