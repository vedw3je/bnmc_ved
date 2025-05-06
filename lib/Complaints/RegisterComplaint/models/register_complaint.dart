class RegisterComplaint {
  String? successMessage;
  String? successCode;

  RegisterComplaint({this.successMessage, this.successCode});

  // Factory constructor to create from JSON
  factory RegisterComplaint.fromJson(Map<String, dynamic> json) {
    return RegisterComplaint(
      successMessage: json['successMessage'],
      successCode: json['successCode'],
    );
  }

  // Method to convert to JSON
  Map<String, dynamic> toJson() {
    return {'successMessage': successMessage, 'successCode': successCode};
  }

  @override
  String toString() {
    return 'RegisterComplaint{successMessage: $successMessage, successCode: $successCode}';
  }
}
