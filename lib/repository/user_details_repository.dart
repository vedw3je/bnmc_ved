import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

import '../register/model/user_details.dart';

class UserDetailsRepository {
  final String baseUrl = "http://bhiwandicorporation.in/Service.svc";

  Future<UserDetails?> getUserDetails(String mobileNo) async {
    final String soapEnvelope =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
    <soapenv:Header/>
    <soapenv:Body>
      <tem:GetUserDetails_BNCMC>
        <tem:MobileNo>$mobileNo</tem:MobileNo>
      </tem:GetUserDetails_BNCMC>
    </soapenv:Body>
  </soapenv:Envelope>''';

    const String soapAction =
        'http://tempuri.org/IService/GetUserDetails_BNCMC';

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'text/xml; charset=utf-8',
        'SOAPAction': soapAction,
      },
      body: soapEnvelope,
    );

    if (response.statusCode == 200) {
      final document = XmlDocument.parse(response.body);
      final result =
          document.findAllElements('GetUserDetails_BNCMCResult').first.text;
      log(result);

      if (result.contains('<SuccessCode>9999</SuccessCode>')) {
        try {
          return UserDetails.fromXml(result);
        } catch (e) {
          log('Error parsing user details XML: $e');
          return null;
        }
      } else {
        final errorMsgStart = result.indexOf('<SuccessMessage>') + 16;
        final errorMsgEnd = result.indexOf('</SuccessMessage>');
        final errorMsg = result.substring(errorMsgStart, errorMsgEnd);
        log('Error: $errorMsg');
        return null;
      }
    } else {
      log('Error: Server responded with status ${response.statusCode}');
      return null;
    }
  }
}
