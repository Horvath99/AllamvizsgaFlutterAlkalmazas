class LeaderboardModel {
  int? userId;
  String? username;
  double? aVG;

  LeaderboardModel({this.userId, this.username, this.aVG});

  LeaderboardModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    username = json['username'];
    aVG = json['AVG'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['username'] = this.username;
    data['AVG'] = this.aVG;
    return data;
  }
}