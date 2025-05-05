import 'dart:developer';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

class UpdateProfileRepository {
  final String baseUrl = "http://bhiwandicorporation.in/Service.svc";

  Future<bool> updateUserDetails({
    required String firstName,
    required String lastName,
    required String email,
    required String mobileNo,
    required String aadharNo,
    required String bloodGroup,
  }) async {
    const String soapAction =
        "http://tempuri.org/IService/UpdateUserDetails_BNCMC";

    final String soapEnvelope = '''
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
  <soapenv:Header/>
  <soapenv:Body>
    <tem:UpdateUserDetails_BNCMC>
      <tem:FirstName>$firstName</tem:FirstName>
      <tem:LastName>$lastName</tem:LastName>
      <tem:Email>$email</tem:Email>
      <tem:MobileNo>$mobileNo</tem:MobileNo>
      <tem:AdharNo>$aadharNo</tem:AdharNo>
      <tem:BloodGroup>$bloodGroup</tem:BloodGroup>
    </tem:UpdateUserDetails_BNCMC>
  </soapenv:Body>
</soapenv:Envelope>
''';

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'text/xml; charset=utf-8',
          'SOAPAction': soapAction,
        },
        body: soapEnvelope,
      );

      if (response.statusCode == 200) {
        final doc = XmlDocument.parse(response.body);
        final rawResult =
            doc
                .findAllElements('UpdateUserDetails_BNCMCResult')
                .first
                .innerText;
        log("Raw Result: $rawResult");
        // Unescape HTML entities like &lt; and &gt;
        return rawResult.contains('<SuccessCode>9999</SuccessCode>');
      } else {
        log("❌ Server error: ${response.statusCode}");
      }
    } catch (e) {
      log("Exception during updateUserDetails: $e");
    }

    return false;
  }
}
