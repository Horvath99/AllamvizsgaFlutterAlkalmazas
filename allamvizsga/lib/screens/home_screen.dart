import 'package:allamvizsga/screens/flash_quiz_screen.dart';
import 'package:allamvizsga/screens/leaderboard_screen.dart';
import 'package:allamvizsga/services/api_service.dart';
import 'package:allamvizsga/services/shared_service.dart';
import 'package:allamvizsga/utils/colors.dart';
import 'package:allamvizsga/widgets.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        /*appBar: AppBar(
          leading: IconButton(
            icon:Icon(Icons.exit_to_app),
            onPressed: (){
              SharedService.logout(context);
            },),
        ),*/
        backgroundColor: BACKGROUND_COLOR,
        body: _homeWidget(context),
      )
      );
  }
  Widget _homeWidget(BuildContext context){
    return SingleChildScrollView(
      child:Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //fejlec
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height/5,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end:Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  BACKGROUND_COLOR,
                ]),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                )
            ),
          ),
          const SizedBox(height: 20,),
          //alcim
          const Padding(
            padding:  EdgeInsets.only(
              left: 10
            ),
            child: CustomText(
              shadows: [
                BoxShadow(
                  color: Colors.blue,
                  spreadRadius: 5,
                  blurRadius: 15
                )
              ], text: "PLAY", fontSize: 25),
          ),
          //play sor
          SingleChildScrollView(
            scrollDirection:Axis.horizontal,
            child: Row(
              children: [
                _buildCard(context, const Icon(Icons.play_circle),"Offline",(){
                  Navigator.pushNamed(context, '/startQuiz');}),
                const SizedBox(width: 5,),
                _buildCard(context, const Icon(Icons.play_arrow),"Online",(){
                  Navigator.pushNamed(context, '/enterRoom');
                }),
                const SizedBox(width: 5,),
                _buildCard(context, const Icon(Icons.flash_auto_sharp),"Flash Quiz",(){
                  Navigator.pushNamed(context, FlashQuizScreen.routName);
                }),
              ]),
          ),
          //alcim
          const Padding(
            padding:  EdgeInsets.only(
              left: 10,
              top:20,
            ),
            child: CustomText(
              shadows: [
                BoxShadow(
                  color: Colors.blue,
                  spreadRadius: 5,
                  blurRadius: 15
                )
              ], text: "PROFILE", fontSize: 25),
          ),
          //profile sor
          SingleChildScrollView(
            scrollDirection:Axis.horizontal,
            child: Row(
              children: [
                _buildCard(context, const Icon(Icons.person),"My profile",(){
                  Navigator.pushNamedAndRemoveUntil(context, '/profile', (route) => false);
                }),
                const SizedBox(width: 5,),
                _buildCard(context, const Icon(Icons.update),"Update Profile",(){}),
                const SizedBox(width: 5,),
                _buildCard(context, const Icon(Icons.security),"Change password",(){}),
                const SizedBox(width: 5,),
                _buildCard(context, const Icon(Icons.exit_to_app),"Log Out",(){SharedService.logout(context);}),

              ]),
          ),
          //alcim
          const Padding(
            padding:  EdgeInsets.only(
              left: 10,
              top:20,
            ),
            child: CustomText(
              shadows: [
                BoxShadow(
                  color: Colors.blue,
                  spreadRadius: 5,
                  blurRadius: 15
                )
              ], text: "SETTINGS", fontSize: 25),
          ),
          //Settings sor
          SingleChildScrollView(
            scrollDirection:Axis.horizontal,
            child: Row(
              children: [
                _buildCard(context, const Icon(Icons.dangerous),"Difficulty",(){
                  showDialog(
                    context: context, builder: (BuildContext context){
                      return AlertDialog(
                        title: Text('Válaszd ki a kivánt nehézséget.'),
                        content: Text('A nehézseg kiválasztásával,a kérdések tipusát választod ki.'),
                        actions: [
                            Container(
                              margin: const EdgeInsets.all(5),
                              child: CustomButton(onTap: (){
                                setState(() {
                                  SharedService.difficulty="Nehez";
                                });
                              }, text: "Nehez")),
                            Container(
                              margin: const EdgeInsets.all(5),
                              child: CustomButton(onTap: (){
                                SharedService.difficulty="Kozepes";
                              }, text: "Kozepes")),
                            Container(
                              margin: const EdgeInsets.all(5),
                              child: CustomButton(onTap: (){
                                SharedService.difficulty="Konnyu";
                              }, text: "Konnyu"))
                        ]
                      );
                    });
                }),
                const SizedBox(width: 5,),
                _buildCard(context, const Icon(Icons.language),"Languange",(){
                    showDialog(
                    context: context, builder: (BuildContext context){
                      return AlertDialog(
                        title: Text('Válaszd ki a kivánt nyelvet.'),
                        content: Text('A nyelv kivalasztasaval atalitod az egesz applikacio nyelvet,jatekmodot,kerdeseket'),
                        actions: [
                            Container(
                              margin: const EdgeInsets.all(5),
                              child: CustomButton(onTap: (){
                              }, text: "Magyar")),
                            Container(
                              margin: const EdgeInsets.all(5),
                              child: CustomButton(onTap: (){
                              }, text: "Angol")),
                        ]
                      );
                    });
                }),
              ]),
          ),
          //alcim
          const Padding(
            padding:  EdgeInsets.only(
              left: 10,
              top:20,
            ),
            child: CustomText(
              shadows: [
                BoxShadow(
                  color: Colors.blue,
                  spreadRadius: 5,
                  blurRadius: 15
                )
              ], text: "STATISTICS", fontSize: 25),
          ),
          SingleChildScrollView(
            scrollDirection:Axis.horizontal,
            child: Row(
              children: [
                _buildCard(context, const Icon(Icons.games),"Offline stats",(){
                   Navigator.pushNamed(context, '/statistics');
                }),
                const SizedBox(width: 5,),
                _buildCard(context, const Icon(Icons.king_bed),"Online",(){}),
                const SizedBox(width: 5,),
                _buildCard(context, const Icon(Icons.leaderboard),"Ranglista",(){
                   Navigator.pushNamed(context, LeaderboardScreen.routName);
                }),
                const SizedBox(width: 5,),
                _buildCard(context, const Icon(Icons.school),"Flash Quizes",(){
                 
                }),
              ]),
          ),
          

        
        ]) 
        ,);

  }
  Widget _buildCard(BuildContext context,Icon w_icon,String text,VoidCallback function){
    return Container(
      child: Column(
        children: [
          IconButton(
          iconSize: 50,
          tooltip: "alma",
          color:Colors.white,
          icon:w_icon,
          onPressed: (){
            setState(() {
               function();
            });
          },),
          Text(
            text,
            style: const TextStyle(color: Colors.white),
            )
        ]
      ),
    );
  }
}
