import 'dart:convert';
import 'package:xml/xml.dart';

class Department {
  final String id;
  final String name;

  Department({required this.id, required this.name});
}

Future<List<Department>> parseDepartmentsFromResponse(
  String responseBody,
) async {
  // Replace common XML escapes
  final decodedResponse = responseBody
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&amp;', '&')
      .replaceAll('&#xD;', '');

  if (!decodedResponse.contains("<SuccessCode>9999</SuccessCode>")) {
    final msgStart = decodedResponse.indexOf("<SuccessMessage>") + 16;
    final msgEnd = decodedResponse.indexOf("</SuccessMessage>");
    final message = decodedResponse.substring(msgStart, msgEnd);
    throw Exception("Server error: $message");
  }

  final startIndex = decodedResponse.indexOf("<DepartmentResponse>");
  final endIndex =
      decodedResponse.indexOf("</DepartmentResponse>") +
      "</DepartmentResponse>".length;
  final innerXml = decodedResponse.substring(startIndex, endIndex);

  final document = XmlDocument.parse(innerXml);

  final departmentList = <Department>[];
  for (final element in document.findAllElements("Department")) {
    final id = element.findElements("Id").single.text;
    final name = element.findElements("Name").single.text;
    departmentList.add(Department(id: id, name: name));
  }

  return departmentList;
}
