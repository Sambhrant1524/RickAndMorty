import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:taskapp/blocs/character_event.dart';
import 'screens/explore_feed_screen.dart';
import 'repositories/character_repository.dart';
import 'blocs/character_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rick and Morty Explorer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: RepositoryProvider(
        create: (context) => CharacterRepository(httpClient: http.Client()),
        child: BlocProvider(
          create: (context) => CharacterBloc(
            characterRepository: context.read<CharacterRepository>(),
          )..add(CharacterFetched()),
          child: const ExploreFeedScreen(),
        ),
      ),
    );
  }
}