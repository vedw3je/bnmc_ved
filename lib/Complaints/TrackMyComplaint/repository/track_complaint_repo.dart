
import 'package:bncmc/Complaints/TrackMyComplaint/model/complaint_status.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:xml/xml.dart' as xml;

class TrackComplaintRepo {
  static const String _url = 'http://bhiwandicorporation.in/Service.svc';
  static const String _namespace = 'http://tempuri.org/';
  static const String _soapAction =
      'http://tempuri.org/IService/ComplaintStatus_BNCMC';
  static const String _method = 'ComplaintStatus_BNCMC';

  Future<List<ComplaintStatus>> trackComplaintStatus({
    required String mobileNo,
  }) async {
    final soapEnvelope = '''<?xml version="1.0" encoding="utf-8"?>
    <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                   xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                   xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
      <soap:Body>
        <$_method xmlns="$_namespace">
          <MobileNo>$mobileNo</MobileNo>
          <ComplaintNo></ComplaintNo>
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

        final document = xml.XmlDocument.parse(cleanedXml);

        final complaintDetailsElements = document.findAllElements(
          'ComplaintDetails',
        );
        List<ComplaintStatus> complaints = [];

        for (var item in complaintDetailsElements) {
          complaints.add(
            ComplaintStatus(
              complaintNo: item.getElement('CMPLNO')?.text ?? '',
              contactNo: item.getElement('CUSTCNTNO')?.text ?? '',
              complaint: item.getElement('COMPLAINT')?.text ?? '',
              status: item.getElement('STATUS')?.text ?? '',
              complaintType: item.getElement('COMPLAINTTYPE')?.text ?? '',
              complaintSubType: item.getElement('complaintsubtype')?.text ?? '',
              complaintDate: item.getElement('CMPLREGDATE')?.text ?? '',
              remark: '',
            ),
          );
        }

        return complaints;
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Exception: ${e.toString()}');
    }
  }
}
