part of 'call_bloc.dart';

sealed class CallEvent extends Equatable {
  const CallEvent();

  @override
  List<Object?> get props => [];
}

final class CallStarted extends CallEvent {
  const CallStarted({
    required this.roomId,
    required this.userName,
  });

  final String roomId;
  final String userName;

  @override
  List<Object?> get props => [roomId, userName];
}

final class CallMicToggled extends CallEvent {
  const CallMicToggled();
}

final class CallCameraToggled extends CallEvent {
  const CallCameraToggled();
}

final class CallLeaveRequested extends CallEvent {
  const CallLeaveRequested();
}

final class CallRoomChanged extends CallEvent {
  const CallRoomChanged();
}
