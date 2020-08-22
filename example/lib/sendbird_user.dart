class SendbirdUser {
  const SendbirdUser(
    this.userId,
    this.nickname,
    this.profileUrl,
  );
  final String userId;
  final String nickname;
  final String profileUrl;

  // TODO: Support these properties
  // final String phoneNumber;
  // final List preferredLanguages;
  // final double createdAt;
  // final bool isActive;
  // final bool isOnline;
  // final String lastSeenAt;
  // final bool hasEverLoggedIn;
  // final Map discoveryKeys;
  // final bool requireAuthForProfileImage;
  // final Map metadata;

  SendbirdUser.fromJson(Map<String, dynamic> json)
      : this.userId = json['user_id'],
        this.nickname = json['nickname'],
        this.profileUrl = json['profile_url'];

  Map<String, dynamic> toJson() => {
        "user_id": this.userId,
        "nickname": this.nickname,
        "profile_url": this.profileUrl,
      };
}
