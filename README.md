# joke_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

Key Components

1. main.dart

Sets up the main entry point for the app.

Includes the MyHomePage widget, which manages the joke display and UI interactions.

2. joke_model.dart

Defines the Joke model for individual jokes and the JokeResponse model for API responses.

Includes methods for serializing and deserializing JSON data.

3. joke_service.dart

Handles API requests using the dio package.

Caches jokes and last updated timestamp using shared_preferences.

Provides fallback data when offline or on API failure.