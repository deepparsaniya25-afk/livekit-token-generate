import '../repositories/livekit_repository.dart';

class LeaveRoomUseCase {
  const LeaveRoomUseCase(this._repository);

  final LiveKitRepository _repository;

  Future<void> call() => _repository.leaveRoom();
}
