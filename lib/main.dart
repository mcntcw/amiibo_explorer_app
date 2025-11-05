import 'package:amiibo_explorer_app/core/data/http_amiibo_repository.dart';
import 'package:amiibo_explorer_app/core/data/network/amiibo_remote_data_source.dart';
import 'package:amiibo_explorer_app/details/presentation/view/screens/details_screen.dart';
import 'package:amiibo_explorer_app/search/presentation/bloc/search_bloc.dart';
import 'package:amiibo_explorer_app/search/presentation/view/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: [
        GetPage(name: '/amiibo-details', page: () => AmiiboDetailsScreen()),
      ],
      debugShowCheckedModeBanner: false,
      title: 'Amiibo Explorer',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          surface: Color(0xFFD8DFE1),
          primary: Color.fromARGB(255, 208, 216, 218),
          onSurface: Color(0xFF161616),
          error: Color.fromARGB(255, 215, 14, 14),
        ),
        fontFamily: 'ClashGrotesk',
      ),
      home: BlocProvider(
        create: (context) => SearchBloc(
          amiiboRepository: HttpAmiiboRepository(AmiiboRemoteDataSource()),
        ),
        child: const SearchScreen(),
      ),
    );
  }
}
