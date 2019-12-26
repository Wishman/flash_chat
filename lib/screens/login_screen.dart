import 'package:firebase_auth/firebase_auth.dart'; // 9.1
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  // 1.1
  static String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 9.2
  final _auth = FirebaseAuth.instance;
  String email;
  String password;

  // Fleißaufgabe - AlertDialog bei LoginError!
  void _showDialog(String errCode) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("ERROR!"),
          content: new Text(errCode),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // 2.3
            Hero(
              tag: 'logo',
              child: Container(
                height: 200.0,
                child: Image.asset('images/logo.png'),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            TextField(
                keyboardType: TextInputType.emailAddress, // 8.5(d)
                textAlign: TextAlign.center, // 8.5(d)
                onChanged: (value) {
                  email = value; // 9.3
                },
                decoration: kTextFieldDecoration),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              obscureText: true, // 8.5(d) obscure password
              textAlign: TextAlign.center, // 8.5(d)
              onChanged: (value) {
                password = value; // 9.3
              },
              decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your password'),
            ),
            SizedBox(
              height: 24.0,
            ),
            RoundedButton(
                colour: Colors.lightBlueAccent,
                title: 'Log In',
                onTapped: () async {
                  // 9.4
                  try {
                    final user = await _auth.signInWithEmailAndPassword(email: email, password: password);
                    if (user != null) {
                      Navigator.pushNamed(context, ChatScreen.id);
                    }
                  } catch (e) {
                    print('It\s an $e!');
                    _showDialog(e.code); // call AlertDialog with error message
                  }
                }), //5.8
          ],
        ),
      ),
    );
  }
}
