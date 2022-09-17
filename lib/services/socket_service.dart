
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting
}

class SocketService with ChangeNotifier{

  // Data members
  ServerStatus _serverStatus = ServerStatus.Connecting;

  // Constructor
  SocketService(){
    this._initConfig();

  }

  // Getters and setters
  ServerStatus get serverStatus => this._serverStatus;

  // Methods

  void _initConfig(){

    IO.Socket socket = IO.io('http://localhost:3000/',{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket.onConnect((_) {
      print('connect');
      this._serverStatus = ServerStatus.Online; // Cambiar el estado de la conexión
      notifyListeners();
    });

    socket.onDisconnect((_) {
      print('disconnect');
      this._serverStatus = ServerStatus.Offline; // Cambiar el estado de la conexión
      notifyListeners();
    });

    socket.on('newMessage',(payload){
      print('newMessage:');
      print('name: ${payload['name']}');
      print('message: ${payload['message']}');
      notifyListeners();
    });


  }



}