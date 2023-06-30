

import 'dart:convert';

LoginResponseModel loginResponseJson(String str) =>
LoginResponseModel.fromJson(json.decode(str));

class LoginResponseModel {
  int? succes;
  int? userId;
  String? userName;
  String? message;
  String? token;

  LoginResponseModel({this.succes, this.userId,this.userName,this.message, this.token});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    succes = json['succes'];
    userId = json['userId'];
    userName = json['userName'];
    message = json['message'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['succes'] = this.succes;
    data['userId'] = this.userId;
    data['userName'] = this.userName;
    data['message'] = this.message;
    data['token'] = this.token;
    return data;
  }
}
