import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart'; // 4.1
import 'package:flash_chat/components/rounded_button.dart'; // 5.6

class WelcomeScreen extends StatefulWidget {
  // 1.1
  static String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  // 3.1 (a)

  AnimationController controller; // 3.1(b)
  Animation animation; // 3.4(a)

  // 3.1(c)
  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this, // reference to SingleTickerProviderStateMixin in this class
      duration: Duration(seconds: 1),
      //upperBound: 100, // 3.2(a)
      upperBound: 1, // 3.4(c) -> if value is 1, no need to state as default!
    );

    // animation = CurvedAnimation(parent: controller, curve: Curves.decelerate); // 3.4(b) & 3.8(a)

    controller.forward(); // 3.1(d) & 3.6(d)
    //controller.reverse(from: 1.0); // 3.5(b) either forward or backward! & 3.6(d)

    /* 3.8(a)
    // 3.6 a,b,c loop animation
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse(from: 1.0);
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });
    */

    // animation = ColorTween(begin: Colors.red, end: Colors.blue).animate(controller); // 3.8(b)
    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white).animate(controller); // 3.9
    // 3.1(e)
    controller.addListener(() {
      setState(() {
        // 3.1(g)
      });
      //print(animation.value);
    });
  }

  // 3.7 dispose animation controller to free resources when screen is dismissed
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.red.withOpacity(controller.value), // 3.1 (f)
      //backgroundColor: Colors.white, // 3.2(b)
      backgroundColor: animation.value, // 3.8(d)
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                // 2.1 wrap Container in Hero Widget
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    //height: controller.value, // 3.3(b)
                    //height: animation.value * 100, //3.4(d),
                    height: 60.0, // 3.8(c)
                  ),
                ),
                // 4.2
                TypewriterAnimatedTextKit(
                  //'${controller.value.toInt()}%', // 3.2(c)
                  text: ['Flash Chat'], // 3.3(a) & 4.3
                  isRepeatingAnimation: false, // 4.5 if you want to stop after first
                  textStyle: TextStyle(
                    // 4.4
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            new RoundedButton(
              title: 'Log In',
              colour: Colors.lightBlueAccent,
              onTapped: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ), // 5.5
            new RoundedButton(
                colour: Colors.blueAccent,
                title: 'Register',
                onTapped: () {
                  Navigator.pushNamed(context, RegistrationScreen.id);
                }), // 5.7
          ],
        ),
      ),
    );
  }
}
