import 'package:bncmc/commonwidgets/appbar_static.dart';
import 'package:bncmc/commonwidgets/gradient_container.dart';
import 'package:bncmc/register/model/user_details.dart';
import 'package:bncmc/register/widget/textfield.dart';
import 'package:bncmc/repository/update_profile_repository.dart';
import 'package:bncmc/repository/user_details_repository.dart';
import 'package:bncmc/update_profile/widget/success_dialog.dart';
import 'package:flutter/material.dart';

class UpdateProfileScreen extends StatefulWidget {
  final UserDetails userDetails;
  final Function(UserDetails) onUserDetailsUpdated;

  const UpdateProfileScreen({
    super.key,
    required this.userDetails,
    required this.onUserDetailsUpdated,
  });

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstName;
  late TextEditingController _lastName;
  late TextEditingController _email;
  late TextEditingController _mobile;
  late TextEditingController _aadhar;

  String? _selectedBloodGroup;

  final List<String> bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  @override
  void initState() {
    super.initState();

    _firstName = TextEditingController(
      text: widget.userDetails.firstName ?? '',
    );
    _lastName = TextEditingController(text: widget.userDetails.lastName ?? '');
    _email = TextEditingController(text: widget.userDetails.email ?? '');
    _mobile = TextEditingController(text: widget.userDetails.mobileNo ?? '');
    _aadhar = TextEditingController(text: widget.userDetails.adharNo ?? '');
    _selectedBloodGroup = widget.userDetails.bloodGroup;
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _mobile.dispose();
    _aadhar.dispose();
    super.dispose();
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final repo = UpdateProfileRepository();

      final isSuccess = await repo.updateUserDetails(
        firstName: _firstName.text.trim(),
        lastName: _lastName.text.trim(),
        email: _email.text.trim(),
        mobileNo: _mobile.text.trim(),
        aadharNo: _aadhar.text.trim(),
        bloodGroup: _selectedBloodGroup ?? '',
      );

      if (context.mounted) {
        if (isSuccess) {
          widget.userDetails.firstName = _firstName.text;
          widget.userDetails.lastName = _lastName.text;
          widget.userDetails.email = _email.text;
          widget.userDetails.mobileNo = _mobile.text;
          widget.userDetails.adharNo = _aadhar.text;
          widget.userDetails.bloodGroup = _selectedBloodGroup ?? '';

          // Pass the updated details back to the home screen using the callback
          widget.onUserDetailsUpdated(widget.userDetails);
          showDialog(context: context, builder: (_) => const SuccessDialog());
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Update failed. Please try again.')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarStatic(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GradientContainer(text: 'Update Profile'),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      buildTextField(
                        controller: _firstName,
                        label: 'First Name',
                      ),
                      buildTextField(controller: _lastName, label: 'Last Name'),
                      buildTextField(
                        controller: _email,
                        label: 'Email',
                        inputType: TextInputType.emailAddress,
                      ),
                      buildTextField(
                        controller: _mobile,
                        label: 'Mobile',
                        inputType: TextInputType.phone,
                      ),
                      buildTextField(
                        controller: _aadhar,
                        label: 'Aadhar Number',
                        inputType: TextInputType.number,
                        isRequired: false,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Blood Group',
                          border: OutlineInputBorder(),
                        ),
                        value: _selectedBloodGroup,
                        items:
                            bloodGroups.map((group) {
                              return DropdownMenuItem(
                                value: group,
                                child: Text(group),
                              );
                            }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedBloodGroup = value;
                          });
                        },
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _saveProfile();
                          }
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
