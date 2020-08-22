import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sendbird_chat/sendbird_chat.dart';
import 'sendbird_user.dart';
import 'sendbird_channel.dart';
import 'sendbird_message.dart';

class SendbirdModel extends ChangeNotifier {
  SendbirdChat _chat;
  List<SendbirdUser> _users = new List<SendbirdUser>();
  List<SendbirdChannel> _openChannels = new List<SendbirdChannel>();
  SendbirdUser _currentUser;
  SendbirdChannel _currentChannel = new SendbirdChannel("", "", []);
  List<SendbirdMessage> _currentMessages = new List<SendbirdMessage>();

  void init(String appId, String token) async {
    this._chat = SendbirdChat(applicationId: appId, apiToken: token);
  }

  refreshUsers() async {
    // TODO: Error handling
    List currentUsers = await _chat.listUsers();
    _users = [];
    currentUsers.forEach((user) => _users.add(SendbirdUser.fromJson(user)));
    notifyListeners();
  }

  List<SendbirdUser> users() {
    // TODO: Cache
    return this._users;
  }

  Future createUser(String userId) async {
    await this._chat.createUser(userId);
    refreshUsers();
  }

  Future deleteUser(SendbirdUser user) async {
    this._users.remove(user);
    await this._chat.deleteUser(user.userId);
    refreshUsers();
  }

  refreshOpenChannels() async {
    List currentChannels = await _chat.listOpenChannels();
    _openChannels = [];
    currentChannels.forEach(
        (channel) => _openChannels.add(SendbirdChannel.fromJson(channel)));
    notifyListeners();
  }

  List<SendbirdChannel> channels() {
    // TODO: Cache
    return this._openChannels;
  }

  SendbirdChannel channel() {
    return this._currentChannel;
  }

  void setChannel(SendbirdChannel channel) {
    this._currentMessages.clear();
    this._currentChannel = channel;
  }

  Future createOpenChannel(String name, List<SendbirdUser> users) async {
    List<String> operators = [];
    users.forEach((user) => operators.add(user.userId));
    await this._chat.createOpenChannel(name: name, userIds: operators);
    refreshOpenChannels();
  }

  Future deleteOpenChannel(SendbirdChannel channel) async {
    this._openChannels.remove(channel);
    await this._chat.deleteOpenChannel(channel.channelUrl);
    refreshOpenChannels();
  }

  // MESSAGES
  Future<List<SendbirdMessage>> getOpenChannelMessages() async {
    String channelUrl = this._currentChannel.channelUrl;
    List messages = await this._chat.getOpenChannelMessages(channelUrl);
    List<SendbirdMessage> result = new List<SendbirdMessage>();
    if (messages.length > 0) {
      messages.forEach(
          (message) => {result.add(SendbirdMessage.fromJson(message))});
    }
    return result;
  }

  Future<void> refreshOpenChannelMessages() async {
    this._currentMessages = await getOpenChannelMessages();
    notifyListeners();
  }

  Future<void> sendOpenChannelMessage(String message) async {
    await this._chat.sendOpenChannelMessage(
        channelUrl: this._currentChannel.channelUrl,
        originUserId: this._currentUser.userId,
        message: message);
    List<SendbirdMessage> messages = await getOpenChannelMessages();
    this._currentMessages.clear();
    this._currentMessages = messages;
    notifyListeners();
  }

  List<SendbirdMessage> messages() {
    return this._currentMessages;
  }

  SendbirdUser user() {
    return this._currentUser;
  }

  void setUser(SendbirdUser user) {
    this._currentUser = user;
  }
}
