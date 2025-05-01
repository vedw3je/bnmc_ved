import 'package:xml/xml.dart';

class UserDetails {
  final String firstName;
  final String lastName;
  final String email;
  final String mobileNo;
  final String adharNo;
  final String bloodGroup;

  UserDetails({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.mobileNo,
    required this.adharNo,
    required this.bloodGroup,
  });

  factory UserDetails.fromXml(String xmlString) {
    final document = XmlDocument.parse(xmlString);
    final header = document.findAllElements('ResponseHeader').first;

    String _get(String tag) =>
        header.findElements(tag).isNotEmpty
            ? header.findElements(tag).first.text
            : '';

    return UserDetails(
      firstName: _get('FirstName'),
      lastName: _get('LastName'),
      email: _get('Email'),
      mobileNo: _get('Mobile'),
      adharNo: _get('Adhar'),
      bloodGroup: _get('BloodGroup'),
    );
  }
}
