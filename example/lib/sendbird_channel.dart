import 'sendbird_user.dart';

class SendbirdChannel {
  const SendbirdChannel(
    this.name,
    this.channelUrl,
    this.operators,
  );
  final String name;
  final String channelUrl;
  final List<SendbirdUser> operators;

  SendbirdChannel.fromJson(Map<String, dynamic> json)
      : this.name = json['name'],
        this.channelUrl = json['channel_url'],
        this.operators = json['operators']
            .forEach((jsonItem) => {SendbirdUser.fromJson(jsonItem)});

  Map<String, dynamic> toJson() => {
        "name": this.name,
        "channel_url": this.channelUrl,
        "operators": operatorsAsJSON(this.operators),
      };

  List<Map> operatorsAsJSON(List<SendbirdUser> users) {
    List<Map> result = [];
    users.forEach((element) => result.add(element.toJson()));
    return result;
  }
}
