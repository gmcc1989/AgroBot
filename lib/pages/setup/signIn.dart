// ignore: unused_import
import 'package:agrobotApp/pages/UserProducts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // ignore: unused_field
  String _email, _password;
  // ignore: unused_field
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(backgroundColor: Colors.transparent),
      body: Form(
        key: _formkey,
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("lib/assets/images/agro.jpg"),
                  fit: BoxFit.cover
                 )
              ),
          child: Column(
            children: <Widget>[
              Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  Column(
                    
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                        child: Image.asset(
                          "lib/assets/images/logotransp.png",
                          width: 130,
                          height: 130,
                          fit: BoxFit.contain,
                        ),
                      ),
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintStyle: TextStyle(
                              color: Colors.white,
                              fontFamily: "WorkSansLight",
                              fontSize: 15.0),
                          filled: true,
                          fillColor: Colors.white24,
                          hintText: "E-mail",
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(90.0)),
                              borderSide: BorderSide(
                                  color: Colors.white24, width: 0.5)),
                          prefixIcon: const Icon(
                            Icons.email,
                            color: Colors.white,
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        // ignore: missing_return
                        validator: (input) {
                          if (input.isEmpty) {
                            return 'Digite um email válido';
                          }
                        },
                        onSaved: (input) => _email = input,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintStyle: TextStyle(
                              color: Colors.white,
                              fontFamily: "WorkSansLight",
                              fontSize: 15.0),
                          filled: true,
                          fillColor: Colors.white24,
                          hintText: "Senha",
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(90.0)),
                              borderSide: BorderSide(
                                  color: Colors.white24, width: 0.5)),
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: Colors.white,
                          ),
                        ),
                        obscureText: true,
                        // ignore: missing_return
                        validator: (input) {
                          if (input.isEmpty) {
                            return 'Digite sua senha';
                          }
                        },
                        onSaved: (input) => _password = input,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      SizedBox(
                        height: 80,
                        width: 180,
                        child: new FloatingActionButton(
                          backgroundColor: Colors.white30,
                          child: Text(
                            "Entrar",
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          onPressed: signIn,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signIn() async {
    // Validacao dos campos
    final formState = _formkey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        // ignore: unused_local_variable
        UserCredential user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);
        //Navigator.push(
        Navigator.pushReplacement(
            //context, MaterialPageRoute(builder: (context) => Home()));
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => UserProducts()));
      } catch (e) {
        print(e.message);
      }
    }
  }
}
