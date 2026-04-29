import 'package:flutter/material.dart';

class CountdownTimer extends StatelessWidget {
  const CountdownTimer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 140,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Cercle de progression orange
          SizedBox(
            width: 140,
            height: 140,
            child: CircularProgressIndicator(
              value: 0.65,
              strokeWidth: 8,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF6B35)),
            ),
          ),
          // Texte du timer
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                '12:45',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A3C4D),
                ),
              ),
              Text(
                'MINUTES',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}