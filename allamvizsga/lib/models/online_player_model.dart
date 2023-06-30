class OnlinePlayer {
  int? id;
  String? socketId;
  int? userId;
  String? userName;
  int? roomId;
  int? points;

  OnlinePlayer(
      {this.id,
      this.socketId,
      this.userId,
      this.userName,
      this.roomId,
      this.points});

  OnlinePlayer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    socketId = json['socketId'];
    userId = json['userId'];
    userName = json['userName'];
    roomId = json['roomId'];
    points = json['points'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['socketId'] = this.socketId;
    data['userId'] = this.userId;
    data['userName'] = this.userName;
    data['roomId'] = this.roomId;
    data['points'] = this.points;
    return data;
  }
}