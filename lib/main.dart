import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const PixcaraApp());
}

class PixcaraApp extends StatelessWidget {
  const PixcaraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PIXCARA',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}
