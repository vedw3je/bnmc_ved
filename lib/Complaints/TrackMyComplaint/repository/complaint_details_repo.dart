import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import '../model/complaint_details.dart';

class TrackComplaintDetailsRepo {
  static const String _url =
      'http://bhiwandicorporation.in/Service.svc'; // Replace with actual URL
  static const String _namespace = 'http://tempuri.org/';
  static const String _soapAction =
      'http://tempuri.org/IService/ComplaintNoDetails_BNCMC'; // Replace with actual SOAP action
  static const String _method =
      'ComplaintNoDetails_BNCMC'; // Replace with the actual method name

  Future<List<ComplaintDetails>> getComplaintDetails({
    required String complaintNo,
  }) async {
    final soapEnvelope = '''<?xml version="1.0" encoding="utf-8"?>
    <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                   xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                   xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
      <soap:Body>
        <$_method xmlns="$_namespace">
          <ComplaintNo>$complaintNo</ComplaintNo>
        </$_method>
      </soap:Body>
    </soap:Envelope>''';

    try {
      final response = await http.post(
        Uri.parse(_url),
        headers: {
          'Content-Type': 'text/xml; charset=utf-8',
          'SOAPAction': _soapAction,
        },
        body: utf8.encode(soapEnvelope),
      );

      if (response.statusCode == 200) {
        final cleanedXml = response.body
            .replaceAll('&lt;', '<')
            .replaceAll('&gt;', '>')
            .replaceAll('&amp;', '&')
            .replaceAll('&#xD;', '');
        log(cleanedXml);
        final document = xml.XmlDocument.parse(cleanedXml);

        // Parsing the ComplaintDetails elements from the XML response
        final complaintDetailsElements = document.findAllElements(
          'ComplaintDetails',
        );
        List<ComplaintDetails> complaintList = [];

        for (var item in complaintDetailsElements) {
          complaintList.add(
            ComplaintDetails(
              username: item.getElement('username')?.innerText ?? '',
              statusDate: item.getElement('complregdate')?.innerText ?? '',
              status: item.getElement('status')?.innerText ?? '',
              action: item.getElement('action')?.innerText ?? '',
              remark: item.getElement('remark')?.innerText ?? '',
            ),
          );
        }

        return complaintList;
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Exception: ${e.toString()}');
    }
  }
}
