import 'package:livekit_client/livekit_client.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/config/app_config.dart';
import 'token_remote_datasource.dart';

class LiveKitRemoteDataSource {
  LiveKitRemoteDataSource({
    TokenRemoteDataSource? tokenDataSource,
  }) : _tokenDataSource = tokenDataSource ?? const TokenRemoteDataSource();

  final TokenRemoteDataSource _tokenDataSource;
  Room? _room;

  Room? get room => _room;

  Future<Room> connect({
    required String roomId,
    required String userName,
  }) async {
    await _requestPermissions();

    final token = await _tokenDataSource.fetchToken(
      roomId: roomId,
      userName: userName,
    );

    final room = Room(
      roomOptions: const RoomOptions(
        adaptiveStream: true,
        dynacast: true,
      ),
    );
    await room.connect(AppConfig.liveKitUrl, token);

    try {
      await room.localParticipant?.setCameraEnabled(true);
    } catch (_) {
      // Camera may be unavailable on simulators.
    }
    await room.localParticipant?.setMicrophoneEnabled(true);

    _room = room;
    return room;
  }

  Future<void> disconnect() async {
    await _room?.disconnect();
    await _room?.dispose();
    _room = null;
  }

  Future<void> setMicrophoneEnabled(bool enabled) async {
    await _room?.localParticipant?.setMicrophoneEnabled(enabled);
  }

  Future<void> setCameraEnabled(bool enabled) async {
    await _room?.localParticipant?.setCameraEnabled(enabled);
  }

  bool get isMicrophoneEnabled =>
      _room?.localParticipant?.isMicrophoneEnabled() ?? false;

  bool get isCameraEnabled =>
      _room?.localParticipant?.isCameraEnabled() ?? false;

  VideoTrack? get localVideoTrack {
    final participant = _room?.localParticipant;
    if (participant == null) {
      return null;
    }

    for (final publication in participant.videoTrackPublications) {
      final track = publication.track;
      if (track is VideoTrack) {
        return track;
      }
    }
    return null;
  }

  List<VideoTrack> get remoteVideoTracks {
    final room = _room;
    if (room == null) {
      return const [];
    }

    final tracks = <VideoTrack>[];
    for (final participant in room.remoteParticipants.values) {
      for (final publication in participant.videoTrackPublications) {
        final track = publication.track;
        if (track != null && publication.subscribed) {
          tracks.add(track as VideoTrack);
        }
      }
    }
    return tracks;
  }

  Future<void> _requestPermissions() async {
    await [Permission.camera, Permission.microphone].request();
  }
}
