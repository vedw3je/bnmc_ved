import 'package:bncmc/commonwidgets/appbar_static.dart';
import 'package:bncmc/commonwidgets/gradient_container.dart';
import 'package:bncmc/register/model/user_details.dart';
import 'package:bncmc/webview/paybill_inapp_webview.dart';
import 'package:flutter/material.dart';

class PayBillScreen extends StatefulWidget {
  final UserDetails? userDetails;
  const PayBillScreen({super.key, required this.userDetails});

  @override
  _PayBillScreenState createState() => _PayBillScreenState();
}

class _PayBillScreenState extends State<PayBillScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _propertyNumberController =
      TextEditingController();

  @override
  void dispose() {
    _propertyNumberController.dispose();
    super.dispose();
  }

  void _searchProperty() {
    if (_formKey.currentState!.validate()) {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder:
      //         (context) => PayBillWebView(
      //           url:
      //               'http://propertytax.bhiwandicorporation.in/BNCMCPGApp/PayBill.aspx',
      //           propertyNumber: _propertyNumberController.text,
      //           phoneNumber: widget.userDetails!.mobileNo,
      //           email: widget.userDetails!.email,
      //         ),
      //   ),
      // );

      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder:
              (_, __, ___) => PayBillInAppWebView(
                url:
                    "http://propertytax.bhiwandicorporation.in/BNCMCPGApp/PayBill.aspx",
                phoneNumber: widget.userDetails!.mobileNo,
                email: widget.userDetails!.email,
                propertyNumber: _propertyNumberController.text,
              ),
          transitionDuration: Duration(milliseconds: 0), // no animation
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarStatic(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GradientContainer(text: 'Search Property No.'),
              const SizedBox(height: 32),
              TextFormField(
                controller: _propertyNumberController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Property Number',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Property Number is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: _searchProperty,
                  style: ElevatedButton.styleFrom(
                    elevation: 6,
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Search Property',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
