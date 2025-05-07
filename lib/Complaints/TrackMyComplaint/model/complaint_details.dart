class ComplaintDetails {
  final String username;
  final String statusDate;
  final String status;
  final String action;
  final String remark;

  ComplaintDetails({
    required this.username,
    required this.statusDate,
    required this.status,
    required this.action,
    required this.remark,
  });

  // Factory constructor to create a ComplaintDetails object from a map
  factory ComplaintDetails.fromMap(Map<String, dynamic> map) {
    return ComplaintDetails(
      username: map['username'] ?? '',
      statusDate: map['statusDate'] ?? '',
      status: map['status'] ?? '',
      action: map['action'] ?? '',
      remark: map['remark'] ?? '',
    );
  }
}
