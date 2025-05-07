import 'package:bncmc/Complaints/TrackMyComplaint/model/complaint_status.dart';
import 'package:bncmc/Complaints/TrackMyComplaint/repository/track_complaint_repo.dart';
import 'package:bncmc/Complaints/TrackMyComplaint/screen/complaint_details.dart';
import 'package:bncmc/commonwidgets/appbar_static.dart';
import 'package:bncmc/commonwidgets/gradient_container.dart';
import 'package:bncmc/customrouteanimation/fade_slide_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TrackMyComplaint extends StatefulWidget {
  final String phoneNumber;

  const TrackMyComplaint({super.key, required this.phoneNumber});

  @override
  State<TrackMyComplaint> createState() => _TrackMyComplaintState();
}

class _TrackMyComplaintState extends State<TrackMyComplaint> {
  final TrackComplaintRepo _repo = TrackComplaintRepo();
  List<ComplaintStatus> _complaints = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();

    // Lock orientation to landscape
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    fetchComplaints();
  }

  @override
  void dispose() {
    // Reset orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  Future<void> fetchComplaints() async {
    try {
      final result = await _repo.trackComplaintStatus(
        mobileNo: widget.phoneNumber,
      );
      setState(() {
        _complaints = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_error.isNotEmpty) {
      return Scaffold(body: Center(child: Text('Error: $_error')));
    }

    if (_complaints.isEmpty) {
      return const Scaffold(body: Center(child: Text('No complaints found.')));
    }

    return Scaffold(
      appBar: AppBarStatic(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: GradientContainer(text: 'Complaint Status'),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: DataTable(
                headingRowColor: WidgetStateColor.resolveWith(
                  (states) => Colors.blueGrey.shade100,
                ),
                columnSpacing: 8,
                dataRowHeight: 35,
                columns: const [
                  DataColumn(label: Text('Complaint No.')),
                  DataColumn(
                    label: VerticalDividerWidget(text: 'Complaint Type'),
                  ),
                  DataColumn(label: VerticalDividerWidget(text: 'Status')),
                  DataColumn(
                    label: VerticalDividerWidget(text: 'Complaint Date'),
                  ),
                ],
                rows:
                    _complaints.map((complaint) {
                      return DataRow(
                        cells: [
                          DataCell(
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  FadeSlideRoute(
                                    page: ComplaintDetailsScreen(
                                      complaintNo: complaint.complaintNo,
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                complaint.complaintNo ?? '',
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 0, 7, 148),
                                ), // Blue color for text
                              ),
                            ),
                          ),
                          DataCell(
                            ColumnDividerWrapper(
                              text: complaint.complaintType ?? '',
                            ),
                          ),
                          DataCell(
                            ColumnDividerWrapper(text: complaint.status ?? ''),
                          ),
                          DataCell(
                            ColumnDividerWrapper(
                              text: complaint.complaintDate ?? '',
                            ),
                          ),
                        ],
                      );
                    }).toList(),
              ),
            ),
            const Divider(thickness: 1, color: Colors.grey, height: 1),
          ],
        ),
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
      children: [VerticalDivider(thickness: 1, color: Colors.grey), Text(text)],
    );
  }
}

class ColumnDividerWrapper extends StatelessWidget {
  final String text;
  const ColumnDividerWrapper({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        VerticalDivider(thickness: 1, color: Colors.grey),
        Expanded(child: Text(text)),
      ],
    );
  }
}
