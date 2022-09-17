
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
  IO.Socket? _socket;

  // Constructor
  SocketService(){
    this._initConfig();

  }

  // Getters and setters
  ServerStatus get serverStatus => this._serverStatus;
  IO.Socket get socket => this._socket!;


  // Methods

  void _initConfig(){

     this._socket = IO.io('http://localhost:3000/',{
      'transports': ['websocket'],
      'autoConnect': true,
    });

     this._socket!.onConnect((_) {
      print('connect');
      this._serverStatus = ServerStatus.Online; // Cambiar el estado de la conexión
      notifyListeners();
    });

     this._socket!.onDisconnect((_) {
      print('disconnect');
      this._serverStatus = ServerStatus.Offline; // Cambiar el estado de la conexión
      notifyListeners();
    });

/*     this._socket!.on('newMessage',(payload){
      print('newMessage:');
      print('name: ${payload['name']}');
      print('message: ${payload['message']}');
      notifyListeners();
    });*/


  }



}