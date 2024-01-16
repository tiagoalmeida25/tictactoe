part of 'game_bloc.dart';

@immutable
abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object?> get props => [];
}

class GameStarted extends GameEvent {
  final String mode;
  final String? roomID;

  const GameStarted(this.mode, [this.roomID]);

  @override
  List<Object?> get props => [mode];
}

class GameMoveRequested extends GameEvent {
  final int index;

  const GameMoveRequested(this.index);

  @override
  List<Object?> get props => [index];
}

class GameMoveFriend extends GameEvent {
  final int index;

  const GameMoveFriend(this.index);

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

class GameResetFriend extends GameEvent {}

class GameRefreshed extends GameEvent {
  final String roomID;

  const GameRefreshed(this.roomID);

  @override
  List<Object?> get props => [roomID];
}

class ExitGame extends GameEvent {}