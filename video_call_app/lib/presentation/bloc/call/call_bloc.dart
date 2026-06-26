import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livekit_client/livekit_client.dart';

import '../../../domain/repositories/livekit_repository.dart';
import '../../../domain/usecases/leave_room_usecase.dart';
import '../../../domain/usecases/toggle_camera_usecase.dart';
import '../../../domain/usecases/toggle_mic_usecase.dart';

part 'call_event.dart';
part 'call_state.dart';

class CallBloc extends Bloc<CallEvent, CallState> {
  CallBloc({
    required LiveKitRepository repository,
    required ToggleMicUseCase toggleMicUseCase,
    required ToggleCameraUseCase toggleCameraUseCase,
    required LeaveRoomUseCase leaveRoomUseCase,
  })  : _repository = repository,
        _toggleMicUseCase = toggleMicUseCase,
        _toggleCameraUseCase = toggleCameraUseCase,
        _leaveRoomUseCase = leaveRoomUseCase,
        super(const CallInitial()) {
    on<CallStarted>(_onStarted);
    on<CallMicToggled>(_onMicToggled);
    on<CallCameraToggled>(_onCameraToggled);
    on<CallLeaveRequested>(_onLeaveRequested);
    on<CallRoomChanged>(_onRoomChanged);
  }

  final LiveKitRepository _repository;
  final ToggleMicUseCase _toggleMicUseCase;
  final ToggleCameraUseCase _toggleCameraUseCase;
  final LeaveRoomUseCase _leaveRoomUseCase;

  EventsListener<RoomEvent>? _roomListener;

  Future<void> _onStarted(CallStarted event, Emitter<CallState> emit) async {
    final room = _repository.room;
    if (room == null) {
      emit(CallFailure(message: 'No active room connection'));
      return;
    }

    _listenToRoom(room);
    emit(_buildConnectedState(roomId: event.roomId, userName: event.userName));
  }

  Future<void> _onMicToggled(
    CallMicToggled event,
    Emitter<CallState> emit,
  ) async {
    final current = state;
    if (current is! CallConnected) {
      return;
    }

    try {
      final enabled = await _toggleMicUseCase();
      emit(current.copyWith(isMicEnabled: enabled));
    } catch (error) {
      emit(CallFailure(message: error.toString()));
    }
  }

  Future<void> _onCameraToggled(
    CallCameraToggled event,
    Emitter<CallState> emit,
  ) async {
    final current = state;
    if (current is! CallConnected) {
      return;
    }

    try {
      final enabled = await _toggleCameraUseCase();
      emit(
        current.copyWith(
          isCameraEnabled: enabled,
          localVideoTrack: _repository.localVideoTrack,
        ),
      );
    } catch (error) {
      emit(CallFailure(message: error.toString()));
    }
  }

  Future<void> _onLeaveRequested(
    CallLeaveRequested event,
    Emitter<CallState> emit,
  ) async {
    await _disposeListener();
    await _leaveRoomUseCase();
    emit(const CallLeft());
  }

  void _onRoomChanged(CallRoomChanged event, Emitter<CallState> emit) {
    final current = state;
    if (current is! CallConnected) {
      return;
    }

    emit(
      current.copyWith(
        localVideoTrack: _repository.localVideoTrack,
        remoteVideoTracks: _repository.remoteVideoTracks,
      ),
    );
  }

  CallConnected _buildConnectedState({
    required String roomId,
    required String userName,
  }) {
    return CallConnected(
      roomId: roomId,
      userName: userName,
      isMicEnabled: _repository.isMicrophoneEnabled,
      isCameraEnabled: _repository.isCameraEnabled,
      localVideoTrack: _repository.localVideoTrack,
      remoteVideoTracks: _repository.remoteVideoTracks,
    );
  }

  void _listenToRoom(Room room) {
    _roomListener?.dispose();
    _roomListener = room.createListener()
      ..on<RoomEvent>((_) => add(const CallRoomChanged()))
      ..on<TrackSubscribedEvent>((_) => add(const CallRoomChanged()))
      ..on<TrackUnsubscribedEvent>((_) => add(const CallRoomChanged()))
      ..on<ParticipantConnectedEvent>((_) => add(const CallRoomChanged()))
      ..on<ParticipantDisconnectedEvent>((_) => add(const CallRoomChanged()));
  }

  Future<void> _disposeListener() async {
    await _roomListener?.dispose();
    _roomListener = null;
  }

  @override
  Future<void> close() async {
    await _disposeListener();
    return super.close();
  }
}
