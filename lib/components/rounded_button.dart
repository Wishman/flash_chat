import 'package:flutter/material.dart';

// 5.6
// 5.1
class RoundedButton extends StatelessWidget {
  // 5.2
  final Color colour;
  final String title;
  final Function onTapped; // could also be named onPressed - diff here for clarity

  RoundedButton({this.colour, this.title, @required this.onTapped}); // 5.3

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: colour, //5.4(a)
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onTapped, // 5.4(c)
          /* old
            //1.3 Go to login screen.
            // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen())); // V1
            Navigator.pushNamed(context, LoginScreen.id); // V2 with pushNamed and static ids!

             */
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            title, // 5.4(b)
            style: TextStyle(color: Colors.white), // 5.12
          ),
        ),
      ),
    );
  }
}
