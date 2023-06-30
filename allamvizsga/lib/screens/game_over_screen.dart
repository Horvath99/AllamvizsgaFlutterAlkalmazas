import 'package:allamvizsga/utils/colors.dart';
import 'package:allamvizsga/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class GameOver extends StatefulWidget {
  static String routName="/gameover";
  const GameOver({Key? key}) : super(key: key);

  @override
  State<GameOver> createState() => _GameOverState();
}

class _GameOverState extends State<GameOver> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BACKGROUND_COLOR,
      body: SafeArea(
        child:Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
               Container(
                margin: const EdgeInsets.all(10),
                 child: const CustomText(
                  shadows:  [
                    BoxShadow(
                      spreadRadius: 2,
                      blurRadius: 5,
                      color: Colors.red
                    )
                  ], 
                  text: "Game Over", 
                  fontSize: 50),
               ),
               Container(
                alignment: Alignment.bottomLeft,
                margin: const EdgeInsets.all(10),
                 child: const CustomText(
                  shadows:  [
                    BoxShadow(
                      spreadRadius: 2,
                      blurRadius: 5,
                      color: Colors.red
                    )
                  ], 
                  text: "Nezd meg mit rontottal el:", 
                  fontSize: 15),
               ),
               Container(
                margin: EdgeInsets.only(left: 100,right: 100),
                 child: CustomButton(onTap: (){
                  Navigator.pushNamedAndRemoveUntil(
                          context, "/home", (route) => false);
                 }, text: "Vissza a Menube"),
               )
            ]),) ),
    );
  }
}