part of 'call_bloc.dart';

sealed class CallState extends Equatable {
  const CallState();

  @override
  List<Object?> get props => [];
}

final class CallInitial extends CallState {
  const CallInitial();
}

final class CallConnected extends CallState {
  const CallConnected({
    required this.roomId,
    required this.userName,
    required this.isMicEnabled,
    required this.isCameraEnabled,
    required this.localVideoTrack,
    required this.remoteVideoTracks,
  });

  final String roomId;
  final String userName;
  final bool isMicEnabled;
  final bool isCameraEnabled;
  final VideoTrack? localVideoTrack;
  final List<VideoTrack> remoteVideoTracks;

  CallConnected copyWith({
    String? roomId,
    String? userName,
    bool? isMicEnabled,
    bool? isCameraEnabled,
    VideoTrack? localVideoTrack,
    List<VideoTrack>? remoteVideoTracks,
  }) {
    return CallConnected(
      roomId: roomId ?? this.roomId,
      userName: userName ?? this.userName,
      isMicEnabled: isMicEnabled ?? this.isMicEnabled,
      isCameraEnabled: isCameraEnabled ?? this.isCameraEnabled,
      localVideoTrack: localVideoTrack ?? this.localVideoTrack,
      remoteVideoTracks: remoteVideoTracks ?? this.remoteVideoTracks,
    );
  }

  @override
  List<Object?> get props => [
        roomId,
        userName,
        isMicEnabled,
        isCameraEnabled,
        localVideoTrack,
        remoteVideoTracks,
      ];
}

final class CallLeft extends CallState {
  const CallLeft();
}

final class CallFailure extends CallState {
  const CallFailure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
