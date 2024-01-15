import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

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

    return '';
  }

  GameBloc() : super(const GameState._(board: ['', '', '', '', '', '', '', '', ''], turn: 'X', winner: '')) {
    on<GameStarted>((event, emit) {
      emit(const GameState._(board: ['', '', '', '', '', '', '', '', ''], turn: 'X', winner: ''));
    });

    on<GameMoveRequested>((event, emit) {
      final board = List<String>.from(state.board);
      board[event.index] = state.turn;

      final nextTurn = state.turn == 'X' ? 'O' : 'X';
      String winner = _calculateWinner(board);

      int count = 0;
      for (var i = 0; i < 9; i++) {
        if (board[i] != '') {
          count++;
        }
      }

      if (count == 9 && winner == '') {
        winner = 'Draw';
      }

      emit(GameState._(board: board, turn: nextTurn, winner: winner));
    });

    on<GameOver>((event, emit) {
      emit(GameState._(board: state.board, turn: state.turn, winner: event.winner));
    });

    on<GameResetRequested>((event, emit) {
      emit(const GameState._(board: ['', '', '', '', '', '', '', '', ''], turn: 'X', winner: ''));
    });
  }
}
