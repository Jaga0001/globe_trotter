import 'package:flutter/material.dart';
import 'package:globe_trotter/screens/login_screen.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Color scheme from the login image
  static const Color primaryPurple = Color(0xFF7B6B8D);
  static const Color darkPurple = Color(0xFF5D4E6D);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Globe Trotter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const LoginScreen(),
    );
  }
}
