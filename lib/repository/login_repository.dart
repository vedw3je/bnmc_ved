import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:xml/xml.dart'; // To parse XML responses
import 'package:html_unescape/html_unescape.dart';

import '../register/model/user_details.dart';

class LoginRepository {
  final String baseUrl =
      "http://bhiwandicorporation.in/Service.svc"; // Base URL for SOAP requests

  String extractSuccessCode(String soapResponse) {
    try {
      // Step 1: Parse the outer SOAP response
      final outerXml = XmlDocument.parse(soapResponse);

      // Step 2: Extract the encoded inner result
      final encodedInner =
          outerXml
              .findAllElements('VerifyOTP_BNCMCResult')
              .map((e) => e.text)
              .join();

      // Step 3: Decode HTML entities from the extracted response
      final unescape = HtmlUnescape();
      final decodedXml = unescape.convert(encodedInner);

      // Step 4: Remove all <VerifyOTP> tags
      String fixedXml =
          decodedXml
              .replaceAll('<VerifyOTP>', '')
              .replaceAll('</VerifyOTP>', '')
              .trim();

      // Step 5: Wrap the cleaned XML in <root> to ensure proper parsing
      final wrappedXml = "<root>$fixedXml</root>";

      // Debugging: Check the wrapped XML content
      print("Wrapped XML: $wrappedXml");

      // Step 6: Parse the cleaned XML content
      final innerXml = XmlDocument.parse(wrappedXml);

      // Step 7: Extract the SuccessCode and return it
      final successCode =
          innerXml.findAllElements('SuccessCode').map((e) => e.text).join();

      return successCode;
    } catch (e) {
      print("Error extracting SuccessCode: $e");
      return "";
    }
  }

  Future<bool> verifyOtp(String mobileNo, String otp) async {
    print("Mobile Number: $mobileNo");
    final url = Uri.parse(baseUrl);
    print(url);

    final body = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
               xmlns:xsd="http://www.w3.org/2001/XMLSchema"
               xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <VerifyOTP_BNCMC xmlns="http://tempuri.org/">
      <MobileNo>$mobileNo</MobileNo>
      <OTP>$otp</OTP>
    </VerifyOTP_BNCMC>
  </soap:Body>
</soap:Envelope>''';

    final headers = {
      "Content-Type": "text/xml; charset=utf-8",
      "SOAPAction": "http://tempuri.org/IService/VerifyOTP_BNCMC",
      "Accept-Encoding": "gzip, deflate",
      "Accept": "*/*",
      "Connection": "Keep-Alive",
      "User-Agent": "ksoap2-android/2.5.8",
      "Host": "bhiwandicorporation.in",
    };

    try {
      final response = await http.post(url, headers: headers, body: body);
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        // Use the helper function to extract SuccessCode
        final successCode = extractSuccessCode(response.body);

        print("Success Code: $successCode");

        if (successCode == '9999') {
          return true;
        } else {
          print("OTP Verification failed.");
          return false;
        }
      } else {
        throw Exception('Failed to verify OTP: ${response.statusCode}');
      }
    } catch (e) {
      print("Exception while verifying OTP: $e");
      return false;
    }
  }
  //////////////////////////
  ///
  ///
  ///
  ///
  ///

  Future<String?> sendOtpForRegisteredUser(UserDetails user) async {
    final String soapEnvelope =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
    <soapenv:Header/>
    <soapenv:Body>
      <tem:Registration_BNCMC>
        <tem:FirstName>${user.firstName}</tem:FirstName>
        <tem:LastName>${user.lastName}</tem:LastName>
        <tem:Email>${user.email}</tem:Email>
        <tem:MobileNo>${user.mobileNo}</tem:MobileNo>
        <tem:AdharNo>${user.adharNo}</tem:AdharNo>
        <tem:BloodGroup>${user.bloodGroup}</tem:BloodGroup>
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
