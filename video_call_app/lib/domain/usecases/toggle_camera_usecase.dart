import '../repositories/livekit_repository.dart';

class ToggleCameraUseCase {
  const ToggleCameraUseCase(this._repository);

  final LiveKitRepository _repository;

  Future<bool> call() async {
    final nextValue = !_repository.isCameraEnabled;
    await _repository.setCameraEnabled(nextValue);
    return nextValue;
  }
}
