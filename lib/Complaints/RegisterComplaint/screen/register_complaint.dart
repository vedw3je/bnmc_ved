import 'dart:convert';
import 'dart:io';

import 'package:bncmc/Complaints/RegisterComplaint/models/complaint_response.dart';
import 'package:bncmc/Complaints/RegisterComplaint/models/complaint_subtype.dart';
import 'package:bncmc/Complaints/RegisterComplaint/models/complaint_type.dart';
import 'package:bncmc/Complaints/RegisterComplaint/models/department.dart';
import 'package:bncmc/Complaints/RegisterComplaint/models/prabhag.dart';
import 'package:bncmc/Complaints/RegisterComplaint/repository/complaint_subtype_repo.dart';
import 'package:bncmc/Complaints/RegisterComplaint/repository/complaint_type_repo.dart';
import 'package:bncmc/Complaints/RegisterComplaint/repository/department_repo.dart';
import 'package:bncmc/Complaints/RegisterComplaint/repository/prabhag_repo.dart';
import 'package:bncmc/Complaints/RegisterComplaint/repository/submit_complaint_repo.dart';
import 'package:bncmc/Complaints/RegisterComplaint/widgets/Image_picker.dart';
import 'package:bncmc/Complaints/RegisterComplaint/widgets/custom_button.dart';
import 'package:bncmc/Complaints/RegisterComplaint/widgets/custom_dropdown.dart';
import 'package:bncmc/Complaints/RegisterComplaint/widgets/register_dialog.dart';
import 'package:bncmc/commonwidgets/appbar_static.dart';
import 'package:bncmc/commonwidgets/gradient_container.dart';
import 'package:bncmc/register/model/user_details.dart';
import 'package:flutter/material.dart';

class ComplaintFormScreen extends StatefulWidget {
  final UserDetails userDetails;
  const ComplaintFormScreen({super.key, required this.userDetails});

  @override
  State<ComplaintFormScreen> createState() => _ComplaintFormScreenState();
}

class _ComplaintFormScreenState extends State<ComplaintFormScreen> {
  bool isOnsite = true;
  bool isLoading = false;
  String? selectedPrabhag;
  String? selectedDepartmentId; // Change to store department ID
  String? selectedComplaintType;
  String? selectedSubType;
  TextEditingController complaintdetailscontroller = TextEditingController();
  TextEditingController landmarkcontroller = TextEditingController();

  late Future<List<Prabhag>> prabhagList;
  late Future<List<Department>> departmentList;
  late Future<List<ComplaintType>> complaintTypeList = Future.value(
    [],
  ); // Initialized with empty list
  late Future<List<ComplaintSubType>> subTypeList = Future.value(
    [],
  ); // Initialized with empty list

  @override
  void initState() {
    prabhagList = PrabhagRepository().fetchPrabhagList();
    departmentList = DepartmentRepository().fetchDepartmentList();
    super.initState();
  }

  Future<void> fetchComplaintTypes(String departmentId) async {
    setState(() {
      complaintTypeList = ComplaintTypeRepository().fetchComplaintTypes(
        departmentId,
      );
    });
  }

  // Fetch Complaint Subtypes based on selected Complaint Type
  Future<void> fetchSubTypes(String complaintTypeId) async {
    setState(() {
      subTypeList = ComplaintSubtypeRepository().fetchComplaintSubTypes(
        complaintTypeId,
      );
    });
  }

  final _formKey = GlobalKey<FormState>();
  File? _pickedImage; // Store the picked image

  // Handle image picked from ImagePickerWidget
  void _onImagePicked(File image) {
    setState(() {
      _pickedImage = image;
    });
    Navigator.pop(context);
  }

