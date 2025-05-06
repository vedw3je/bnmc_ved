import 'dart:convert';

import 'package:bncmc/Complaints/RegisterComplaint/models/department.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

class DepartmentRepository {
  final String baseUrl = "http://bhiwandicorporation.in/Service.svc";
  final String _soapAction =
      "http://tempuri.org/IService/GetCRMDepartmentList_BNCMC";
  final String _method = "GetCRMDepartmentList_BNCMC";
  final String _namespace = "http://tempuri.org/";

  Future<List<Department>> fetchDepartmentList() async {
    final soapEnvelope =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="$_namespace">
        <soapenv:Header/>
        <soapenv:Body>
          <tem:$_method/>
        </soapenv:Body>
      </soapenv:Envelope>''';

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        "Content-Type": "text/xml; charset=utf-8",
        "SOAPAction": _soapAction,
      },
      body: utf8.encode(soapEnvelope),
    );

    if (response.statusCode == 200) {
      // Decode XML escapes
      final responseBody = response.body
          .replaceAll('&lt;', '<')
          .replaceAll('&gt;', '>')
          .replaceAll('&amp;', '&')
          .replaceAll('&#xD;', '');

      //log(responseBody);

      // Check for success code
      if (!responseBody.contains("<SuccessCode>9999</SuccessCode>")) {
        final msgStart = responseBody.indexOf("<SuccessMessage>") + 16;
        final msgEnd = responseBody.indexOf("</SuccessMessage>");
        final message = responseBody.substring(msgStart, msgEnd);
        throw Exception("Server error: $message");
      }

      // Extract inner <DepartmentResponse> XML
      final startIndex = responseBody.indexOf("<DepartmentResponse>");
      final endIndex =
          responseBody.indexOf("</DepartmentResponse>") +
          "</DepartmentResponse>".length;
      final innerXml = responseBody.substring(startIndex, endIndex);

      // Parse the XML string
      final document = XmlDocument.parse(innerXml);

      // Extract departments
      final departmentList = <Department>[];
      for (final element in document.findAllElements("Department")) {
        final id = element.findElements("Id").single.text;
        final name = element.findElements("Name").single.text;
        departmentList.add(Department(id: id, name: name));
      }

      return departmentList;
    } else {
      throw Exception("Failed to load Department list");
    }
  }
}
