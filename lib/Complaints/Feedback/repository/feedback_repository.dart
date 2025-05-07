import 'dart:developer';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

class FeedbackRepository {
  final String baseUrl = "http://bhiwandicorporation.in/Service.svc";

  Future<bool> submitFeedback({
    required String name,
    required String mobile,
    required String email,
    required String suggestion,
  }) async {
    const String soapAction = "http://tempuri.org/IService/Feedback_BNCMC";

    final String soapEnvelope = '''
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
  <soapenv:Header/>
  <soapenv:Body>
    <tem:Feedback_BNCMC>
      <tem:Name>$name</tem:Name>
      <tem:MobileNo>$mobile</tem:MobileNo>
      <tem:EmailId>$email</tem:EmailId>
      <tem:Suggestion>$suggestion</tem:Suggestion>
    </tem:Feedback_BNCMC>
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
            doc.findAllElements('Feedback_BNCMCResult').first.innerText;

        log("Raw Feedback Result: $rawResult");

        // Optional: decode HTML entities like &lt;SuccessCode&gt;
        final unescaped = HtmlUnescape().convert(rawResult);

        return unescaped.contains('<SuccessCode>9999</SuccessCode>');
      } else {
        log("❌ Server error: ${response.statusCode}");
      }
    } catch (e) {
      log("Exception during submitFeedback: $e");
    }

    return false;
  }
}