  void _submitComplaint() async {
    setState(() {
      isLoading = true;
    });

    try {
      String base64Image = "";
      if (_pickedImage != null) {
        final bytes = await _pickedImage!.readAsBytes();
        base64Image = base64Encode(bytes);
      }
      ComplaintResponseModel?
      response = await RegisterComplaintRepository().submitComplaint(
        departmentId: selectedDepartmentId.toString(),
        complaintTypeId: selectedComplaintType.toString(),
        complaintSubTypeId: selectedSubType.toString(),
        customerName:
            '${widget.userDetails.firstName} ${widget.userDetails.lastName}',
        mobileNo: widget.userDetails.mobileNo,
        complaint: complaintdetailscontroller.text,
        imageBase64: base64Image,
        email: widget.userDetails.email,
        landmark: landmarkcontroller.text,
        prabhagId: selectedPrabhag.toString(),
        complaintPlace: isOnsite ? "ONSITE" : "OFFSITE",
      );

      if (response != null) {
        complaintdetailscontroller.clear();
        landmarkcontroller.clear();
        setState(() {
          selectedDepartmentId = null;
          selectedComplaintType = null;
          selectedSubType = null;
          selectedPrabhag = null;
          _pickedImage = null;
          isOnsite = false;
        });

        showDialog(
          context: context,
          builder:
              (context) =>
                  RegisterDialog(complainNumber: response.complaintNumber),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to submit complaint.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    complaintdetailscontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarStatic(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GradientContainer(text: 'Complaint Registration'),
                const SizedBox(height: 10),
                // Switch
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400, width: 1.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(6),
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Text('Complaint Mode:'),
                      const SizedBox(width: 20),
                      Text(
                        isOnsite ? 'ONSITE' : 'OFFSITE',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Spacer(),
                      Switch(
                        value: isOnsite,
                        onChanged: (val) {
                          setState(() {
                            isOnsite = val;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                // Prabhag Dropdown
                CustomDropdownField(
                  label: 'Select Prabhag',
                  itemsFuture: prabhagList.then(
                    (list) => list.map((e) => MapEntry(e.id, e.name)).toList(),
                  ),
                  initialSelectedValue: selectedPrabhag,
                  validator:
                      (value) =>
                          value == null ? 'Please select a Prabhag' : null,
                  onChanged: (id) {
                    setState(() {
                      selectedPrabhag = id;
                    });
                  },
                ),

                // Department Dropdown
                CustomDropdownField(
                  label: 'Select Department',
                  itemsFuture: departmentList.then(
                    (list) => list.map((e) => MapEntry(e.id, e.name)).toList(),
                  ),
                  initialSelectedValue: selectedDepartmentId,
                  validator:
                      (value) =>
                          value == null ? 'Please select a department' : null,
                  onChanged: (id) async {
                    setState(() {
                      selectedDepartmentId = id;
                      selectedComplaintType = "";
                      selectedSubType = "";
                      subTypeList = Future.value([]);
                    });
                    fetchComplaintTypes(id!);
                  },
                ),

                // Complaint Type Dropdown
                CustomDropdownField(
                  label: 'Select Complaint Type',
                  itemsFuture: complaintTypeList.then(
                    (list) => list.map((e) => MapEntry(e.id, e.name)).toList(),
                  ),
                  initialSelectedValue: selectedComplaintType,
                  validator:
                      (value) =>
                          value == null
                              ? 'Please select a complaint type'
                              : null,
                  onChanged: (value) {
                    setState(() {
                      selectedComplaintType = value;
                      fetchSubTypes(value!);
                      selectedSubType = "";
                    });
                  },
                ),

                // Complaint SubType Dropdown
                CustomDropdownField(
                  label: 'Select Sub Type',
                  itemsFuture: subTypeList.then(
                    (list) => list.map((e) => MapEntry(e.id, e.name)).toList(),
                  ),
                  initialSelectedValue: selectedSubType,
                  validator:
                      (value) =>
                          value == null ? 'Please select a sub type' : null,
                  onChanged: (value) {
                    setState(() {
                      selectedSubType = value;
                    });
                  },
                ),

                GradientContainer(text: 'Complaint Details'),
                const SizedBox(height: 10),
                // Complaint Details TextField
                TextFormField(
                  controller: complaintdetailscontroller,
                  maxLength: 1000,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Complaint Details',
                    hintText: 'Enter your complaint details here',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter complaint details!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: landmarkcontroller,
                  decoration: const InputDecoration(
                    labelText: 'LandMark',
                    hintText: 'Enter your Land Mark here.',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Land Mark!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 5),
                _pickedImage != null
                    ? Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Image.file(_pickedImage!, fit: BoxFit.cover),
                      ),
                    )
                    : Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.image, size: 50),
                      ),
                    ),

                const SizedBox(height: 20),
                // Add your complaint details fields here
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        isLoading: false,
                        text: 'Take Photo',
                        color: Colors.green,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder:
                                (context) => ImagePickerWidget(
                                  onImagePicked: _onImagePicked,
                                ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16), // Space between buttons
                    Expanded(
                      child: CustomButton(
                        isLoading: isLoading,
                        text: 'Submit Complaint',
                        color: Colors.red,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _submitComplaint();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please fill all required fields',
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
