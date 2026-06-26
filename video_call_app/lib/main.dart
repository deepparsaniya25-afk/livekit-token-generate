import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/di/service_locator.dart';
import 'presentation/bloc/join/join_bloc.dart';
import 'presentation/screens/call/call_screen.dart';
import 'presentation/screens/join/join_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  ServiceLocator.instance.init();
  runApp(const VideoCallApp());
}

class VideoCallApp extends StatelessWidget {
  const VideoCallApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ServiceLocator.instance.createJoinBloc(),
      child: MaterialApp(
        title: 'Video Call',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C63FF)),
          useMaterial3: true,
        ),
        home: const _JoinFlow(),
      ),
    );
  }
}

class _JoinFlow extends StatelessWidget {
  const _JoinFlow();

  @override
  Widget build(BuildContext context) {
    return BlocListener<JoinBloc, JoinState>(
      listener: (context, state) {
        if (state is JoinSuccess) {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => BlocProvider(
                create: (_) => ServiceLocator.instance.createCallBloc(),
                child: CallScreen(
                  roomId: state.roomId,
                  userName: state.userName,
                ),
              ),
            ),
          );
        }
      },
      child: const JoinScreen(),
    );
  }
}
