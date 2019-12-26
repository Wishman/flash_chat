import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  // 1.1
  static String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                  //Do something with the user input.
                },
                decoration: kTextFieldDecoration),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              obscureText: true, // 8.5(d) obscure password
              textAlign: TextAlign.center, // 8.5(d)
              onChanged: (value) {
                //Do something with the user input.
              },
              decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your password'),
            ),
            SizedBox(
              height: 24.0,
            ),
            RoundedButton(colour: Colors.lightBlueAccent, title: 'Log In', onTapped: null), //5.8
          ],
        ),
      ),
    );
  }
}
