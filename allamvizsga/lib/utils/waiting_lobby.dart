import 'package:allamvizsga/provider/room_data_provider.dart';
import 'package:allamvizsga/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WaitingLobby extends StatefulWidget {
  const WaitingLobby({super.key});

  @override
  State<WaitingLobby> createState() => _WaitingLobbyState();
}

class _WaitingLobbyState extends State<WaitingLobby> {
  late TextEditingController roomIdController;

  @override
  void initState() {
    super.initState();
    roomIdController = TextEditingController(
      text: Provider.of<RoomDataProvider>(context,listen:false).roomData['id'].toString()
    );
  }

  @override
  void dispose() {
    
    super.dispose();
    roomIdController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Waiting for a player to join...'),
        SizedBox(height: 20,),
        CustomTextField(controller: roomIdController, hintText: '',isReadOnly: true,)
      ],
    );
  }
}