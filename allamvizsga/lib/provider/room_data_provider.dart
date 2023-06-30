import 'package:allamvizsga/models/online_player_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoomDataProvider extends ChangeNotifier{
    Map<String,dynamic> _roomData = {};

    OnlinePlayer _player1 = OnlinePlayer(
      userName: 'aa', 
      userId: 0, 
      roomId: 0, 
      socketId: '', 
      points: 0);
      
    OnlinePlayer _player2 = OnlinePlayer(
      userName: 'aa', 
      userId: 0, 
      roomId: 0, 
      socketId: '', 
      points: 0);

    Map<String,dynamic> get roomData => _roomData;
    OnlinePlayer get player1 => _player1;
    OnlinePlayer get player2 => _player2;

    void updateRoomData(Map<String,dynamic> data){
      _roomData = data;
      notifyListeners();
    }

    void updatePlayer1(Map<String,dynamic> player1Data){
      _player1 = OnlinePlayer.fromJson(player1Data);
    }
     void updatePlayer2(Map<String,dynamic> player2Data){
      _player2= OnlinePlayer.fromJson(player2Data);
      
    }
}