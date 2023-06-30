 import 'package:allamvizsga/screens/create_room_screen.dart';
import 'package:allamvizsga/screens/joing_room_screen.dart';
import 'package:allamvizsga/utils/colors.dart';
import 'package:allamvizsga/utils/responsive.dart';
import 'package:allamvizsga/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class EnterRoomScreen extends StatefulWidget {
  const EnterRoomScreen({Key? key}) : super(key: key);

  @override
  State<EnterRoomScreen> createState() => _EnterRoomScreenState();
}

class _EnterRoomScreenState extends State<EnterRoomScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: BACKGROUND_COLOR,
        body: Responsive(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width:  MediaQuery.of(context).size.width,
            child: _enterRoomUI(context),
          ),
        ),
      ),
    );
  }

  Widget _enterRoomUI(BuildContext context){
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    void createRoom(BuildContext context){
      Navigator.pushNamed(context, CreateRoomScreen.routName);
    }
     void joinRoom(BuildContext context){
      Navigator.pushNamed(context, JoinRoomScreen.routName);
    }
    return Container(
      margin: EdgeInsets.only(top: height*0.3),
      child: Column(
        children:  [
           const CustomText(
            shadows: [
              BoxShadow(
                color: Colors.blue,
                spreadRadius: 2,
                blurRadius: 5
              )
            ], 
            text: "Enter or Join Room", 
            fontSize: 27),
            Container(
              width: width*0.65,
              margin: EdgeInsets.only(top: height*0.05),
              child: CustomButton(
                onTap:()=>createRoom(context), 
                text: "Create Room"),
            ),
             Container(
              width: width*0.65,
              margin: EdgeInsets.only(top: height*0.02),
              child: CustomButton(
                onTap:()=>joinRoom(context), 
                text: "Join Room"),
            ),
        ],
      ),
    );
  }
}