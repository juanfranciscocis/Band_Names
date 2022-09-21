import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../services/socket_service.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Band> bands = [
/*    Band(id: '1', name: 'Metallica', votes: 5),
    Band(id: '2', name: 'Queen', votes: 1),
    Band(id: '3', name: 'Héroes del Silencio', votes: 2),
    Band(id: '4', name: 'Bon Jovi', votes: 5),*/
  ];


  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on('active-bands', (payload){
      this.bands = (payload as List).map((band) => Band.fromMap(band)).toList();
      setState(() {
      });
    });
    super.initState();
  }


  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      //backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Band Names', style: TextStyle(color: Colors.white)),
        //backgroundColor: Colors.white,
        elevation: 5,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20),
            child : (socketService.serverStatus == ServerStatus.Online ) ? Icon(Icons.check_circle, color: Colors.green, size: 35,) : Icon(Icons.offline_bolt_rounded, color: Colors.redAccent, size: 35,),
          )
        ],
      ),
      body: Column(
        children: [

          SizedBox(height: 20,),

          Padding(
            padding: const EdgeInsets.all(10),
            child: _showGraph(),
          ),

          SizedBox(height: 20,),

          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    //color: Colors.transparent,
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Dismissible(
                      key: Key(bands[index].id),
                      direction: DismissDirection.startToEnd,
                      background: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                        ),
                        color: Colors.red,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Delete', style: TextStyle(color: Colors.white, fontSize: 20))
                          ),
                        ),
                      ),
                      onDismissed: (DismissDirection direction) {
                        setState(() {
                          socketService.socket.emit('delete-band', {'id': bands[index].id});
                          bands.removeAt(index);
                        });

                      },
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(bands[index].name.substring(0,2), style: const TextStyle(color: Colors.amber)),
                            backgroundColor: Colors.amber[100],
                          ),
                          title: Text(bands[index].name, style: const TextStyle(fontSize: 25),),
                          trailing: Text('${bands[index].votes}', style: const TextStyle(fontSize: 20)),
                          onTap: (){
                            socketService.socket.emit('vote-band', {'id': bands[index].id});
                            print('VOTED ${bands[index].id}');
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add,),
        elevation: 10,
        onPressed: (){
          _addNewBand();
        },
      ),
    );
  }

  _addNewBand(){
    final textController = TextEditingController();
    if(Platform.isAndroid) {
      showDialog(context: context, builder: (context) {
        return AlertDialog(
          title: const Text('New Band Name'),
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(
              hintText: 'Band Name',
              labelText: 'Band Name',
            ),
            onChanged: (value) {},
          ),
          actions: [
            MaterialButton(
              child: const Text('Add'),
              elevation: 10,
              textColor: Colors.amber,
              onPressed: () => _addBandToList(textController.text),

            )
          ],
        );
      });
    }else{
      showCupertinoDialog(context: context, builder: (context){
        return CupertinoAlertDialog(
          title: Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: const Text('New Band Name'),
          ),
          content: CupertinoTextField(
            controller: textController,
            onChanged: (value) {},
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text('Add'),
              isDefaultAction: true,
              onPressed: () => _addBandToList(textController.text),
            ),
            CupertinoDialogAction(
              child: const Text('Dismiss'),
              isDestructiveAction: true,
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      });
    }
  }

  _addBandToList(String name){
    if(name.length > 1){

      final socketService = Provider.of<SocketService>(context, listen: false);
      socketService.socket.emit('add-band', {'name': name});
      setState(() {

      });

    }
    Navigator.pop(context);
  }

  Widget _showGraph(){

    Map<String, double> dataMap = {
    };
    bands.forEach((band) {
      dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
    });





    return dataMap.length == 0?Container(child: CircularProgressIndicator(color: Colors.amber,),): PieChart(
      dataMap: dataMap,
      chartType: ChartType.ring,
      chartValuesOptions: ChartValuesOptions(
        showChartValuesInPercentage: true,
      ),
      baseChartColor: Colors.grey[50]!.withOpacity(0.15),
    );

  }







}