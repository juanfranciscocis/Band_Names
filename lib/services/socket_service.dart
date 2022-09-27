
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
  Function get emit => this._socket!.emit;


  // Methods

  void _initConfig(){

     this._socket = IO.io('https://flutter-bands-socket-server-jc.herokuapp.com',{
      'transports': ['websocket'],
      'autoConnect': true,
    });

     this._socket!.onConnect((_) {
      print('connected');
      this._serverStatus = ServerStatus.Online; // Cambiar el estado de la conexión
      notifyListeners();
    });

     this._socket!.onDisconnect((_) {
      print('disconnect');
      this._serverStatus = ServerStatus.Offline; // Cambiar el estado de la conexión
      notifyListeners();
    });






  }



}