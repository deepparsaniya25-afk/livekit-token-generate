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

## Token server (hosted on Render)

The PHP token server is deployed on **Render** using Docker:

**https://livekit-token-generate.onrender.com**

Endpoint:

```
GET /token?room=ROOM_ID&identity=USER_NAME
→ { "token": "..." }
```

Example:

```
https://livekit-token-generate.onrender.com/token?room=demo&identity=alice
```

No local token server is required to run the app — the Flutter client uses this hosted URL by default.

## Setup

### Flutter app

```bash
cd video_call_app
cp .env.example .env
```

Update `video_call_app/.env`:

```env
LIVEKIT_URL=wss://your-project.livekit.cloud
TOKEN_SERVER_URL=https://livekit-token-generate.onrender.com
```

```bash
flutter pub get
flutter run
```

## Testing a call

1. Run the app on two devices/emulators (or one device + simulator for audio-only on simulator).
2. Enter the **same Room ID** and different **User Names** on each device.
3. Tap **Join Call**.

## Run token server locally (optional)

The source lives in `token_server/` and can be run with Docker or PHP for local development.

### Docker

```bash
cd token_server
cp .env.example .env
# Edit .env with your LiveKit API key and secret
docker compose up --build
```

Server: `http://localhost:3000`

### PHP (without Docker)

Requires PHP 8.1+ with BCMath and [Composer](https://getcomposer.org/).

```bash
cd token_server
cp .env.example .env
composer install
composer start
```

Point `TOKEN_SERVER_URL` in the Flutter `.env` to `http://localhost:3000` (or your machine's LAN IP on a physical device).

## Notes

- iOS Simulator does not support camera; use a real device for video.
- Camera and microphone permissions are requested when joining a room.
- Tokens are generated server-side — never embed API secrets in the Flutter app.
- The Render service may take a few seconds to wake up on the free tier after idle time.
