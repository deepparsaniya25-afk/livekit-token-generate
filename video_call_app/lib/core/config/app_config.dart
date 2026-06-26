import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get liveKitUrl =>
      dotenv.env['LIVEKIT_URL'] ?? 'wss://your-project.livekit.cloud';

  static String get tokenServerUrl =>
      dotenv.env['TOKEN_SERVER_URL'] ?? 'http://localhost:3000';
}
