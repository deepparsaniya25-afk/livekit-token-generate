import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/call/call_bloc.dart';
import '../../widgets/call_controls.dart';
import '../../widgets/video_tile.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({
    super.key,
    required this.roomId,
    required this.userName,
  });

  final String roomId;
  final String userName;

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CallBloc>().add(
      CallStarted(roomId: widget.roomId, userName: widget.userName),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          context.read<CallBloc>().add(const CallLeaveRequested());
        }
      },
      child: BlocConsumer<CallBloc, CallState>(
      listener: (context, state) {
        if (state is CallLeft || state is CallFailure) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        if (state is! CallConnected) {
          return const Scaffold(
            backgroundColor: Color(0xFF0F0F1A),
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFF6C63FF)),
            ),
          );
        }

        final remoteTrack = state.remoteVideoTracks.isNotEmpty
            ? state.remoteVideoTracks.first
            : null;

        return Scaffold(
          backgroundColor: const Color(0xFF0F0F1A),
          appBar: AppBar(
            backgroundColor: const Color(0xFF0F0F1A),
            foregroundColor: Colors.white,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Room: ${state.roomId}'),
                Text(
                  state.userName,
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    VideoTile(
                      label: 'You',
                      track: state.localVideoTrack,
                      isMirrored: true,
                    ),
                    VideoTile(
                      label: remoteTrack == null ? 'Waiting for others...' : 'Remote',
                      track: remoteTrack,
                    ),
                  ],
                ),
              ),
              CallControls(
                isMicEnabled: state.isMicEnabled,
                isCameraEnabled: state.isCameraEnabled,
                onToggleMic: () =>
                    context.read<CallBloc>().add(const CallMicToggled()),
                onToggleCamera: () =>
                    context.read<CallBloc>().add(const CallCameraToggled()),
                onLeave: () =>
                    context.read<CallBloc>().add(const CallLeaveRequested()),
              ),
            ],
          ),
        );
      },
      ),
    );
  }
}
