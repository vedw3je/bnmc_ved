import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class RegisterComplaintRepository {
  final String baseUrl = "http://bhiwandicorporation.in/Service.svc";
  final String _soapAction =
      "http://tempuri.org/IService/RegisterComplaintNew_BNCMC";
  final String _method = "RegisterComplaintNew_BNCMC";
  final String _namespace = "http://tempuri.org/";

  Future<bool> submitComplaint({
    required String departmentId,
    required String complaintTypeId,
    required String complaintSubTypeId,
    required String customerName,
    required String mobileNo,
    required String complaint,
    required String imageBase64,
    required String email,
    required String landmark,
    required String prabhagId,
    required String complaintPlace,
  }) async {
    try {
      // Step 1: Request permission
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        log('Location services are disabled.');
        return false;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          log('Location permission denied.');
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        log('Location permissions are permanently denied.');
        return false;
      }

      // Step 2: Get location
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
      );

      String latitude = position.latitude.toString();
      String longitude = position.longitude.toString();

      // Step 3: Build SOAP envelope
      final soapEnvelope =
          '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="$_namespace">
  <soapenv:Header/>
  <soapenv:Body>
    <tem:$_method>
      <tem:DepartmentId>$departmentId</tem:DepartmentId>
      <tem:ComplaintTypeId>$complaintTypeId</tem:ComplaintTypeId>
      <tem:ComplaintSubTypeId>$complaintSubTypeId</tem:ComplaintSubTypeId>
      <tem:CustomerName>$customerName</tem:CustomerName>
      <tem:MobileNo>$mobileNo</tem:MobileNo>
      <tem:Complaint>$complaint</tem:Complaint>
      <tem:Image>$imageBase64</tem:Image>
      <tem:Email>$email</tem:Email>
      <tem:LandMark>$landmark</tem:LandMark>
      <tem:LongitudeValue>$longitude</tem:LongitudeValue>
      <tem:LatitudeValue>$latitude</tem:LatitudeValue>
      <tem:PrabhagId>$prabhagId</tem:PrabhagId>
      <tem:ComplPlace>$complaintPlace</tem:ComplPlace>
    </tem:$_method>
  </soapenv:Body>
</soapenv:Envelope>''';

      // Step 4: Send request
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          "Content-Type": "text/xml; charset=utf-8",
          "SOAPAction": _soapAction,
        },
        body: utf8.encode(soapEnvelope),
      );

      // Step 5: Handle response
      if (response.statusCode == 200) {
        final responseBody = response.body
            .replaceAll('&lt;', '<')
            .replaceAll('&gt;', '>')
            .replaceAll('&amp;', '&')
            .replaceAll('&#xD;', '');
        log(responseBody);

        if (!responseBody.contains("<SuccessCode>9999</SuccessCode>")) {
          final msgStart = responseBody.indexOf("<SuccessMessage>") + 16;
          final msgEnd = responseBody.indexOf("</SuccessMessage>");
          final message = responseBody.substring(msgStart, msgEnd);
          log("Server error: $message");
          return false;
        }

        log("Complaint submitted successfully.");
        return true;
      } else {
        log("Failed to submit complaint. HTTP ${response.statusCode}");
        return false;
      }
    } catch (e) {
      log("Error: $e");
      return false;
    }
  }
}
