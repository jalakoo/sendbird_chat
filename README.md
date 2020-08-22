# sendbird_chat

A Flutter package for Android, iOS and web to utilize basic [Sendbird API](https://docs.sendbird.com/platform/quick_start) functionality to their applications.

## Usage
To use this package, add the dependency to your `pubspec.yaml` file:
```dart
dependencies:
    flutter:
        sdk: flutter
    sendbird_chat
```

## Features
- List, Create & Delete users
- List, Create & Delete open channels
- List, Send open channel messages

## How to use
### Initialize
```dart
SendbirdChat chat = SendbirdChat(
                      applicationId: '',  // replace with your application id
                      apiToken: '');      // replace with your application API token (secondary recommended)
```

### Creating a User
```dart
chat.createUser(userId);
```

### Creating an Open Channel
```dart
chat.createOpenChannel(
    name: '<name_of_channel>', 
    userIds: ['user_id'])       // user ids of operators
```

### Sending a Message
```dart
chat.sendOpenChannelMessage(
        channelUrl: '<open_channels_url>',  // looks like sendbird_open_channel_XXXX_7c280d5d186be4ebf38a3e77b225040865eea22f
        originUserId: '<user_id_of_sender>',
        message: '<string_message>')
```


## Getting Started

For help modifying package code, view the
[plug-in package documentation](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter, view the
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

