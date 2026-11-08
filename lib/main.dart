import 'package:flutter/material.dart';
import 'views/home_page.dart';

void main() => runApp(const NfvApp());

class NfvApp extends StatelessWidget {
  const NfvApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF1D4ED8);
    return MaterialApp(
      // title: 'NFV-256 Cipher',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: seed, useMaterial3: true),
      darkTheme: ThemeData(
          colorSchemeSeed: seed,
          brightness: Brightness.dark,
          useMaterial3: true),
      home: const HomePage(),
    );
  }
}