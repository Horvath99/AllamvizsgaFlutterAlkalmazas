import 'package:allamvizsga/config.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:allamvizsga/config.dart';

class SocketClient {
  late IO.Socket socket;

  static late  SocketClient _instance;

  SocketClient._internal() {
   
    socket = IO.io('http://${Config.apiURL}', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    
    socket.connect();
    
  

  }
  static SocketClient get instance {
    _instance = SocketClient._internal();
    return _instance;
  }
}


