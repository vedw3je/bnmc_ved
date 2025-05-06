import 'dart:developer';
import 'package:bncmc/Complaints/RegisterComplaint/models/complaint_subtype.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

class ComplaintSubtypeRepository {
  final String baseUrl = "http://bhiwandicorporation.in/Service.svc";

  Future<List<ComplaintSubType>> fetchComplaintSubTypes(
    String selectedComplaintTypeId,
  ) async {
    const String namespace = "http://tempuri.org/";
    const String method = "GetCRMComplaintSubTypeList_BNCMC";
    const String soapAction =
        "http://tempuri.org/IService/GetCRMComplaintSubTypeList_BNCMC";

    final String soapEnvelope = '''<?xml version="1.0" encoding="utf-8"?>
      <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                     xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                     xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
        <soap:Body>
          <$method xmlns="$namespace">
            <ComplaintTypeId>$selectedComplaintTypeId</ComplaintTypeId>
          </$method>
        </soap:Body>
      </soap:Envelope>''';

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'text/xml; charset=utf-8',
        'SOAPAction': soapAction,
      },
      body: soapEnvelope,
    );

    if (response.statusCode == 200) {
      // Step 1: Replace escaped characters in the response
      final responseBody = response.body
          .replaceAll('&lt;', '<')
          .replaceAll('&gt;', '>')
          .replaceAll('&amp;', '&')
          .replaceAll('&#xD;', '');
      log(responseBody);

      // Step 2: Check for success code
      if (!responseBody.contains("<SuccessCode>9999</SuccessCode>")) {
        final msgStart = responseBody.indexOf("<SuccessMessage>") + 16;
        final msgEnd = responseBody.indexOf("</SuccessMessage>");
        final message = responseBody.substring(msgStart, msgEnd);
        throw Exception("Server error: $message");
      }

      // Step 3: Extract inner <ComplaintSubTypeResponse> XML
      final startIndex = responseBody.indexOf("<ComplaintSubTypeResponse>");
      final endIndex =
          responseBody.indexOf("</ComplaintSubTypeResponse>") +
          "</ComplaintSubTypeResponse>".length;
      final innerXml = responseBody.substring(startIndex, endIndex);

      // Step 4: Parse the embedded XML
      final document = XmlDocument.parse(innerXml);

      // Step 5: Extract ComplaintSubType elements
      final subTypes = <ComplaintSubType>[];
      for (final element in document.findAllElements("ComplaintSubType")) {
        final id = element.findElements("Id").single.text;
        final name = element.findElements("Name").single.text;
        subTypes.add(ComplaintSubType(id: id, name: name));
      }

      return subTypes;
    } else {
      throw Exception('Failed to load subtypes: ${response.statusCode}');
    }
  }
}
