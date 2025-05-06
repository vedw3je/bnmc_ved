class Prabhag {
  String id;
  String name;

  Prabhag({required this.id, required this.name});

  // Factory constructor to create a Prabhag from JSON
  factory Prabhag.fromJson(Map<String, dynamic> json) {
    return Prabhag(id: json['id'], name: json['name']);
  }

  // Method to convert Prabhag to JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }

  @override
  String toString() {
    return 'Prabhag{id: $id, name: $name}';
  }
}
