import 'package:bncmc/home/widgets/appbar.dart';
import 'package:bncmc/home/widgets/homecards.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // Space between cards
            children: [
              // Card for Mayor Message
              Expanded(
                child: CardItem(
                  imagePath: 'assets/drawable/m_msg_new.png', // Path to image
                  label: 'Mayor Message',
                  onTap: () {
                    // Handle onTap action
                    print('Mayor Message clicked');
                  },
                ),
              ),
              SizedBox(width: 16), // Spacer between cards
              // Card for Commissioner Message
              Expanded(
                child: CardItem(
                  imagePath:
                      'assets/drawable/commissioner.png', // Path to image
                  label: 'Commissioner Message',
                  onTap: () {
                    // Handle onTap action
                    print('Commissioner Message clicked');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
