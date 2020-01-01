import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // 8.6(a)
import 'package:flutter/services.dart';
import 'chat_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart'; // 10.1

class RegistrationScreen extends StatefulWidget {
  //1.1
  static String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // 8.6(b)
  final _auth = FirebaseAuth.instance;
  // 8.1
  String email;
  String password;

  bool showSpinner = false; // 10.2

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // 15.1
              Flexible(
                // 2.2
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress, // 8.5(c)
                textAlign: TextAlign.center, // 8.5(a)
                onChanged: (value) {
                  email = value; // 8.2
                },
                decoration: kTextFieldDecoration, // 5.10b
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true, // 8.5(b) obscure password
                textAlign: TextAlign.center, // 8.5(a)
                onChanged: (value) {
                  password = value; // 8.3
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your password'), // 5.10c
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                colour: Colors.blueAccent,
                title: 'Register',
                onTapped: () async {
                  setState(() {
                    showSpinner = true; // 10.4
                  });
                  // 8.4
//                  print(email);
//                  print(password);
                  try {
                    // 8.6(c)
                    final newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);
                    if (newUser != null) {
                      Navigator.pushNamed(context, ChatScreen.id);
                    } // got registered user back -> go to chat screen
                    setState(() {
                      showSpinner = false; // 10.5
                    });
                  } catch (e) {
                    print(e);
                  }
                },
              ), // 5.9
            ],
          ),
        ),
      ),
    );
  }
}
