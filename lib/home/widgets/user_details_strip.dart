import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class UserInfoStrip extends StatefulWidget {
  final String username;

  const UserInfoStrip({super.key, required this.username});

  @override
  State<UserInfoStrip> createState() => _UserInfoStripState();
}

class _UserInfoStripState extends State<UserInfoStrip> {
  late Timer _timer;
  String _formattedDate = '';
  String _formattedTime = '';

  @override
  void initState() {
    super.initState();
    _updateDateTime();
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _updateDateTime();
    });
  }

  void _updateDateTime() {
    final now = DateTime.now();
    setState(() {
      _formattedDate = DateFormat('dd/MM/yyyy').format(now);
      _formattedTime = DateFormat('hh:mm a').format(now);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22,
      color: Color.fromRGBO(16, 42, 77, 1),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Text(
            'Date: $_formattedDate',
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
          const SizedBox(width: 10),
          Text(
            'Time: $_formattedTime',
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
          const Spacer(),
          Text(
            'Welcome: ${widget.username}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
