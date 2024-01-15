part of 'game_bloc.dart';

@immutable
abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object?> get props => [];
}

class GameStarted extends GameEvent {
  final String mode;

  const GameStarted(this.mode);

  @override
  List<Object?> get props => [mode];
}

class GameMoveRequested extends GameEvent {
  final int index;

  const GameMoveRequested(this.index);

  @override
  List<Object?> get props => [index];
}

class GameOver extends GameEvent {
  final String winner;

  const GameOver(this.winner);

  @override
  List<Object?> get props => [winner];
}

class GameResetRequested extends GameEvent {}
