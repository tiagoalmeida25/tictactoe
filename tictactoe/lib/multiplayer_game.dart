import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tictactoe/bloc/game_bloc.dart';
import 'package:tictactoe/components/board.dart';

class MultiplayerGame extends StatefulWidget {
  const MultiplayerGame({super.key});

  @override
  State<MultiplayerGame> createState() => _MultiplayerGameState();
}

enum Player { X, O }

class _MultiplayerGameState extends State<MultiplayerGame> {
  String playerTurn = 'X';
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();

    final player = context.read<GameBloc>().state.player;

    if (player == '1') {
      playerTurn = 'X';
    } else {
      playerTurn = 'O';
    }
    final room = context.read<GameBloc>().state.roomID;

    _subscription = FirebaseFirestore.instance
        .collection('rooms')
        .doc(room)
        .snapshots()
        .listen((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        context.read<GameBloc>().add(GameRefreshed(room!));
      }
    });
  }

  void cancelSubscription() {
    _subscription?.cancel();
  }

  @override
  void dispose() {
    cancelSubscription();
    context.read()<GameBloc>().add(ExitGame());
    super.dispose();
  }

  Widget result(state) {
    switch (state.winner) {
      case 'X':
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.square_rounded, color: Colors.green, size: 30),
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
            const Icon(Icons.circle, color: Colors.blue, size: 30),
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
    if (playerTurn == state.turn) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Your turn: ',
            style: GoogleFonts.pressStart2p(fontSize: 15, color: Colors.white),
          ),
          if (playerTurn == 'X')
            const Icon(Icons.square_rounded, color: Colors.green, size: 30)
          else
            const Icon(Icons.circle, color: Colors.blue, size: 30),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Friend's turn: ",
            style: GoogleFonts.pressStart2p(fontSize: 15, color: Colors.white),
          ),
          if (playerTurn == 'X')
            const Icon(Icons.circle, color: Colors.blue, size: 30)
          else
            const Icon(Icons.square_rounded, color: Colors.green, size: 30),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GameBloc, GameState>(
      listener: (context, state) async {
        if (!state.board.any((square) => square != '')) {
          switch (state.mode) {
            case '1P':
              if (state.winner == '') {
                setState(() {
                  playerTurn =
                      Player.values[Random().nextInt(Player.values.length)].toString().split('.').last;
                });
                if (playerTurn == 'O') {
                  context.read<GameBloc>().add(GameMoveRequested(Random.secure().nextInt(9)));
                }
              }
              break;
          }
        } else {}
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
                            cancelSubscription();
                            Navigator.pop(context);
                          }),
                      Text(
                        'TicTacToe',
                        style: GoogleFonts.pressStart2p(fontSize: 25, color: Colors.white),
                      ),
                      IconButton(
                          icon: const Icon(Icons.replay_outlined, color: Colors.white, size: 30),
                          onPressed: () {
                            context
                                .read<GameBloc>()
                                .add(GameRefreshed(context.read<GameBloc>().state.roomID!));
                          }),
                    ],
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 16),
                      Center(
                          child: Text('Room ID: ${state.roomID}',
                              style: GoogleFonts.pressStart2p(fontSize: 10, color: Colors.grey))),
                    ],
                  ),
                  const SizedBox(height: 36),
                  if (state.winner != '') result(state) else turn(state),
                  const SizedBox(height: 64),
                  Board(context: context, state: state, playerTurn: playerTurn == state.turn),
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
                          context.read<GameBloc>().add(GameResetFriend());
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
