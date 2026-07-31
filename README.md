# HRM App

A scalable, feature-first Flutter foundation for an enterprise HRM mobile application.

## Architecture

The project is organized around a modular feature-first structure:

- core/: reusable theme, constants, routing, networking, storage, utilities, and widgets
- features/: isolated feature modules such as authentication and dashboard
- assets/: static assets reserved for images, icons, SVGs, and illustrations

## Stack

- Flutter
- GetX for state management and routing
- GetStorage for local persistence
- Dio for API client scaffolding

## Getting Started

1. Install Flutter dependencies:
   flutter pub get
2. Run the app:
   flutter run

This initial setup focuses on architecture, theming, routing, dependency injection, storage, and reusable UI scaffolding rather than business features.
