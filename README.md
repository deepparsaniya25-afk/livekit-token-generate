# Basic Video Call App (LiveKit + Flutter)

A basic video/audio call app built with **Flutter**, **LiveKit**, and **Clean Architecture (MVVM + BLoC)**.

## Features

- **Join screen** with Room ID and User Name
- **Call screen** showing local and remote video
- **Controls**: mute/unmute, camera on/off, leave call

## Architecture

```
lib/
├── core/           # Config, dependency injection
├── domain/         # Entities, repository contracts, use cases
├── data/           # LiveKit + token data sources, repository impl
└── presentation/   # BLoC (ViewModel), screens (View), widgets
```

| Layer | Responsibility |
|-------|----------------|
| **View** | `JoinScreen`, `CallScreen`, widgets |
| **ViewModel** | `JoinBloc`, `CallBloc` |
| **Model** | Domain entities + `LiveKitRepository` |

## Prerequisites

1. [Flutter SDK](https://flutter.dev/docs/get-started/install)
2. A [LiveKit Cloud](https://cloud.livekit.io/) project (or self-hosted server)
3. [PHP](https://www.php.net/) 8.1+ and [Composer](https://getcomposer.org/) for the token server

## Setup

### 1. Token server

```bash
cd token_server
cp .env.example .env
# Edit .env with your LiveKit API key and secret
composer install
composer start
```

The server runs at `http://localhost:3000` and exposes `GET /token?room=ROOM_ID&identity=USER_NAME`.

### 2. Flutter app

```bash
cd video_call_app
cp .env.example .env
```

Update `video_call_app/.env`:

```env
LIVEKIT_URL=wss://your-project.livekit.cloud
TOKEN_SERVER_URL=http://localhost:3000
```

For a physical device, use your machine's LAN IP instead of `localhost` for `TOKEN_SERVER_URL`.

```bash
flutter pub get
flutter run
```

## Testing a call

1. Start the token server.
2. Run the app on two devices/emulators (or one device + simulator for audio-only on simulator).
3. Enter the **same Room ID** and different **User Names** on each device.
4. Tap **Join Call**.

## Notes

- iOS Simulator does not support camera; use a real device for video.
- Camera and microphone permissions are requested when joining a room.
- Tokens are generated server-side — never embed API secrets in the Flutter app.
