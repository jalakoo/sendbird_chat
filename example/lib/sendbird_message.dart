import 'sendbird_user.dart';

class SendbirdMessage {
  const SendbirdMessage(
    this.user,
    this.messageId,
    this.message,
  );
  final SendbirdUser user;
  final int messageId;
  final String message;

  SendbirdMessage.fromJson(Map<String, dynamic> json)
      : this.user = SendbirdUser.fromJson(json['user']),
        this.messageId = json['message_id'],
        this.message = json['message'];

  Map<String, dynamic> toJson() => {
        "user": this.user.toJson(),
        "message_id": this.messageId,
        "message": this.message,
      };
}
