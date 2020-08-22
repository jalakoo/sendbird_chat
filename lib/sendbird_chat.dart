// You have generated a new plugin project without
// specifying the `--platforms` flag. A plugin project supports no platforms is generated.
// To add platforms, run `flutter create -t plugin --platforms <platforms> .` under the same
// directory. You can also find a detailed instruction on how to add platforms in the `pubspec.yaml` at https://flutter.dev/docs/development/packages-and-plugins/developing-packages#plugin-platforms.

import 'dart:async';
import 'rest.dart';

class SendbirdChat {
  String _usersApi;
  String _openChannelsApi;
  Map<String, String> _defaultHeaders;
  Rest _rest = Rest();

  SendbirdChat({String applicationId, String apiToken}) {
    this._usersApi = "https://api-$applicationId.sendbird.com/v3/users/";
    this._openChannelsApi =
        "https://api-$applicationId.sendbird.com/v3/open_channels/";
    this._defaultHeaders = {
      'Content-Type': 'application/json',
      'Api-Token': apiToken,
    };
  }

  // USERS
  Future listUsers() async {
    var result = await this._rest.getFrom(this._usersApi, this._defaultHeaders);
    print('sendbird_chat.dart: listUsers: result: $result');
    return result["users"];
  }

  Future createUser(String userId) async {
    Map<String, dynamic> body = {
      'user_id': userId,
      'nickname': userId,
      'profile_url': ""
    };
    var result =
        await this._rest.postTo(this._usersApi, this._defaultHeaders, body);
    print('sendbird_chat.dart: createUser: result: $result');
    return result;
  }

  Future<bool> deleteUser(String userId) async {
    String parentURL = this._usersApi;
    String finalURL = '$parentURL$userId';
    var result = await this._rest.delete(finalURL, this._defaultHeaders);
    print('sendbird_chat.dart: deleteUser: url: $finalURL result: $result');
    return result;
  }

  // OPEN CHANNELS
  Future<List> listOpenChannels() async {
    var result =
        await this._rest.getFrom(this._openChannelsApi, this._defaultHeaders);
    print('sendbird_chat.dart: listOpenChannels: result: $result');
    return result["channels"];
  }

  Future createOpenChannel({String name, List<String> userIds}) async {
    Map<String, dynamic> body = {
      'name': name,
      'operator_ids': userIds,
    };
    var result = await this
        ._rest
        .postTo(this._openChannelsApi, this._defaultHeaders, body);
    print('sendbird_chat.dart: createOpenChannel: result: $result');
    return result;
  }

  Future<bool> deleteOpenChannel(String channelUrl) async {
    String parentURL = this._openChannelsApi;
    String finalURL = '$parentURL$channelUrl';
    var result = await this._rest.delete(finalURL, this._defaultHeaders);
    print(
        'sendbird_chat.dart: deleteOpenChannel: url: $finalURL result: $result');
    return result;
  }

  Future<List> getOpenChannelMessages(String channelUrl) async {
    String parentURL = this._openChannelsApi;
    String now = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    String finalURL = '$parentURL$channelUrl/messages?message_ts=$now';
    var result = await this._rest.getFrom(finalURL, this._defaultHeaders);
    print(
        'sendbird_chat.dart: getOpenChannelMessages: url: $finalURL, result: $result');
    return result["messages"];
  }

  Future<void> sendOpenChannelMessage(
      {String channelUrl, String originUserId, String message}) async {
    String parentURL = this._openChannelsApi;
    String finalURL = '$parentURL$channelUrl/messages';
    Map<String, dynamic> body = {
      'message_type': 'MESG',
      'user_id': originUserId,
      'message': message,
    };
    var result = await this._rest.postTo(finalURL, this._defaultHeaders, body);
    print('sendbird_chat.dart: getOpenChannel: url: $finalURL result: $result');
    return result;
  }
}
