import 'package:allamvizsga/resources/socket_methods.dart';
import 'package:allamvizsga/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../utils/responsive.dart';
import '../widgets.dart';

class JoinRoomScreen extends StatefulWidget {
  static String routName = "/joinRoom";
  const JoinRoomScreen({Key? key}) : super(key: key);

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _gameIdController = TextEditingController();
  final SocketMethods _socketMethods = SocketMethods();

  @override
  void initState() {

    super.initState();
    _socketMethods.joinRoomSuccesListener(context);
    _socketMethods.errorOccuredListener(context);
    _socketMethods.updatePlayersStateListener(context);
  }

  @override
  void dispose() {
    super.dispose();
    _gameIdController.dispose();
    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Responsive(
        child: Scaffold(
          backgroundColor: BACKGROUND_COLOR,
          body: SizedBox(child: _joinRoomUI(context),
        ),
      )
      )
    );
  }
   Widget _joinRoomUI(BuildContext context){
        

        final size = MediaQuery.of(context).size;
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:  [
              const CustomText(shadows:
               [BoxShadow(
                color: Colors.blue,
                blurRadius: 40,
                spreadRadius: 5
               )], 
               text: "Join Room", 
               fontSize: 45),
               SizedBox(height: size.height*0.05,),
               Container(
                width: size.width*0.8,
                 child: CustomTextField(
                  controller: _gameIdController, 
                  hintText: "Enter room id"),
               ),
               SizedBox(height: size.height*0.001,),
               Container(
                margin: EdgeInsets.only(top: size.height*0.05),
                width: size.width*0.3,
                 child: CustomButton(onTap: (){_socketMethods.joinRoom(_gameIdController.text);}, 
                 text: "Join"),
               )
            ],
          ),
        );
  }
}