part of 'game_bloc.dart';

class GameState extends Equatable {
  final List<String> board;
  final String turn;
  final String winner;

  const GameState._({required this.board, required this.turn, required this.winner});

  @override
  List<Object?> get props => [board, turn, winner];
}
