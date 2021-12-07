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
      appBar: AppBar(
        title: Text('SignIn'),
      ),
      body: Form(
        key: _formkey,
        child: Column(
          children: <Widget>[
            TextFormField(
              // ignore: missing_return
              validator: (input) {
                if (input.isEmpty) {
                  return 'Please type an email';
                }
              },
              onSaved: (input) => _email = input,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              // ignore: missing_return
              validator: (input) {
                if (input.isEmpty) {
                  return 'Please type an password';
                }
              },
              onSaved: (input) => _password = input,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: signIn,
              child: Text('Entrar'),
            )
          ],
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
        Navigator.push(
            //context, MaterialPageRoute(builder: (context) => Home()));
            context,
            MaterialPageRoute(builder: (context) => UserProducts()));
      } catch (e) {
        print(e.message);
      }
    }
  }
}
