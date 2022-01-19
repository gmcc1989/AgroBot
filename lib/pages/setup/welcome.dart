import 'package:agrobotApp/pages/setup/signIn.dart';

import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("lib/assets/images/tela_inicial.png"),
              fit: BoxFit.fitHeight
              )
            ),

          child: Column(
              children: [LinearProgressIndicator()],
          ),
      ),
    );
  }
}
