import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tictactoe/bloc/game_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:tictactoe/components/board.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

enum Player { X, O }

class _GameState extends State<Game> {
  String playerTurn = 'X';
  int aiMove = -1;
  String assistantMessage = '';
  int retry = 0;
  String apiKey = '';

  @override
  void initState() {
    super.initState();
    loadApiKey();

    if (context.read<GameBloc>().state.mode == '1P') {
      playerTurn = Player.values[Random().nextInt(Player.values.length)].toString().split('.').last;
      if (playerTurn == 'O') {
        context.read<GameBloc>().add(GameMoveRequested(Random.secure().nextInt(9)));
      }
    }
    if (context.read<GameBloc>().state.mode == 'GPT') {
      playerTurn = Player.values[Random().nextInt(Player.values.length)].toString().split('.').last;
      if (playerTurn == 'O') {
        startGPTGame();
      }
    }
  }

  void loadApiKey() async {
    setState(() {
      apiKey = dotenv.env['OPENAI_API_KEY']!;
    });

    print('API Key: $apiKey');
  }

  void startGPTGame() async {
    await sendMessage(['', '', '', '', '', '', '', '', ''], 'You are playing first');

    context.read<GameBloc>().add(GameMoveRequested(aiMove));
    setState(() {
      aiMove = -1;
      retry = 0;
    });
  }

  Widget result(state) {
    switch (state.winner) {
      case 'X':
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (state.mode == '2P')
              const Icon(Icons.square_rounded, color: Colors.green, size: 30)
            else if (state.winner == playerTurn)
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
            if (state.mode == '2P')
              const Icon(Icons.circle, color: Colors.blue, size: 30)
            else if (state.winner == playerTurn)
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
    if (state.mode == '1P' || state.mode == 'GPT') {
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
    } else if (state.mode == '2P') {
      if (state.turn == 'X') {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.square_rounded, color: Colors.green, size: 30),
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
            const Icon(Icons.circle, color: Colors.blue, size: 30),
            Text(
              ' turn',
              style: GoogleFonts.pressStart2p(fontSize: 20, color: Colors.white),
            ),
          ],
        );
      }
    }
    return const SizedBox();
  }

  Future<void> sendMessage(List<String> board, String? note) async {
    List<String> copyBoard = List<String>.from(board);
    for (var i = 0; i < copyBoard.length; i++) {
      if (copyBoard[i] == '') {
        copyBoard[i] = '$i:';
      } else if (copyBoard[i] == 'X') {
        copyBoard[i] = '$i:X';
      } else if (copyBoard[i] == 'O') {
        copyBoard[i] = '$i:O';
      }
    }

    note ??= '';
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        // 'model': 'gpt-4-1106-preview',
        'model': 'gpt-3.5-turbo-1106',
        'messages': [
          {
            'role': 'system',
            'content':
                'You are an AI in an app playing a game of Tic Tac Toe. You are the world champion, act like it, be cocky and funny. The board is presented linearly, where index 0 is Top-Left, 1 is Top-Center, 2 is Top-Right, 3 is Middle-Left, 4 is Middle-Center, 5 is Middle-Right, 6 is Bottom-Left, 7 is Bottom-Center, and 8 is Bottom-Right. You can only play in empty places (_) and will immediatly lose if you play in an invalid place. This is the current configuration: $copyBoard. You are playing against $playerTurn. Answer in a json with two keys: "answer" (just your answer, max 2 sentences) and "position" (just the index of the position you want). Example: {"answer": "this is my answer", "position": 4}. Where do you want to play?'
          },
          {'role': 'user', 'content': note}
        ],
        'max_tokens': 60,
      }),
    );

    final data = json.decode(response.body);

    if (data != null && data['choices'] != null && data['choices'][0] != null) {
      final messageContent = data['choices'][0]['message']['content']?.trim() ?? '';
      final messageJson = json.decode(messageContent);

      setState(() {
        assistantMessage = messageJson['answer'];
        aiMove = messageJson['position'];
      });

      if ((board[aiMove] != '' || aiMove < 0) && retry < 5) {
        retry++;
        await sendMessage(board, 'Try again.');
      }
      if (retry >= 5 && board[aiMove] != '') {
        aiMove = Random.secure().nextInt(9);
        while (board[aiMove] != '') {
          aiMove = Random.secure().nextInt(9);
        }
        setState(() {
          aiMove = aiMove;
        });
      }
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
            case 'GPT':
              if (state.winner == '') {
                setState(() {
                  assistantMessage = '';
                  playerTurn =
                      Player.values[Random().nextInt(Player.values.length)].toString().split('.').last;
                });
                if (playerTurn == 'O') {
                  await sendMessage(state.board, 'You are playing first');

                  context.read<GameBloc>().add(GameMoveRequested(aiMove));
                  setState(() {
                    aiMove = -1;
                    retry = 0;
                  });
                }
              }

              break;
          }
        } else {
          if (state.mode == 'GPT' && state.turn != playerTurn && state.winner == '') {
            await sendMessage(state.board, '');

            context.read<GameBloc>().add(GameMoveRequested(aiMove));
            setState(() {
              aiMove = -1;
              retry = 0;
            });
          }
          if (state.mode == 'GPT' && state.winner == playerTurn) {
            await sendMessage(state.board, 'You lost! Say something funny to say goodbye.');
          } else if (state.mode == 'GPT' && state.winner != playerTurn && state.winner != '') {
            await sendMessage(state.board, 'You won! Say something funny to say goodbye.');
          } else if (state.mode == 'GPT' && state.winner == 'Draw') {
            await sendMessage(state.board, 'Draw! Say something funny to say goodbye.');
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
                  if (state.mode == 'GPT') const SizedBox(height: 36),
                  if (state.mode == 'GPT' && assistantMessage != '')
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(
                          assistantMessage,
                          style: GoogleFonts.pressStart2p(fontSize: 10, color: Colors.white),
                          softWrap: true,
                          overflow: TextOverflow.visible,
                          maxLines: 10,
                        ),
                      ),
                    ),
                  const SizedBox(height: 64),
                  Board(
                      context: context,
                      state: state,
                      playerTurn: state.mode == '2P' || playerTurn == state.turn),
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
