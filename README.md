# HiveMind

Navigation apps like Google Maps and Waze are greedy: each one optimizes a single driver's trip. HiveMind is a cooperative experiment that optimizes for total system velocity, the aggregate throughput of everyone on the road at once.

This repository is the mobile client. It is an early prototype.

## The idea

A greedy router sends every driver down the currently fastest road, and that road promptly stops being fast. A cooperative router treats the fleet as one system: it spreads vehicles across routes so the total travel time of the whole network goes down, even if a single driver occasionally takes a slightly longer path.

## What the client does today

- Streams the device's GPS position (via `geolocator`) to a coordination server over a WebSocket.
- Receives guidance back and renders it on a live driving dashboard.
- Keeps the screen awake while driving (`wakelock_plus`).

## Stack

Flutter and Dart, with `geolocator`, `web_socket_channel`, `google_fonts`, and `wakelock_plus`. The routing server and the optimization model run separately and are not part of this repo.

## Run it

```bash
flutter pub get
flutter run
```

Point `websocket_service.dart` at your coordination server before running.

## Status

Prototype built to demonstrate the cooperative-routing concept. The server-side optimizer is a separate component and is not included here.
