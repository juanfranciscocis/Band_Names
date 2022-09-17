import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/socket_service.dart';

class StatusScreen extends StatelessWidget{
  const StatusScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${socketService.serverStatus}'),
            SizedBox(height: 20,),
            FloatingActionButton(onPressed: (){
              //Tarea emitir
              socketService.socket.emit('newMessage',{'name': 'Juan Francisco Cisneros', 'message': 'envio un mensaje a todos'});
            },
            child: Icon(Icons.message),
            ),
          ],
        ),
      ),
    );
  }
}