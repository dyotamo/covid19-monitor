import 'package:covid19/src/screens/home.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Covid19 Monitor',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xFF1A237E),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF1A237E),
          primary: Color(0xFF1A237E),
          secondary: Color(0xFF0D47A1),
        ),
        scaffoldBackgroundColor: Color(0xFFF5F7FA),
        textTheme: TextTheme(
          headlineSmall: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A237E),
          ),
          titleMedium: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
