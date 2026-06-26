import 'package:equatable/equatable.dart';

class JoinParams extends Equatable {
  const JoinParams({
    required this.roomId,
    required this.userName,
  });

  final String roomId;
  final String userName;

  @override
  List<Object?> get props => [roomId, userName];
}
