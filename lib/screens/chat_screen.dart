import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart'; // 8.7(a)
import 'package:cloud_firestore/cloud_firestore.dart'; // 11.1

final _firestore = Firestore.instance; // 11.4 & 14.16(d)
FirebaseUser loggedInUser; //8.7(d) & 15.4(d)

class ChatScreen extends StatefulWidget {
  // 1.1
  static String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController(); // 14.17(a)
  final _auth = FirebaseAuth.instance; // 8.7(b)

  String messageText; // 11.2

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
        //print(loggedInUser.email); // just to check
      }
    } catch (e) {
      print(e);
    }
  }

  /* 12.3
  // 12.1 SELECT -> returns Future!
  void getMessages() async {
    // getDocuments is a pull version that returns a List
    final messages = await _firestore.collection('messages').getDocuments(); // 12.1
    for (var message in messages.documents) {
      print(message.data);
    }
  }
   */

  /* 15.7
  // 12.4 method listens to messages from FireStore (Firestore QuerySnapshot)
  void messagesStream() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      // .snapshots returns Stream of QuerySnapshots
      for (var message in snapshot.documents) {
        // now loop through returned list
        print(message.data);
      }
    }
  }
   */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                // 15.7
                //messagesStream(); // 12.5
                //getMessages(); // 12.2
                _auth.signOut(); // 9.5
                Navigator.pop(context); // 9.6
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
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController, // 14.17(b)
                      onChanged: (value) {
                        messageText = value; // 11.3
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      // 14.17(c) clear TextField when pressed
                      messageTextController.clear();
                      // 11.5 INSERT data into Firestore
                      _firestore.collection('messages').add({
                        'text': messageText,
                        'sender': loggedInUser.email,
                      });
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

// 14.16(a)
class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 13.1 & 14.16(b)
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').snapshots(), // 13.1(a)
      // ignore: missing_return
      builder: (context, snapshot) {
        // 13.1(b) first check if snapshot has data!
        if (!snapshot.hasData) {
          // 13.2 if snapshot has no data -> show spinner:
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        } else {
          // 13.1(c) & 15.6
          final messages = snapshot.data.documents.reversed; // needs <QuerySnapshot> above to access .documents
          List<MessageBubble> messageBubbles = []; // List of Text Widgets to be created & 14.6
          // 13.1 (d) use FOR_LOOP to create TextWidgets:
          for (var message in messages) {
            final messageText = message.data['text']; // different from snapshot.data!!!
            final messageSender = message.data['sender'];

            final currentUser = loggedInUser.email; // 15.4(b)

            // // 14.4 create new widget - initially of Type Text, now of custom Type MessageBubble
            final messageBubble = MessageBubble(
              sender: messageSender,
              text: messageText,
              isMe: currentUser == messageSender, // 15.4(d)
            );
            messageBubbles.add(messageBubble); // add new MessageWidget to List of Widgets
          }
          // return Column(children: messageWidgets); // 13.1(e) return column with list of text widgets-
          // OBSOLETE per 14.1
          // 14.1
          return Expanded(
            child: ListView(
              reverse: true, // 15.5 Listview now sticky towards bottom of view
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0), // 14.2
              children: messageBubbles,
            ),
          );
        }
      }, // builder: logic what StreamBuilder should do when rebuilding |
      // builder snapshot is not the same as Firebase QuerySnapshot above!!, it's a Flutter AsyncSnapshot,
      // but contains QuerySnapshot!
    );
  }
}

// 14.3(a)
class MessageBubble extends StatelessWidget {
  // 14.3(c)
  final String sender;
  final String text;
  // 15.4(c)
  final bool isMe;

  MessageBubble({this.sender, this.text, this.isMe}); // 14.3(d) & 15.4(c)

  @override
  Widget build(BuildContext context) {
    // 14.8
    return Padding(
      padding: EdgeInsets.all(10.0),
      // 14.13
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start, // 14.15 & 15.4(g)
        children: <Widget>[
          // 14.14
          Text(
            sender,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          // 14.7(a)
          Material(
            // 14.12 - obsolete with 15.3
            //borderRadius: BorderRadius.circular(30.0),
            // 15.3 & 15.4(h)
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  )
                : BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  ),
            // 14.11
            elevation: 5.0,
            //14.7(b) & 15.4(e)
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            // 14.10
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                // 14.3(b)&(e)
                text,
                // 14.9
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black54, // 15.4(f)
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
