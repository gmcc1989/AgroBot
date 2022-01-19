import 'package:agrobotApp/pages/setup/signIn.dart';
import 'package:agrobotApp/pages/setup/welcome.dart';
import 'package:flutter/material.dart';
// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';

//  ----- TO DO-------
// 1. Ajeitar a página dos slaves. Carregar em cada aba os valores corretos do T20, T40 e Vin
// 2. Refazer o TO DO

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agrobot Signin',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: WelcomePage(),
    );
  }
}
