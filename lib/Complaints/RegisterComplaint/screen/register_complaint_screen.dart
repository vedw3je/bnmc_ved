// import 'package:bncmc/Complaints/RegisterComplaint/repository/department_repo.dart';
// import 'package:bncmc/Complaints/RegisterComplaint/repository/prabhag_repo.dart';
// import 'package:flutter/material.dart';
// import 'package:bncmc/Complaints/RegisterComplaint/models/prabhag.dart';
// import 'package:bncmc/Complaints/RegisterComplaint/models/department.dart';

// class RegisterComplaintScreen extends StatefulWidget {
//   const RegisterComplaintScreen({super.key});

//   @override
//   State<RegisterComplaintScreen> createState() =>
//       _RegisterComplaintScreenState();
// }

// class _RegisterComplaintScreenState extends State<RegisterComplaintScreen> {
//   late Future<List<Prabhag>> _prabhagFuture;
//   late Future<List<Department>> _departmentFuture;

//   @override
//   void initState() {
//     super.initState();
//     _prabhagFuture = PrabhagRepository().fetchPrabhagList();
//     _departmentFuture = DepartmentRepository().fetchDepartmentList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Register Complaint')),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Prabhag List
//             FutureBuilder<List<Prabhag>>(
//               future: _prabhagFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const CircularProgressIndicator();
//                 } else if (snapshot.hasError) {
//                   return Text('Error: ${snapshot.error}');
//                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Text('No Prabhag data available');
//                 } else {
//                   final prabhagList = snapshot.data!;
//                   return ExpansionTile(
//                     title: const Text('Prabhag List'),
//                     children:
//                         prabhagList
//                             .map(
//                               (prabhag) => ListTile(
//                                 title: Text(prabhag.name),
//                                 subtitle: Text('ID: ${prabhag.id}'),
//                               ),
//                             )
//                             .toList(),
//                   );
//                 }
//               },
//             ),

//             // Department List
//             FutureBuilder<List<Department>>(
//               future: _departmentFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const CircularProgressIndicator();
//                 } else if (snapshot.hasError) {
//                   return Text('Error: ${snapshot.error}');
//                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Text('No Department data available');
//                 } else {
//                   final departmentList = snapshot.data!;
//                   return ExpansionTile(
//                     title: const Text('Department List'),
//                     children:
//                         departmentList
//                             .map(
//                               (department) =>
//                                   ListTile(title: Text(department.name)),
//                             )
//                             .toList(),
//                   );
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
