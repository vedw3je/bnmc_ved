import 'package:bncmc/Complaints/TrackMyComplaint/model/complaint_details.dart';
import 'package:bncmc/Complaints/TrackMyComplaint/repository/complaint_details_repo.dart';
import 'package:bncmc/Complaints/TrackMyComplaint/widgets/gradient_complaint_container.dart';
import 'package:bncmc/commonwidgets/appbar_static.dart';
import 'package:bncmc/commonwidgets/gradient_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For setting the orientation

class ComplaintDetailsScreen extends StatefulWidget {
  final String complaintNo;

  const ComplaintDetailsScreen({super.key, required this.complaintNo});

  @override
  State<ComplaintDetailsScreen> createState() => _ComplaintDetailsScreenState();
}

class _ComplaintDetailsScreenState extends State<ComplaintDetailsScreen> {
  late Future<List<ComplaintDetails>> _complaintDetails;

  @override
  void initState() {
    super.initState();
    // Force landscape orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    _complaintDetails = TrackComplaintDetailsRepo().getComplaintDetails(
      complaintNo: widget.complaintNo,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarStatic(),
      body: FutureBuilder<List<ComplaintDetails>>(
        future: _complaintDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No complaint details found.'));
          } else {
            final complaintDetails = snapshot.data!;

            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: GradientComplaintContainer(
                      complaintNumber: widget.complaintNo,
                    ),
                  ),

                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: DataTable(
                      headingRowColor: WidgetStateColor.resolveWith(
                        (states) => Colors.blueGrey.shade100,
                      ),

                      dataRowHeight: 35,
                      columns: const [
                        DataColumn(
                          label: VerticalDividerWidget(text: 'Status Date'),
                        ),
                        DataColumn(
                          label: VerticalDividerWidget(text: 'Status'),
                        ),
                        DataColumn(
                          label: VerticalDividerWidget(text: 'Remark'),
                        ),
                      ],
                      rows:
                          complaintDetails.map((complaint) {
                            return DataRow(
                              cells: [
                                DataCell(
                                  ColumnDividerWrapper(
                                    text: complaint.statusDate,
                                  ),
                                ),
                                DataCell(
                                  ColumnDividerWrapper(text: complaint.status),
                                ),
                                DataCell(
                                  ColumnDividerWrapper(text: complaint.remark),
                                ),
                              ],
                            );
                          }).toList(),
                    ),
                  ),
                  const Divider(thickness: 1, color: Colors.grey, height: 1),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class VerticalDividerWidget extends StatelessWidget {
  final String text;
  const VerticalDividerWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min, // Prevents unbounded width
      children: [
        VerticalDivider(thickness: 1, color: Colors.grey),
        const SizedBox(width: 4),
        Text(text),
      ],
    );
  }
}

class ColumnDividerWrapper extends StatelessWidget {
  final String text;
  const ColumnDividerWrapper({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min, // Critical fix here
      children: [
        VerticalDivider(thickness: 1, color: Colors.grey),
        const SizedBox(width: 4),
        Text(text),
      ],
    );
  }
}
