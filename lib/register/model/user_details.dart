import 'package:xml/xml.dart';

class UserDetails {
  String firstName;
  String lastName;
  String email;
  String mobileNo;
  String adharNo;
  String bloodGroup;

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

    String get(String tag) =>
        header.findElements(tag).isNotEmpty
            ? header.findElements(tag).first.text
            : '';

    return UserDetails(
      firstName: get('FirstName'),
      lastName: get('LastName'),
      email: get('Email'),
      mobileNo: get('Mobile'),
      adharNo: get('Adhar'),
      bloodGroup: get('BloodGroup'),
    );
  }
}
