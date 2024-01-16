import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  String _calculateWinner(List<String> board) {
    for (var i = 0; i < 3; i++) {
      if (board[i * 3] != '' && board[i * 3] == board[i * 3 + 1] && board[i * 3] == board[i * 3 + 2]) {
        if (board[i * 3] == 'X') {
          return 'X';
        } else {
          return 'O';
        }
      }
      if (board[i] != '' && board[i] == board[i + 3] && board[i] == board[i + 6]) {
        if (board[i] == 'X') {
          return 'X';
        } else {
          return 'O';
        }
      }
    }

    if (board[0] != '' && board[0] == board[4] && board[0] == board[8]) {
      if (board[0] == 'X') {
        return 'X';
      } else {
        return 'O';
      }
    }

    if (board[2] != '' && board[2] == board[4] && board[2] == board[6]) {
      if (board[2] == 'X') {
        return 'X';
      } else {
        return 'O';
      }
    }

    int count = 0;
    for (var i = 0; i < 9; i++) {
      if (board[i] != '') {
        count++;
      }
    }

    if (count == 9) {
      return 'Draw';
    }

    return '';
  }

  GameBloc()
      : super(
            const GameState._(board: ['', '', '', '', '', '', '', '', ''], turn: 'X', winner: '', mode: '')) {
    on<GameStarted>((event, emit) {
      if (event.mode == 'Friend') {
        if (event.roomID != null) {
          emit(GameState._(
              roomID: event.roomID,
              player: '2',
              board: const ['', '', '', '', '', '', '', '', ''],
              turn: 'X',
              winner: '',
              mode: event.mode));
          return;
        }

        final roomID = Random().nextInt(1000000).toString();

        FirebaseFirestore.instance.collection('rooms').doc(roomID).set({
          'players': '1',
          'board': ['', '', '', '', '', '', '', '', ''],
        });

        emit(GameState._(
            roomID: roomID,
            player: '1',
            board: const ['', '', '', '', '', '', '', '', ''],
            turn: 'X',
            winner: '',
            mode: event.mode));
        return;
      }

      emit(GameState._(
          board: const ['', '', '', '', '', '', '', '', ''], turn: 'X', winner: '', mode: event.mode));
    });

    on<GameMoveRequested>((event, emit) {
      final board = List<String>.from(state.board);
      board[event.index] = state.turn;

      final nextTurn = state.turn == 'X' ? 'O' : 'X';
      String winner = _calculateWinner(board);

      emit(GameState._(board: board, turn: nextTurn, winner: winner, mode: state.mode));
    });

    on<GameMoveFriend>((event, emit) async {
      final board = List<String>.from(state.board);
      board[event.index] = state.turn;

      final nextTurn = state.turn == 'X' ? 'O' : 'X';
      String winner = _calculateWinner(board);

      await FirebaseFirestore.instance.collection('rooms').doc(state.roomID).update({
        'board': board,
        'turn': nextTurn,
        'winner': winner,
      });

      emit(GameState._(
          roomID: state.roomID,
          player: state.player,
          board: board,
          turn: nextTurn,
          winner: winner,
          mode: state.mode));
    });

    on<GameOver>((event, emit) {
      emit(GameState._(board: state.board, turn: state.turn, winner: event.winner, mode: state.mode));
    });

    on<GameResetRequested>((event, emit) {
      emit(GameState._(
          board: const ['', '', '', '', '', '', '', '', ''], turn: 'X', winner: '', mode: state.mode));
    });

    on<GameRefreshed>((event, emit) async {
      final value = await FirebaseFirestore.instance.collection('rooms').doc(event.roomID).get();
      if (value.exists) {
        final board = List<String>.from(value.data()!['board']);
        final turn = value.data()!['turn'];
        final winner = value.data()!['winner'];

        emit(GameState._(
            roomID: state.roomID,
            player: state.player,
            board: board,
            turn: turn,
            winner: winner,
            mode: state.mode));
      }
    });
  }
}
