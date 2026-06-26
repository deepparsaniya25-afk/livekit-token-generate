<?php

declare(strict_types=1);

require __DIR__ . '/vendor/autoload.php';

use Agence104\LiveKit\AccessToken;
use Agence104\LiveKit\AccessTokenOptions;
use Agence104\LiveKit\VideoGrant;
use Dotenv\Dotenv;

header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(204);
    exit;
}

$dotenv = Dotenv::createImmutable(__DIR__);
$dotenv->safeLoad();

$path = parse_url($_SERVER['REQUEST_URI'] ?? '/', PHP_URL_PATH);

if ($path !== '/token') {
    http_response_code(404);
    header('Content-Type: application/json');
    echo json_encode(['error' => 'Not found']);
    exit;
}

$room = $_GET['room'] ?? null;
$identity = $_GET['identity'] ?? null;

header('Content-Type: application/json');

if (!$room || !$identity) {
    http_response_code(400);
    echo json_encode([
        'error' => 'Missing required query params: room, identity',
    ]);
    exit;
}

$apiKey = $_ENV['LIVEKIT_API_KEY'] ?? 'APIgfKxn7fqVq4F';
$apiSecret = $_ENV['LIVEKIT_API_SECRET'] ?? 'tCFCTxccs4xeVhZ7ldLAgURhp9ciuj6z7PoqUte2fxsB';

if ($apiKey === '' || $apiSecret === '') {
    http_response_code(500);
    echo json_encode([
        'error' => 'Server is missing LIVEKIT_API_KEY or LIVEKIT_API_SECRET',
    ]);
    exit;
}

$tokenOptions = (new AccessTokenOptions())
    ->setIdentity((string) $identity)
    ->setName((string) $identity);

$videoGrant = (new VideoGrant())
    ->setRoomJoin()
    ->setRoomName((string) $room)
    ->setCanPublish()
    ->setCanSubscribe();

$token = (new AccessToken($apiKey, $apiSecret))
    ->init($tokenOptions)
    ->setGrant($videoGrant)
    ->toJwt();

echo json_encode(['token' => $token]);
