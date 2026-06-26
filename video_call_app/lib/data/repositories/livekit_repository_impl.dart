import 'package:livekit_client/livekit_client.dart';

import '../../domain/entities/join_params.dart';
import '../../domain/repositories/livekit_repository.dart';
import '../datasources/livekit_remote_datasource.dart';

class LiveKitRepositoryImpl implements LiveKitRepository {
  LiveKitRepositoryImpl(this._remoteDataSource);

  final LiveKitRemoteDataSource _remoteDataSource;

  @override
  Room? get room => _remoteDataSource.room;

  @override
  Future<Room> joinRoom(JoinParams params) {
    return _remoteDataSource.connect(
      roomId: params.roomId,
      userName: params.userName,
    );
  }

  @override
  Future<void> leaveRoom() => _remoteDataSource.disconnect();

  @override
  Future<void> setMicrophoneEnabled(bool enabled) =>
      _remoteDataSource.setMicrophoneEnabled(enabled);

  @override
  Future<void> setCameraEnabled(bool enabled) =>
      _remoteDataSource.setCameraEnabled(enabled);

  @override
  bool get isMicrophoneEnabled => _remoteDataSource.isMicrophoneEnabled;

  @override
  bool get isCameraEnabled => _remoteDataSource.isCameraEnabled;

  @override
  VideoTrack? get localVideoTrack => _remoteDataSource.localVideoTrack;

  @override
  List<VideoTrack> get remoteVideoTracks =>
      _remoteDataSource.remoteVideoTracks;
}
