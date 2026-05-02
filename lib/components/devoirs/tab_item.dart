import 'package:flutter/material.dart';

class TabItem extends StatelessWidget {
  final String text;
  final bool active;

  const TabItem({super.key, 
    required this.text,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: active ? Colors.orange : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: active ? Colors.white : Colors.orange,
        ),
      ),
    );
  }
}