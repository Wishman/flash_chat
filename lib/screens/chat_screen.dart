import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart'; // 8.7(a)

class ChatScreen extends StatefulWidget {
  // 1.1
  static String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance; // 8.7(b)
  FirebaseUser loggedInUser; //8.7(d)

  // 8.7(g) - trigger getCurrentUser from initState()
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  // 8.7(c)
  void getCurrentUser() async {
    //logic to check if current user is signed in:
    try {
      final user = await _auth.currentUser(); // 8.7(c)
      if (user != null) {
        // not null = have a signed in user{
        loggedInUser = user; // 8.7(e)
        print(loggedInUser.email); // just to check
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        //Do something with the user input.
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      //Implement send functionality.
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
