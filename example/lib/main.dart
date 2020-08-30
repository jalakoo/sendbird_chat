import 'package:flutter/material.dart';
import 'dart:async';

import 'open_channel_selection.dart';
import 'sendbird_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'user_selection.dart';
import 'open_channel_selection.dart';
import 'chat.dart';
// import 'route_aware.dart';

// final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

Future main() async {
  await DotEnv().load('.env');
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final SendbirdModel _sendbird = SendbirdModel();

  @override
  void initState() {
    super.initState();
    String appId = DotEnv().env['APP_ID'];
    String token = DotEnv().env['API_TOKEN'];
    try {
      this._sendbird.init(appId, token);
      this._sendbird.refreshUsers();
    } catch (e) {
      print('main.dart: initState: Problem initializing sendbird model: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SendbirdModel>.value(value: _sendbird),
      ],
      child: MaterialApp(
          theme: new ThemeData(
            primarySwatch: Colors.blue,
          ),
          debugShowCheckedModeBanner: false,
          home: UserSelectionPage(),
          // navigatorObservers: [
          //   routeObserver
          // ],
          // routes: {
          //   '/home': (context) =>
          //       RouteAwareWidget('/home', child: UserSelectionPage()),
          //   '/open_channel': (context) => RouteAwareWidget('/open_channel',
          //       child: OpenChannelSelectionPage()),
          // }
          routes: <String, WidgetBuilder>{
            '/home': (context) => UserSelectionPage(),
            '/open_channel': (context) => OpenChannelSelectionPage(),
            '/chat': (context) => ChatPage(),
          }),
    );
  }
}
