import 'package:flutter/material.dart';
import 'screens/attendance_list_screen.dart'; // Importe le nouvel écran

void main() {
  runApp(const SyndoryApp());
}

class SyndoryApp extends StatelessWidget {
  const SyndoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: const AttendanceListScreen(), // Démarre sur la liste
    );
  }
}