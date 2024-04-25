import 'package:buyer_seller_app/LoginScreen/login_screen.dart';
import 'package:buyer_seller_app/SignupScreen/signup_screen.dart';
import 'package:buyer_seller_app/WelcomeScreen/blackground.dart';
import 'package:buyer_seller_app/widgets/rounded_button.dart';
import 'package:flutter/material.dart';

class WelcomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return WelcomeBackground(
      child: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Jesus Loves you',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 60,
              color: Colors.black54,
              fontFamily: 'Signatra',
            ),
          ),
          SizedBox(height: size.height * 0.05),
          Image.asset(
            'assets/icons/icons/chat.png',
            height: size.height * 0.45,
          ),
          RoundedButton(
            text: 'LOGIN',
            press: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
          ),
          RoundedButton(
            text: 'SIGN UP',
            press: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => SignupScreen()));
            },
          ),
        ],
      )),
    );
  }
}
