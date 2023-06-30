import 'package:allamvizsga/provider/room_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScoreBoard extends StatelessWidget {
  const ScoreBoard({super.key});

  @override
  Widget build(BuildContext context) {
    RoomDataProvider roomDataProvider = Provider.of<RoomDataProvider>(context);
    var height =MediaQuery.of(context).size.height*0.12;
    var width =MediaQuery.of(context).size.width;
    print(roomDataProvider.player1.userName![0]);
    return Container(
      color: Colors.amber,
      height: height,
      width: width,
      child: 
       Row(
        
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _playerWidget( roomDataProvider.player1.userName!, roomDataProvider.player1.points!),
          _playerWidget( roomDataProvider.player2.userName!, roomDataProvider.player2.points!)
        ],
           ),
    );

  }
   Widget _playerWidget(String username,int points){
      return Container(
        child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(username),
                Text(points.toString())
              ], ),),
      );
    }
}