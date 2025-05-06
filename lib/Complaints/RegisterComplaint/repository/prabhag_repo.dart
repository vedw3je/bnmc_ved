import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import 'package:bncmc/Complaints/RegisterComplaint/models/prabhag.dart'; // Assuming your Prabhag model is here

class PrabhagRepository {
  final String baseUrl = "http://bhiwandicorporation.in/Service.svc";
  final String _soapAction = "http://tempuri.org/IService/GetPrabhagList_BNCMC";
  final String _method = "GetPrabhagList_BNCMC";
  final String _namespace = "http://tempuri.org/";

  Future<List<Prabhag>> fetchPrabhagList() async {
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

      // log(responseBody);

      // Check for success code
      if (!responseBody.contains("<SuccessCode>9999</SuccessCode>")) {
        final msgStart = responseBody.indexOf("<SuccessMessage>") + 16;
        final msgEnd = responseBody.indexOf("</SuccessMessage>");
        final message = responseBody.substring(msgStart, msgEnd);
        throw Exception("Server error: $message");
      }

      // Extract inner <PrabhagResponse> XML
      final startIndex = responseBody.indexOf("<PrabhagResponse>");
      final endIndex =
          responseBody.indexOf("</PrabhagResponse>") +
          "</PrabhagResponse>".length;
      final innerXml = responseBody.substring(startIndex, endIndex);

      // Parse the XML string
      final document = XmlDocument.parse(innerXml);

      // Extract prabhags
      final prabhagList = <Prabhag>[];
      for (final element in document.findAllElements("Prabhag")) {
        final id = element.findElements("Id").single.text;
        final name = element.findElements("PrabhagName").single.text;
        prabhagList.add(Prabhag(id: id, name: name));
      }

      return prabhagList;
    } else {
      throw Exception("Failed to load Prabhag list");
    }
  }
}
