import 'package:amiibo_explorer_app/core/data/amiibo_repository_impl.dart';
import 'package:amiibo_explorer_app/core/data/network/amiibo_remote_data_source.dart';
import 'package:amiibo_explorer_app/core/domain/amiibo_repository.dart';
import 'package:amiibo_explorer_app/search/presentation/bloc/search_bloc.dart';
import 'package:amiibo_explorer_app/search/presentation/view/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      title: 'Amiibo Explorer',
      // theme: ThemeData(
      //   colorScheme: const ColorScheme.light(
      //     surface: Color.fromARGB(255, 238, 236, 240),
      //     primary: Color.fromARGB(255, 226, 226, 226),
      //     onSurface: Color(0xFF161616),
      //     error: Color.fromARGB(255, 215, 14, 14),
      //   ),
      // ),
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
          surface: Color.fromARGB(255, 50, 48, 52),
          primary: Color.fromARGB(255, 34, 34, 34),
          onSurface: Color.fromARGB(255, 219, 219, 219),
          error: Color.fromARGB(255, 215, 14, 14),
        ),
      ),
      home: BlocProvider(
        create: (context) => SearchBloc(
          amiiboRepository: AmiiboRepositoryImpl(AmiiboRemoteDataSource()),
        ),
        child: const SearchScreen(),
      ),
    );
  }
}
