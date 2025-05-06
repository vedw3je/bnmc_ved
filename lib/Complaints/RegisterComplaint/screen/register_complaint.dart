import 'dart:io';

import 'package:bncmc/Complaints/RegisterComplaint/models/complaint_subtype.dart';
import 'package:bncmc/Complaints/RegisterComplaint/models/complaint_type.dart';
import 'package:bncmc/Complaints/RegisterComplaint/models/department.dart';
import 'package:bncmc/Complaints/RegisterComplaint/models/prabhag.dart';
import 'package:bncmc/Complaints/RegisterComplaint/repository/complaint_subtype_repo.dart';
import 'package:bncmc/Complaints/RegisterComplaint/repository/complaint_type_repo.dart';
import 'package:bncmc/Complaints/RegisterComplaint/repository/department_repo.dart';
import 'package:bncmc/Complaints/RegisterComplaint/repository/prabhag_repo.dart';
import 'package:bncmc/Complaints/RegisterComplaint/widgets/Image_picker.dart';
import 'package:bncmc/Complaints/RegisterComplaint/widgets/custom_button.dart';
import 'package:bncmc/Complaints/RegisterComplaint/widgets/custom_dropdown.dart';
import 'package:bncmc/commonwidgets/appbar_static.dart';
import 'package:bncmc/commonwidgets/gradient_container.dart';
import 'package:flutter/material.dart';

class ComplaintFormScreen extends StatefulWidget {
  const ComplaintFormScreen({super.key});

  @override
  State<ComplaintFormScreen> createState() => _ComplaintFormScreenState();
}

class _ComplaintFormScreenState extends State<ComplaintFormScreen> {
  bool isOnsite = true;

  String? selectedPrabhag;
  String? selectedDepartmentId; // Change to store department ID
  String? selectedComplaintType;
  String? selectedSubType;

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
                  onChanged: (value) {
                    setState(() {
                      selectedPrabhag = value;
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
                      child: Image.asset(
                        'assets/drawable/amrut.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),

                const SizedBox(height: 20),
                // Add your complaint details fields here
                const SizedBox(height: 20),

                Row(
                  children: [
                    CustomButton(
                      text: 'Take Photo',
                      color: Colors.green, // Green button
                      onPressed: () {
                        // Open the ImagePickerWidget to allow the user to take a photo or select from gallery
                        showDialog(
                          context: context,
                          builder:
                              (context) => ImagePickerWidget(
                                onImagePicked: _onImagePicked,
                              ), // Assuming ImagePickerWidget is the widget you've created
                        );
                      },
                    ),
                    const Spacer(),

                    CustomButton(
                      text: 'Submit Complaint',
                      color: Colors.red, // Red button
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // All fields are valid
                          // submitComplaint(); // Your submit logic here
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please fill all required fields'),
                            ),
                          );
                        }
                      },
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
