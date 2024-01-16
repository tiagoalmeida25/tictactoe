part of 'game_bloc.dart';

class GameState extends Equatable {
  final List<String> board;
  final String turn;
  final String winner;
  final String mode;
  final String? roomID;
  final String? player;

  const GameState._({
    required this.board,
    required this.turn,
    required this.winner,
    required this.mode,
    this.roomID,
    this.player,
  });

  @override
  List<Object?> get props => [board, turn, winner, mode];
}
