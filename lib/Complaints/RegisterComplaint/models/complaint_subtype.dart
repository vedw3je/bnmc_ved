class ComplaintSubType {
  String id;
  String name;

  ComplaintSubType({required this.id, required this.name});

  // Factory constructor to create from JSON
  factory ComplaintSubType.fromJson(Map<String, dynamic> json) {
    return ComplaintSubType(id: json['id'], name: json['name']);
  }

  // Method to convert to JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }

  @override
  String toString() {
    return 'ComplaintSubType{id: $id, name: $name}';
  }
}
