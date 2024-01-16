import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tictactoe/bloc/game_bloc.dart';
import 'package:tictactoe/game.dart';

class FriendGame extends StatefulWidget {
  const FriendGame({super.key});

  @override
  State<FriendGame> createState() => _FriendGameState();
}

class _FriendGameState extends State<FriendGame> {
  Widget joinRoomDialog() {
    String value = '';

    return AlertDialog(
      title: const Text('Join Room', style: TextStyle(color: Colors.white)),
      backgroundColor: const Color.fromRGBO(10, 10, 10, 1),
      content: TextField(
        style: const TextStyle(color: Colors.white),
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          hintText: 'Enter Room ID',
          hintStyle: TextStyle(color: Colors.white),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        ),
        onChanged: (String val) {
          value = val;
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (value.length != 6) {
              Fluttertoast.showToast(msg: 'Room ID must be 6 digits long.');
              return;
            }
            joinRoom(value);
            Navigator.pop(context);
          },
          child: const Text('Join'),
        ),
      ],
    );
  }

  void joinRoom(String roomID) {
    FirebaseFirestore.instance.collection('rooms').doc(roomID).get().then((value) {
      if (value.exists) {
        if (value.data()!['players'] == '1') {
          FirebaseFirestore.instance.collection('rooms').doc(roomID).update({'players': '2'});
          context.read<GameBloc>().add(GameStarted('Friend', roomID));
          Navigator.push(context, MaterialPageRoute(builder: (context) => const Game()));
        } else {
          Fluttertoast.showToast(msg: 'Room is full.');
        }
      } else {
        Fluttertoast.showToast(msg: 'Room does not exist.');
      }
    });
    Navigator.push(context, MaterialPageRoute(builder: (context) => const Game()));
  }

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
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back),
                        color: Colors.white,
                      ),
                      Text(
                        'TicTacToe',
                        style: GoogleFonts.pressStart2p(fontSize: 30, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 36),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextButton(
                              onPressed: () {
                                context.read<GameBloc>().add(const GameStarted('Friend', null));
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (context) => const Game()));
                              },
                              child: Text(
                                'Create Room',
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
                                showDialog(context: context, builder: (context) => joinRoomDialog());
                              },
                              child: Text(
                                'Join Room',
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
