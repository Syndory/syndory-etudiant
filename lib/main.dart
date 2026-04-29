import 'package:flutter/material.dart';
import 'package:syndory_etudiant/screens/dashboard/dashboard_page.dart';
import 'features/calendar/calendar_page.dart';
import 'screens/seances_en_cours/en_cours_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tableau de Bord Étudiant',
      debugShowCheckedModeBanner: false, // Enlève la petite bannière "Debug"
      theme: ThemeData(
        // On utilise un thème clair et propre
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFF06424)),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      // On affiche directement notre page de tableau de bord
      //home: const DashboardPage(),
      //home: CalendarPage(),
      home: const EnCoursScreen(),
    );
  }
}