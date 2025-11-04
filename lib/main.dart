import 'package:amiibo_explorer_app/search/presentation/view/screens/search_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          surface: Color(0xFFF4F2F7),
          primary: Color.fromARGB(255, 226, 226, 226),
          onSurface: Color(0xFF161616),
          error: Color.fromARGB(255, 114, 44, 44),
        ),

        fontFamily: 'Switzer',
      ),
      home: const SearchScreen(),
    );
  }
}
