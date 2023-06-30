import 'dart:developer';

import 'package:allamvizsga/provider/room_data_provider.dart';
import 'package:allamvizsga/screens/online_game_screen.dart';
import 'package:allamvizsga/services/shared_service.dart';
import 'package:allamvizsga/widgets.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'package:allamvizsga/resources/socket_client.dart';

class SocketMethods {
  final _socketClient = SocketClient.instance.socket;

  Socket get socketClient => _socketClient;

  //EMITS
  void createRoom(String roomName, String roomPassword, String rounds) {
    if (roomName.isNotEmpty) {
      _socketClient.emit('createRoom', {
        'userName': SharedService.userName,
        'roomName': roomName,
        'roomPassword': roomPassword,
        'userId': SharedService.userId.toString(),
        'rounds': rounds
      });
    } else {
      Fluttertoast.showToast(
          msg: "Give room name",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey[600],
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void joinRoom(String roomId) {
    if (roomId.isNotEmpty) {
      socketClient.emit('joinRoom', {
        'userName': SharedService.userName,
        'roomId': int.parse(roomId),
        'userId': SharedService.userId
      });
    }
  }

  //LISTENERS
  void createRoomSuccesListener(BuildContext context) {
    _socketClient.on('createRoomSucces', (room) {
      if (room is Map<String, dynamic>) {
        print("SUCCEEEEEEEEEEEEEEEES");
        Provider.of<RoomDataProvider>(context, listen: false)
            .updateRoomData(room);
       Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => OnlineGameScreen()),
);
      } else {
        print(room);
      }
    });
  }

  void updateRoomListener(BuildContext context){
    _socketClient.on('updateRoom',(data)=>{
      Provider.of<RoomDataProvider>(context,listen:false).updateRoomData(data)
    });
  }

  void joinRoomSuccesListener(BuildContext context){
    _socketClient.on('joinRoomSucces',(room){
      if (room is Map<String, dynamic>) {
        log("BEJOTT");
        Provider.of<RoomDataProvider>(context, listen: false)
            .updateRoomData(room);
        Navigator.pushNamed(context, OnlineGameScreen.routName);
      } else {
        print(room);
      }
    });
  }

  void errorOccuredListener(BuildContext context){
    _socketClient.on('errorOcurred',(data){
      showSnackBar(context, data);
    });
  }

  void updatePlayersStateListener(BuildContext context){
    _socketClient.on('updatePlayers',(playerData){
      Provider.of<RoomDataProvider>(context,listen:false).updatePlayer1(playerData[0]);
      Provider.of<RoomDataProvider>(context,listen:false).updatePlayer2(playerData[1]);
    });
  }

}
