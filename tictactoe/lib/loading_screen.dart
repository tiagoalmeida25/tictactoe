import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tictactoe/bloc/game_bloc.dart';
import 'package:tictactoe/friend_game.dart';
import 'package:tictactoe/game.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GameBloc, GameState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color.fromRGBO(10, 10, 10, 1),
          body: Padding(
            padding: const EdgeInsets.only(top: 72, left: 16, right: 16, bottom: 16),
            child: Center(
              child: Column(
                children: [
                  Text(
                    'TicTacToe',
                    style: GoogleFonts.pressStart2p(fontSize: 30, color: Colors.white),
                  ),
                  const SizedBox(height: 36),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Play vs:',
                              style: GoogleFonts.pressStart2p(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: () {
                                context.read<GameBloc>().add(const GameStarted('1P'));
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (context) => const Game()));
                              },
                              child: Text(
                                'Computer',
                                style: GoogleFonts.pressStart2p(
                                    color: Colors.white,
                                    fontSize: 20,
                                    letterSpacing: 2,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                context.read<GameBloc>().add(const GameStarted('2P'));
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (context) => const Game()));
                              },
                              child: Text(
                                'Human',
                                style: GoogleFonts.pressStart2p(
                                    color: Colors.white,
                                    fontSize: 20,
                                    letterSpacing: 2,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                context.read<GameBloc>().add(const GameStarted('GPT'));
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (context) => const Game()));
                              },
                              child: Text(
                                'ChatGPT',
                                style: GoogleFonts.pressStart2p(
                                    color: Colors.white,
                                    fontSize: 20,
                                    letterSpacing: 2,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (context) => const FriendGame()));
                              },
                              child: Text(
                                'Friend',
                                style: GoogleFonts.pressStart2p(
                                    color: Colors.white,
                                    fontSize: 20,
                                    letterSpacing: 2,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
