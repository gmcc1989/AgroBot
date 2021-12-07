// ignore: unused_import
import 'package:agrobotApp/pages/setup/signIn.dart';
import 'package:agrobotApp/pages/setup/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String _email, _password;
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
              onPressed: signUp,
              child: Text('Registrar'),
            )
          ],
        ),
      ),
    );
  }

  void signUp() async {
    // Validacao dos campos
    final formState = _formkey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        // ignore: unused_local_variable
        UserCredential newuser = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password);
        // ignore: unused_local_variable
        newuser.user.sendEmailVerification();
        Navigator.of(context).pop();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => WelcomePage()));
      } catch (e) {
        print(e.message);
      }
    }
  }
}
