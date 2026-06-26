import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/join_params.dart';
import '../../../domain/usecases/join_room_usecase.dart';

part 'join_event.dart';
part 'join_state.dart';

class JoinBloc extends Bloc<JoinEvent, JoinState> {
  JoinBloc({
    required JoinRoomUseCase joinRoomUseCase,
  })  : _joinRoomUseCase = joinRoomUseCase,
        super(const JoinInitial()) {
    on<JoinRoomIdChanged>(_onRoomIdChanged);
    on<JoinUserNameChanged>(_onUserNameChanged);
    on<JoinSubmitted>(_onSubmitted);
  }

  final JoinRoomUseCase _joinRoomUseCase;

  void _onRoomIdChanged(JoinRoomIdChanged event, Emitter<JoinState> emit) {
    emit(JoinInitial(roomId: event.roomId, userName: state.userName));
  }

  void _onUserNameChanged(
    JoinUserNameChanged event,
    Emitter<JoinState> emit,
  ) {
    emit(JoinInitial(roomId: state.roomId, userName: event.userName));
  }

  Future<void> _onSubmitted(
    JoinSubmitted event,
    Emitter<JoinState> emit,
  ) async {
    if (!state.canSubmit) {
      return;
    }

    final roomId = state.roomId.trim();
    final userName = state.userName.trim();

    emit(JoinLoading(roomId: roomId, userName: userName));

    try {
      await _joinRoomUseCase(
        JoinParams(roomId: roomId, userName: userName),
      );
      emit(JoinSuccess(roomId: roomId, userName: userName));
    } catch (error) {
      emit(
        JoinFailure(
          roomId: roomId,
          userName: userName,
          message: error.toString(),
        ),
      );
    }
  }
}
