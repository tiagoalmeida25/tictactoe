part of 'game_bloc.dart';

class GameState extends Equatable {
  final List<String> board;
  final String turn;
  final String winner;
  final String mode;

  const GameState._({required this.board, required this.turn, required this.winner, required this.mode});

  @override
  List<Object?> get props => [board, turn, winner, mode];
}
