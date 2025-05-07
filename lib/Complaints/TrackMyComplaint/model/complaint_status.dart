class ComplaintStatus {
  final String complaintNo;
  final String contactNo;
  final String complaint;
  final String status;
  final String complaintType;
  final String complaintSubType;
  final String complaintDate;
  final String remark;

  ComplaintStatus({
    required this.complaintNo,
    required this.contactNo,
    required this.complaint,
    required this.status,
    required this.complaintType,
    required this.complaintSubType,
    required this.complaintDate,
    required this.remark,
  });

  factory ComplaintStatus.fromJson(Map<String, dynamic> json) {
    return ComplaintStatus(
      complaintNo: json['complaintNo'] ?? '',
      contactNo: json['contactNo'] ?? '',
      complaint: json['complaint'] ?? '',
      status: json['status'] ?? '',
      complaintType: json['complaintType'] ?? '',
      complaintSubType: json['complaintSubType'] ?? '',
      complaintDate: json['complaintDate'] ?? '',
      remark: json['remark'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'complaintNo': complaintNo,
      'contactNo': contactNo,
      'complaint': complaint,
      'status': status,
      'complaintType': complaintType,
      'complaintSubType': complaintSubType,
      'complaintDate': complaintDate,
      'remark': remark,
    };
  }
}
