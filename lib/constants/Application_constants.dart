import 'package:flutter/services.dart';

class ApplicationConstant {
  static const String PB = "PB";

  static const String VERSION = "2.0";

  static const String URL = "http://bhiwandicorporation.in/Service.svc";

  static String strIMEIID = "";
  static const String MOBILENO = "mobileNo";
  static const String USERNAME = "username";
  static const String EMAILID = "emailId";
  static const String UNIQUEID = "uniqueid";

  static const String RTS = "RTS";
  static const String ET = "ET";

  static const String RTSURL = "http://rtsbncmc.in/";

  static const String ETENDERS = "https://mahatenders.gov.in/nicgep/app";

  static const String PROPERTY_URL =
      "http://propertytax.bhiwandicorporation.in/BNCMCPGApp/ViewBill.aspx";
  static const String PROPERTY_PAY_URL =
      "http://propertytax.bhiwandicorporation.in/BNCMCPGApp/PayBill.aspx";
  static const String DOWNLOAD_REC_URL =
      "http://propertytax.bhiwandicorporation.in/BNCMCPGApp/RecDownload.aspx";

  static const String AB = "AB";
  static const String CL = "CL";
  static const String OL = "OL";
  static const String CM = "CM";
  static const String MM = "MM";
  static const String SC = "SC";
  static const String WEBPAGE = "webpage";

  static const String ABOUTMSG =
      "http://propertytax.bhiwandicorporation.in/BNCMCPGApp/Transaction/FrmAboutMsg.aspx";
  static const String COMMISSIONMSG =
      "http://propertytax.bhiwandicorporation.in/BNCMCPGApp/Transaction/FrmCommissionerMsg.aspx";
  static const String MAYORMSG =
      "http://propertytax.bhiwandicorporation.in/BNCMCPGApp/Transaction/FrmMayorMsg.aspx";
  static const String CORPORATORLIST =
      "http://propertytax.bhiwandicorporation.in/BNCMCPGApp/Transaction/FrmOfficerList.aspx?@=2";
  static const String OFFICERLIST =
      "http://propertytax.bhiwandicorporation.in/BNCMCPGApp/Transaction/FrmOfficerList.aspx?@=1";
  static const String SCHEMELIST =
      "http://propertytax.bhiwandicorporation.in/BNCMCPGApp/Transaction/FrmSchemeList.aspx";

  static const String COMPLAINT_NO_KEY = "complaint_no_key";

  /// Text validation for Landmark (addressFilter)
  static final List<TextInputFormatter> addressInputFormatter = [
    FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z0-9\-:., ]")),
  ];
}
