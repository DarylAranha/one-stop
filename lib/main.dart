import 'package:flutter/material.dart';
import 'package:one_stop/pages/greeting_page.dart';
import 'package:one_stop/pages/calculator_page.dart';
import 'package:one_stop/pages/weather_page.dart';
import 'package:one_stop/pages/notes_page.dart'; // Import the new NotesPage

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Router App',
      initialRoute: '/',
      routes: {
        '/': (context) => GreetingPage(),
        '/calculator': (context) => CalculatorPage(),
        '/weather': (context) => WeatherPage(),
        '/notes': (context) => NotesPage(), // Add the NotesPage route
      },
    );
  }
}
