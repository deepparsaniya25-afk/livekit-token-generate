import 'package:livekit_client/livekit_client.dart';

import '../entities/join_params.dart';

abstract class LiveKitRepository {
  Room? get room;

  Future<Room> joinRoom(JoinParams params);

  Future<void> leaveRoom();

  Future<void> setMicrophoneEnabled(bool enabled);

  Future<void> setCameraEnabled(bool enabled);

  bool get isMicrophoneEnabled;

  bool get isCameraEnabled;

  VideoTrack? get localVideoTrack;

  List<VideoTrack> get remoteVideoTracks;
}
