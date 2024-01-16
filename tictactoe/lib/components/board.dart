import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tictactoe/bloc/game_bloc.dart';

class Board extends StatefulWidget {
  final BuildContext context;
  final GameState state;
  final bool playerTurn;

  const Board({super.key, required this.context, required this.state, required this.playerTurn});

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(Board oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state.winner != oldWidget.state.winner && widget.state.winner != '') {
      _controller.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (widget.state.winner != '')
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 5),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.width * 0.8,
          child: GridView.count(
            crossAxisCount: 3,
            padding: const EdgeInsets.all(8),
            children: List.generate(9, (index) {
              return GestureDetector(
                onTap: () {
                  if (widget.state.board[index] != '') return;

                  switch (widget.state.mode) {
                    case '2P':
                      context.read<GameBloc>().add(GameMoveRequested(index));

                      break;
                    case '1P':
                      if (widget.playerTurn) {
                        context.read<GameBloc>().add(GameMoveRequested(index));
                        Future.delayed(const Duration(milliseconds: 500), () {
                          if (widget.state.winner == '') {
                            int move = Random.secure().nextInt(9);
                            while (widget.state.board[move] != '') {
                              move = Random.secure().nextInt(9);
                            }
                            context.read<GameBloc>().add(GameMoveRequested(move));
                          }
                        });
                      }
                      break;
                    case 'GPT':
                      if (widget.playerTurn) {
                        context.read<GameBloc>().add(GameMoveRequested(index));
                      }
                      break;
                    case 'Friend':
                      if (widget.playerTurn) {
                        context.read<GameBloc>().add(GameMoveFriend(index));
                      }
                      break;
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: (index % 3 == 0)
                        ? (index == 6)
                            ? const Border(
                                right: BorderSide(color: Colors.grey, width: 1),
                              )
                            : const Border(
                                right: BorderSide(color: Colors.grey, width: 1),
                                bottom: BorderSide(color: Colors.grey, width: 1),
                              )
                        : (index % 3 == 1)
                            ? (index == 7)
                                ? const Border(
                                    right: BorderSide(color: Colors.grey, width: 1),
                                    left: BorderSide(color: Colors.grey, width: 1),
                                  )
                                : const Border(
                                    right: BorderSide(color: Colors.grey, width: 1),
                                    bottom: BorderSide(color: Colors.grey, width: 1),
                                    left: BorderSide(color: Colors.grey, width: 1),
                                  )
                            : (index == 8)
                                ? const Border(
                                    left: BorderSide(color: Colors.grey, width: 1),
                                  )
                                : const Border(
                                    bottom: BorderSide(color: Colors.grey, width: 1),
                                    left: BorderSide(color: Colors.grey, width: 1),
                                  ),
                  ),
                  child: Center(
                    child: (widget.state.board[index] == 'X')
                        ? const Icon(Icons.square_rounded, color: Colors.green, size: 50)
                        : (widget.state.board[index] == 'O')
                            ? const Icon(Icons.circle, color: Colors.blue, size: 50)
                            : null,
                  ),
                ),
              );
            }),
          ),
        ),
        if (widget.state.winner != '' && widget.state.winner != 'Draw')
          Positioned.fill(
            child: CustomPaint(
              painter: LinePainter(widget.state.board, _animation.value),
            ),
          ),
      ],
    );
  }
}

class LinePainter extends CustomPainter {
  List<int> findSequence(List<String> board) {
    for (var i = 0; i < 3; i++) {
      if (board[i * 3] != '' && board[i * 3] == board[i * 3 + 1] && board[i * 3] == board[i * 3 + 2]) {
        return [i * 3, i * 3 + 1, i * 3 + 2];
      }
      if (board[i] != '' && board[i] == board[i + 3] && board[i] == board[i + 6]) {
        return [i, i + 3, i + 6];
      }
    }

    if (board[0] != '' && board[0] == board[4] && board[0] == board[8]) {
      return [0, 4, 8];
    }

    if (board[2] != '' && board[2] == board[4] && board[2] == board[6]) {
      return [2, 4, 6];
    }

    return [];
  }

  final List<String> board;
  final double progress;

  LinePainter(this.board, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final sequence = findSequence(board);

    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 7.5
      ..strokeCap = StrokeCap.round;

    final offset = size.width / 6;
    const adjust = 6;

    double x1 = offset;
    double y1 = offset;
    double x2 = offset;
    double y2 = offset;

    if (sequence[0] == 0) {
      x1 = offset + adjust;
      y1 = offset + adjust;
    } else if (sequence[0] == 1) {
      x1 = size.width / 3 + offset;
      y1 = offset;
    } else if (sequence[0] == 2) {
      x1 = size.width * 2 / 3 + offset - adjust;
      y1 = offset + adjust;
    } else if (sequence[0] == 3) {
      x1 = offset + adjust;
      y1 = size.height / 3 + offset;
    } else if (sequence[0] == 6) {
      x1 = offset + adjust;
      y1 = size.height * 2 / 3 + offset - adjust;
    }

    if (sequence[2] == 2) {
      x2 = size.width * 2 / 3 + offset - adjust;
      y2 = offset + adjust;
    } else if (sequence[2] == 5) {
      x2 = size.width * 2 / 3 + offset - adjust;
      y2 = size.height / 3 + offset;
    } else if (sequence[2] == 6) {
      x2 = offset + adjust;
      y2 = size.height * 2 / 3 + offset - adjust;
    } else if (sequence[2] == 7) {
      x2 = size.width / 3 + offset;
      y2 = size.height * 2 / 3 + offset - adjust;
    } else if (sequence[2] == 8) {
      x2 = size.width * 2 / 3 + offset - adjust;
      y2 = size.height * 2 / 3 + offset - adjust;
    }

    final endX = x1 + (x2 - x1) * progress;
    final endY = y1 + (y2 - y1) * progress;

    canvas.drawLine(Offset(x1, y1), Offset(endX, endY), paint);
  }

  @override
  bool shouldRepaint(LinePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
