import 'package:flutter/material.dart';

import 'firstScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Generate a 128-bit (16-byte) IV

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.white,
          colorSchemeSeed: Colors.lightBlue,
          listTileTheme: const ListTileThemeData(iconColor: Colors.black)),
      debugShowCheckedModeBanner: false,
      home: const FirstScreen(),
    );
  }
}
