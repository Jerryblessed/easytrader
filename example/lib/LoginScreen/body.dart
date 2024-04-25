// Remove unused import
// import 'dart:js';

import 'package:buyer_seller_app/DialogBox/error_dialog.dart';
import 'package:buyer_seller_app/DialogBox/loading_dialog.dart';
import 'package:buyer_seller_app/ForgetPassword/forget_password.dart'; // Corrected import filename
import 'package:buyer_seller_app/HomeScreen/home_screen.dart';
import 'package:buyer_seller_app/LoginScreen/background.dart'; // Check if this import is correct
import 'package:buyer_seller_app/SignupScreen/signup_screen.dart';
import 'package:buyer_seller_app/widgets/already_have_an_account.dart';
import 'package:buyer_seller_app/widgets/rounded_button.dart';
import 'package:buyer_seller_app/widgets/rounded_input_field.dart';
import 'package:buyer_seller_app/widgets/rounded_password_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginBody extends StatefulWidget {
  @override
  State<LoginBody> createState() => _LoginBodyState();
}

final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();
final FirebaseAuth _auth = FirebaseAuth.instance;

void _login(BuildContext context) async {
  showDialog(
    context: context,
    builder: (_) {
      return const LoadingAlerDialog(
        message: 'Please wait...',
      );
    },
  );
  User? currentUser;
  await _auth
      .signInWithEmailAndPassword(
    email: _emailController.text.trim(),
    password: _passwordController.text.trim(),
  )
      .then((auth) {
    currentUser = auth.user;
  }).catchError((error) {
    Navigator.pop(context);
    showDialog(
        context: context,
        builder: (context) {
          return ErrorAlertDialog(
            message: error.message != null
                ? error.message.toString()
                : "An error occurred",
          );
        });
  });

  if (currentUser != null) {
    Navigator.pop(context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return HomeScreen();
        },
      ),
    );
  } else {
    print('error');
  }
}

class _LoginBodyState extends State<LoginBody> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return LoginBackground(
      // Removed 'const' as LoginBackground is not a const constructor
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: size.height * 0.05),
            Image.asset(
              'assets/icons/icons/login.png',
              height: size.height * 0.32,
            ),
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
              hintText: 'Your Email',
              icon: Icons.person,
              onChanged: (value) {
                _emailController.text = value;
              },
            ),
            SizedBox(height: size.height * 0.03),
            RoundedPasswordField(
              onChanged: (value) {
                _passwordController.text = value;
              },
            ),
            const SizedBox(height: 3),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ForgetPasssword(),
                    ),
                  );
                },
                child: const Text(
                  'Forgot Password',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
            RoundedButton(
              text: "LOGIN",
              press: () {
                _emailController.text.isNotEmpty &&
                        _passwordController.text.isNotEmpty
                    ? _login(context)
                    : showDialog(
                        context: context,
                        builder: (context) {
                          return const ErrorAlertDialog(
                              message: 'Please write email and password');
                        });
              },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAccountCheck(
              login: true,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignupScreen();
                    },
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
