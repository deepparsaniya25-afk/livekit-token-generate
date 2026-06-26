import 'package:livekit_client/livekit_client.dart';

import '../entities/join_params.dart';
import '../repositories/livekit_repository.dart';

class JoinRoomUseCase {
  const JoinRoomUseCase(this._repository);

  final LiveKitRepository _repository;

  Future<Room> call(JoinParams params) => _repository.joinRoom(params);
}
