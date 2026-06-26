import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/join/join_bloc.dart';

class JoinScreen extends StatelessWidget {
  const JoinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: BlocBuilder<JoinBloc, JoinState>(
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(
                        Icons.video_call,
                        size: 72,
                        color: Color(0xFF6C63FF),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Video Call',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Enter a room ID and your name to join.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 32),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Room ID',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.meeting_room_outlined),
                        ),
                        textInputAction: TextInputAction.next,
                        onChanged: (value) => context.read<JoinBloc>().add(
                          JoinRoomIdChanged(value),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'User Name',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) {
                          if (state.canSubmit && state is! JoinLoading) {
                            context.read<JoinBloc>().add(const JoinSubmitted());
                          }
                        },
                        onChanged: (value) => context.read<JoinBloc>().add(
                          JoinUserNameChanged(value),
                        ),
                      ),
                      if (state is JoinFailure) ...[
                        const SizedBox(height: 16),
                        Text(
                          state.message,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: state.canSubmit && state is! JoinLoading
                            ? () => context.read<JoinBloc>().add(
                                const JoinSubmitted(),
                              )
                            : null,
                        icon: state is JoinLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.login),
                        label: Text(
                          state is JoinLoading ? 'Joining...' : 'Join Call',
                        ),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: const Color(0xFF6C63FF),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
