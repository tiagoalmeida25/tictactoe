import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tictactoe/bloc/game_bloc.dart';
import 'package:tictactoe/bloc_observer.dart';
import 'package:tictactoe/firebase_options.dart';
import 'package:tictactoe/loading_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const AppBlocObserver();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
