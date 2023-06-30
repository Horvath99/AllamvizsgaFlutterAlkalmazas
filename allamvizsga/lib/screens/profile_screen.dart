import 'package:allamvizsga/utils/colors.dart';
import 'package:allamvizsga/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: BACKGROUND_COLOR,
      body: _profileWidget(context),
    ));
  }

  Widget _profileWidget(BuildContext context) {
    var coverHeight =  MediaQuery.of(context).size.height * 0.25;
    var profilePictureHeight = MediaQuery.of(context).size.height * 0.10;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment : CrossAxisAlignment.start,
        children: [
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height:coverHeight,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.white54, BACKGROUND_COLOR])),
            ),
            Positioned(
              top:coverHeight - profilePictureHeight,
              child:  CircleAvatar(
                radius: profilePictureHeight,
                backgroundImage: AssetImage("images/majom.png"),
              ),
            )
          ],
        ),
        const SizedBox(height: 65,),
        labelWithText(context,"Felhasználó név:", "Horvath János"),
        labelWithText(context, "Email cim", "horvathjanos@student"),
        labelWithText(context, "Telefon szám:", "0770348637"),
        labelWithText(context, "teszt", "teszt"),
        labelWithText(context, "teszt", "teszt"),
         
      ]),
    );
  }
}

Widget labelWithText(BuildContext context,String labelName,String text){
  return Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(left: 15,top: 20,right: 15),
          padding: const  EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
              width: 1.0,
              style: BorderStyle.solid
            ),
            borderRadius: BorderRadius.all(Radius.elliptical(13, 15)) 
            ),
          child: Column(
            children: [
            CustomText(shadows: const [
              BoxShadow(
                color: Colors.blue,
                spreadRadius: 2,
                blurRadius: 5
              )
            ], 
            text: labelName, 
            fontSize: 20),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text(
                text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 23
              ),),
            )
          ],
          )
          );
}