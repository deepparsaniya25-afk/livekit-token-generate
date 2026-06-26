part of 'join_bloc.dart';

sealed class JoinState extends Equatable {
  const JoinState({
    required this.roomId,
    required this.userName,
  });

  final String roomId;
  final String userName;

  bool get canSubmit =>
      roomId.trim().isNotEmpty && userName.trim().isNotEmpty;

  @override
  List<Object?> get props => [roomId, userName];
}

final class JoinInitial extends JoinState {
  const JoinInitial({
    super.roomId = '',
    super.userName = '',
  });
}

final class JoinLoading extends JoinState {
  const JoinLoading({
    required super.roomId,
    required super.userName,
  });
}

final class JoinSuccess extends JoinState {
  const JoinSuccess({
    required super.roomId,
    required super.userName,
  });
}

final class JoinFailure extends JoinState {
  const JoinFailure({
    required super.roomId,
    required super.userName,
    required this.message,
  });

  final String message;

  @override
  List<Object?> get props => [...super.props, message];
}
