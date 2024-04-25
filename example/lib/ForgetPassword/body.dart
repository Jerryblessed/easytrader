import 'package:buyer_seller_app/DialogBox/error_dialog.dart';
import 'package:buyer_seller_app/ForgetPassword/background.dart';
import 'package:buyer_seller_app/LoginScreen/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgetBody extends StatefulWidget {
  @override
  State<ForgetBody> createState() => _ForgetBodyState();
}

class _ForgetBodyState extends State<ForgetBody> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _forgetpassTextController =
      TextEditingController(text: '');

  void _forgetPassSubmitform() async {
    try {
      await _auth.sendPasswordResetEmail(email: _forgetpassTextController.text);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } catch (error) {
      ErrorAlertDialog(
        message: error.toString(),
      );
    }
    // Add code here
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return ForgetBackground(
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ListView(
              children: [
                SizedBox(
                  height: size.height * 0.2,
                ),
                Text(
                  "Forget Password",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Bebas',
                    fontSize: 55,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Enter your email",
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _forgetpassTextController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _forgetPassSubmitform();
                    // Add code here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black54,
                    elevation: 20,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    "Send",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
