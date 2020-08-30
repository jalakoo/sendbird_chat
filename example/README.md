# sendbird_chat_example

Demonstrates how to use the sendbird_chat plugin.

## Usage
This example app requires the inclusion of a `.env` file located in the example root directory. Simplest option is to add your Sendbird keys to the `.env_sample` file and rename the file to `.env`.

## Polling
Because there doesn't appear to be a public websocket endpoint, this example app polls sendbird periodically for available users and open group channels and every second when the chat window is open.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
