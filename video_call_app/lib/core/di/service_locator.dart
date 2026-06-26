import '../../data/datasources/livekit_remote_datasource.dart';
import '../../data/repositories/livekit_repository_impl.dart';
import '../../domain/repositories/livekit_repository.dart';
import '../../domain/usecases/join_room_usecase.dart';
import '../../domain/usecases/leave_room_usecase.dart';
import '../../domain/usecases/toggle_camera_usecase.dart';
import '../../domain/usecases/toggle_mic_usecase.dart';
import '../../presentation/bloc/call/call_bloc.dart';
import '../../presentation/bloc/join/join_bloc.dart';

class ServiceLocator {
  ServiceLocator._();

  static final ServiceLocator instance = ServiceLocator._();

  late final LiveKitRemoteDataSource _liveKitRemoteDataSource;
  late final LiveKitRepository _liveKitRepository;
  late final JoinRoomUseCase _joinRoomUseCase;
  late final ToggleMicUseCase _toggleMicUseCase;
  late final ToggleCameraUseCase _toggleCameraUseCase;
  late final LeaveRoomUseCase _leaveRoomUseCase;

  void init() {
    _liveKitRemoteDataSource = LiveKitRemoteDataSource();
    _liveKitRepository = LiveKitRepositoryImpl(_liveKitRemoteDataSource);
    _joinRoomUseCase = JoinRoomUseCase(_liveKitRepository);
    _toggleMicUseCase = ToggleMicUseCase(_liveKitRepository);
    _toggleCameraUseCase = ToggleCameraUseCase(_liveKitRepository);
    _leaveRoomUseCase = LeaveRoomUseCase(_liveKitRepository);
  }

  JoinBloc createJoinBloc() => JoinBloc(joinRoomUseCase: _joinRoomUseCase);

  CallBloc createCallBloc() => CallBloc(
        repository: _liveKitRepository,
        toggleMicUseCase: _toggleMicUseCase,
        toggleCameraUseCase: _toggleCameraUseCase,
        leaveRoomUseCase: _leaveRoomUseCase,
      );
}
