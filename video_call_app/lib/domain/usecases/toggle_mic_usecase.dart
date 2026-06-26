import '../repositories/livekit_repository.dart';

class ToggleMicUseCase {
  const ToggleMicUseCase(this._repository);

  final LiveKitRepository _repository;

  Future<bool> call() async {
    final nextValue = !_repository.isMicrophoneEnabled;
    await _repository.setMicrophoneEnabled(nextValue);
    return nextValue;
  }
}
