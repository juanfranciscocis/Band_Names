import 'package:flutter/material.dart';

import 'package:band_names/screens/screens.dart';


void main(){
  runApp(const MyApp());
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