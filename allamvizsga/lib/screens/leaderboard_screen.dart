

import 'package:allamvizsga/models/leaderboard_model.dart';
import 'package:allamvizsga/services/api_service.dart';
import 'package:allamvizsga/utils/colors.dart';
import 'package:allamvizsga/widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LeaderboardScreen extends StatefulWidget {
  static String routName = '/leaderboard';
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<LeaderboardModel> leaderboardList = [];

@override
  void initState() {
    
    super.initState();
    APIService.getLeaderboardStats().then((value)  {
      setState(() {
        leaderboardList = value;
        leaderboardList.sort(((a, b) => b.aVG!.compareTo(a.aVG!)));
        
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:Scaffold(
        backgroundColor:BACKGROUND_COLOR,
        body: Container(
          child: Column(
            children:  [
                 _titleSection(context,"Ranglista"),
                 _topThreeContainer(context, leaderboardList),
                 _leaderBoardList(context, leaderboardList)
            ],
          ),
        ),));
    
  }

  Widget _titleSection(BuildContext context,String title){
        return  Center(
                child: Container(
                  margin: const EdgeInsets.only(top:20),
                  child: CustomText(
                    shadows:[
                      BoxShadow(blurRadius: 12,spreadRadius: 12,color: Colors.blue)
                      ], 
                    text: title, 
                    fontSize: 30),
                ),
              );
  }
  Widget _topThreeContainer(BuildContext context,List<LeaderboardModel> list){
    /*String first="",second="",third="";
    if(list.isNotEmpty){
      first = list[0].username!;
    }
    if(list.length-1>0){
      second = list[1].username!;
    }
    if(list.length>1){
      third = list[2].username!;
    }
    */
    
    return Container(
      margin: const EdgeInsets.only(top: 20),
      height: MediaQuery.of(context).size.height*0.3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 10,right: 0,top: 50),
            child: Column(
              children: [
                CustomText(shadows: const [
                  BoxShadow(
                    spreadRadius: 15,
                    blurRadius: 15,
                    color: Colors.grey
                  )
                ], text: (list.length - 1) > 0 ? list[1].username! : "-", 
                fontSize: 20),
                 CircleAvatar(
                  radius:MediaQuery.of(context).size.width*0.12,
                  backgroundImage: const AssetImage("images/majom.png"))
              ],
            )),
          Container(
            margin: const EdgeInsets.only(left: 10,right: 10),
            child: Column(
              children: [
                const FaIcon(FontAwesomeIcons.crown,color: Colors.yellow,),
                CustomText(shadows: const [
                  BoxShadow(
                    spreadRadius: 15,
                    blurRadius: 15,
                    color: Colors.yellow
                  )
                ], text: list.isNotEmpty ? list[0].username! : "-",
                fontSize: 20),
                 CircleAvatar(
                  radius:MediaQuery.of(context).size.width*0.14,
                  backgroundImage: const AssetImage("images/majom.png"))
              ],
            )),
          Container(
            margin: const EdgeInsets.only(left: 0,right: 10,top: 50),
            child: Column(
              children: [
                CustomText(shadows: const [
                  BoxShadow(
                    spreadRadius: 15,
                    blurRadius: 15,
                    color: Colors.brown
                  )
                ], text: (list.length - 1) > 1 ? list[2].username! : "-", 
                fontSize: 20),
                 CircleAvatar(
                  radius:MediaQuery.of(context).size.width*0.12,
                  backgroundImage: const AssetImage("images/majom.png"))
              ],
            )),
            ],
      ),
    );

  }
  Widget _leaderBoardList(BuildContext context,List<LeaderboardModel> userList){
        return Container(
          height: MediaQuery.of(context).size.height*0.5,
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height*0.49,
              child: ListView.builder(
                itemCount: leaderboardList.length,
                itemBuilder: (BuildContext context,index){
                  return Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      
                      border:Border.all(
                        color: index < 3 ? Colors.yellow : Colors.white,
                        width: 1
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(5)) ),
                    margin: const EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(shadows: [], text: "${index+1}. "+userList[index].username!, fontSize: 14),
                        SizedBox(width: 100,),
                        CustomText(shadows: [], text: "${(userList[index].aVG!)*100}%", fontSize: 14),
                      ],
                    ),
                  );
                }),
            )),
        );
  }

}


