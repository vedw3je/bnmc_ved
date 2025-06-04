import 'package:flutter/material.dart';

class BncmcDesc extends StatelessWidget {
  const BncmcDesc({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(16, 42, 77, 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 11, color: Colors.white, height: 1.4),
            children: const [
              TextSpan(
                text: 'Bhiwandi-Nizampur City Municipal Corporation (BNCMC) ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text:
                    'is a civic body formed after dissolution of "BNCMC" (Bhiwandi-Nizampur-City-Municipal-Council) into a Corporation by an act of Government of Maharashtra in 2002 to administer the industrial township of Bhiwandi, which is a city in Thane district in the Indian state of Maharashtra.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
