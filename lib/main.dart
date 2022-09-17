import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:band_names/screens/screens.dart';
import 'package:band_names/services/services.dart';



void main(){
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AppState());
}

class AppState extends StatelessWidget{
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers:[
      ChangeNotifierProvider(create: (_) => new SocketService()),
    ], child: const MyApp());
  }
}


class MyApp extends StatelessWidget{
  //CONSTRUCTOR
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Band Names',
      initialRoute: '/status',
      routes: {
        '/home': (BuildContext context) => const HomeScreen(),
        '/status': (BuildContext context) => const StatusScreen(),
      },
    );
  }




}