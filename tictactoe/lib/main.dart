import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tictactoe/bloc/game_bloc.dart';
import 'package:tictactoe/bloc_observer.dart';
import 'package:tictactoe/loading_screen.dart';

void main() {
  Bloc.observer = const AppBlocObserver();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GameBloc(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoadingScreen(),
      ),
    );
  }
}
