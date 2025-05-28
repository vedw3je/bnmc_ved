class ComplaintResponseModel {
  final String successCode;
  final String successMessage;
  final String complaintNumber;

  ComplaintResponseModel({
    required this.successCode,
    required this.successMessage,
    required this.complaintNumber,
  });

  factory ComplaintResponseModel.fromXml(String xml) {
    final codeStart = xml.indexOf("<SuccessCode>") + 13;
    final codeEnd = xml.indexOf("</SuccessCode>");
    final messageStart = xml.indexOf("<SuccessMessage>") + 16;
    final messageEnd = xml.indexOf("</SuccessMessage>");

    final successCode = xml.substring(codeStart, codeEnd);
    final successMessage = xml.substring(messageStart, messageEnd);

    // Extract complaint number from message string
    final regex = RegExp(r'Complaint No\.([A-Z0-9]+)');
    final match = regex.firstMatch(successMessage);
    final complaintNumber = match != null ? match.group(1)! : '';

    return ComplaintResponseModel(
      successCode: successCode,
      successMessage: successMessage,
      complaintNumber: complaintNumber,
    );
  }
}
