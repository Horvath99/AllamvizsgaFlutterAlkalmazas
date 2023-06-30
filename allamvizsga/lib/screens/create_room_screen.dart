import 'package:allamvizsga/resources/socket_methods.dart';
import 'package:allamvizsga/utils/colors.dart';
import 'package:allamvizsga/utils/responsive.dart';
import 'package:allamvizsga/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import  'package:socket_io_client/socket_io_client.dart' as IO;

class CreateRoomScreen extends StatefulWidget {
  static String routName = "/createRoom";
  const CreateRoomScreen({Key? key}) : super(key: key);

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _roundsController = TextEditingController();
   late final  _socketInstance;

  @override
  void initState() {
    
    super.initState();
    _socketInstance=SocketMethods();
    _socketInstance.createRoomSuccesListener(context);
   
  }

  @override
  void dispose() {
    
    super.dispose();
    _nameController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    
    return SafeArea(
        child: Responsive(
        child: Scaffold(
          backgroundColor: BACKGROUND_COLOR,
          body: SizedBox(child: _createRoomUI(context),
        ),
      )
      )
    );
  }

  Widget _createRoomUI(BuildContext context){
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
               text: "Create Room", 
               fontSize: 45),
               SizedBox(height: size.height*0.05,),
               Container(
                width: size.width*0.8,
                 child: CustomTextField(
                  controller: _nameController, 
                  hintText: "Enter your name"),
               ),
               SizedBox(height: size.height*0.001,),
               Container(
                width: size.width*0.8,
                 child: CustomTextField(
                  controller: _passwordController, 
                  hintText: "Enter room password"),
               ),
               SizedBox(height: size.height*0.001,),
               Container(
                width: size.width*0.8,
                 child: CustomTextField(
                  controller: _roundsController, 
                  hintText: "Enter rounds"),
               ),
               SizedBox(height: size.height*0.001,),
               Container(
                margin: EdgeInsets.only(top: size.height*0.05),
                width: size.width*0.3,
                 child: CustomButton(onTap: ()=> {_socketInstance.createRoom(_nameController.text,_passwordController.text,_roundsController.text)}, 
                 text: "Create"),
               )
            ],
          ),
        );
  }
}
