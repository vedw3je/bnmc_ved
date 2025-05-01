import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

class RegisterRepository {
  final String baseUrl = "http://bhiwandicorporation.in/Service.svc";

  Future<String?> registerUser({
    required String firstName,
    required String lastName,
    required String email,
    required String mobileNo,
    required String adharNo,
    required String bloodGroup,
  }) async {
    final String soapEnvelope =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
  <soapenv:Header/>
  <soapenv:Body>
    <tem:Registration_BNCMC>
      <tem:FirstName>$firstName</tem:FirstName>
      <tem:LastName>$lastName</tem:LastName>
      <tem:Email>$email</tem:Email>
      <tem:MobileNo>$mobileNo</tem:MobileNo>
      <tem:AdharNo>$adharNo</tem:AdharNo>
      <tem:BloodGroup>$bloodGroup</tem:BloodGroup>
    </tem:Registration_BNCMC>
  </soapenv:Body>
</soapenv:Envelope>''';

    const String soapAction = 'http://tempuri.org/IService/Registration_BNCMC';

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
          document.findAllElements('Registration_BNCMCResult').first.text;
      log(result);

      if (result.contains('<SuccessCode>9999</SuccessCode>')) {
        return 'OTP Sent Successfully';
      } else {
        try {
          final errorMsgStart = result.indexOf('<SuccessMessage>') + 16;
          final errorMsgEnd = result.indexOf('</SuccessMessage>');
          final errorMsg = result.substring(errorMsgStart, errorMsgEnd);
          return 'Error: $errorMsg';
        } catch (e) {
          return 'Error: Unable to parse error message';
        }
      }
    } else {
      return 'Error: Server responded with status ${response.statusCode}';
    }
  }
}
