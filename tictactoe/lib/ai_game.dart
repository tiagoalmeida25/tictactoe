import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tictactoe/bloc/game_bloc.dart';
import 'package:tictactoe/components/board.dart';

class AIGame extends StatefulWidget {
  const AIGame({super.key});

  @override
  State<AIGame> createState() => _AIGameState();
}

enum Player { X, O }

class _AIGameState extends State<AIGame> {
  String playerTurn = 'X';
  int aiMove = -1;
  String assistantMessage = '';
  int retry = 0;

  @override
  void initState() {
    super.initState();

    playerTurn = Player.values[Random().nextInt(Player.values.length)].toString().split('.').last;
    print('player is $playerTurn');
    if (playerTurn == 'O') {
      startGame();
    }
  }

  void startGame() async {
    context.read<GameBloc>().add(CalculateMinimax(context.read<GameBloc>().state.board, playerTurn));
  }

  Widget result(state) {
    switch (state.winner) {
      case 'X':
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (state.winner == playerTurn)
              Icon(Icons.person, color: playerTurn == 'X' ? Colors.green : Colors.blue, size: 30)
            else
              Icon(Icons.computer, color: playerTurn == 'X' ? Colors.blue : Colors.green, size: 30),
            Text(
              ' wins!',
              style: GoogleFonts.pressStart2p(fontSize: 20, color: Colors.white),
            ),
          ],
        );
      case 'O':
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (state.winner == playerTurn)
              Icon(Icons.person, color: playerTurn == 'X' ? Colors.green : Colors.blue, size: 30)
            else
              Icon(Icons.computer, color: playerTurn == 'X' ? Colors.blue : Colors.green, size: 30),
            Text(
              ' wins!',
              style: GoogleFonts.pressStart2p(fontSize: 20, color: Colors.white),
            ),
          ],
        );
      default:
        return Text(
          'Draw!',
          style: GoogleFonts.pressStart2p(fontSize: 20, color: Colors.white),
        );
    }
  }

  Widget turn(state) {
    if (state.turn == playerTurn) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person, color: playerTurn == 'X' ? Colors.green : Colors.blue, size: 30),
          Text(
            ' turn',
            style: GoogleFonts.pressStart2p(fontSize: 20, color: Colors.white),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.computer, color: playerTurn == 'X' ? Colors.blue : Colors.green, size: 30),
          Text(
            ' turn',
            style: GoogleFonts.pressStart2p(fontSize: 20, color: Colors.white),
          ),
        ],
      );
    }

    // else {
    //     return Row(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         const Icon(Icons.circle, color: Colors.blue, size: 30),
    //         Text(
    //           ' turn',
    //           style: GoogleFonts.pressStart2p(fontSize: 20, color: Colors.white),
    //         ),
    //       ],
    //     );
    //   }
    // }
    // return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GameBloc, GameState>(
      listener: (context, state) async {
        if (!state.board.any((square) => square != '')) {
          if (state.winner == '') {
            setState(() {
              playerTurn = Player.values[Random().nextInt(Player.values.length)].toString().split('.').last;
            });
            if (playerTurn == 'O') {
              context.read<GameBloc>().add(CalculateMinimax(context.read<GameBloc>().state.board, playerTurn));
            }
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color.fromRGBO(10, 10, 10, 1),
          body: Padding(
            padding: const EdgeInsets.only(top: 72, left: 16, right: 16, bottom: 16),
            child: Center(
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 30),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      Text(
                        'TicTacToe',
                        style: GoogleFonts.pressStart2p(fontSize: 25, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 36),
                  if (state.winner != '') result(state) else turn(state),
                  const SizedBox(height: 64),
                  Board(
                      context: context,
                      state: state,
                      playerTurn: playerTurn == state.turn),
                  const SizedBox(height: 72),
                  SizedBox(
                    width: 100,
                    height: 50,
                    child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          context.read<GameBloc>().add(GameResetRequested());
                        },
                        child: const Text('Restart', style: TextStyle(fontSize: 20, color: Colors.black))),
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
