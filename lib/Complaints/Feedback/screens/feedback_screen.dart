import 'package:bncmc/Complaints/Feedback/repository/feedback_repository.dart';
import 'package:bncmc/commonwidgets/appbar_static.dart';
import 'package:bncmc/commonwidgets/gradient_container.dart';
import 'package:bncmc/register/model/user_details.dart';
import 'package:flutter/material.dart';

class FeedbackScreen extends StatefulWidget {
  final UserDetails userDetails;

  const FeedbackScreen({super.key, required this.userDetails});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _suggestionController = TextEditingController();
  final FeedbackRepository _repository = FeedbackRepository();
  bool _isSubmitting = false;

  Future<void> _submitFeedback() async {
    if (_suggestionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter your suggestion."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    setState(() => _isSubmitting = true);

    final success = await _repository.submitFeedback(
      name: '${widget.userDetails.firstName} ${widget.userDetails.lastName}',
      mobile: widget.userDetails.mobileNo,
      email: widget.userDetails.email,
      suggestion: _suggestionController.text.trim(),
    );

    setState(() => _isSubmitting = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? "Feedback submitted successfully."
              : "Failed to submit feedback.",
        ),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );

    if (success) _suggestionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final name =
        '${widget.userDetails.firstName} ${widget.userDetails.lastName}';
    final phone = widget.userDetails.mobileNo;
    final email = widget.userDetails.email;

    return Scaffold(
      appBar: AppBarStatic(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GradientContainer(text: 'Feedback'),
            const SizedBox(height: 20),
            _buildReadOnlyField("Name", name),
            _buildReadOnlyField("Phone Number", phone),
            _buildReadOnlyField("Email", email),
            TextField(
              controller: _suggestionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Suggestion",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _isSubmitting ? null : _submitFeedback,
                child:
                    _isSubmitting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Submit", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    final TextEditingController controller = TextEditingController(text: value);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: controller, // Set the controller with the provided value
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          hintText: value,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
