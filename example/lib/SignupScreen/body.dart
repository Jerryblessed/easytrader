// import 'dart:io';

// import 'package:buyer_seller_app/DialogBox/error_dialog.dart';
// import 'package:buyer_seller_app/ForgetPassword/forget_password.dart';
// import 'package:buyer_seller_app/HomeScreen/home_screen.dart';
// import 'package:buyer_seller_app/LoginScreen/login_screen.dart';
// import 'package:buyer_seller_app/SignupScreen/background.dart';
// import 'package:buyer_seller_app/widgets/already_have_an_account.dart';
// import 'package:buyer_seller_app/widgets/global_var.dart';
// import 'package:buyer_seller_app/widgets/rounded_button.dart';
// import 'package:buyer_seller_app/widgets/rounded_input_field.dart';
// import 'package:buyer_seller_app/widgets/rounded_password_field.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';

// class SignupBody extends StatefulWidget {
//   @override
//   State<SignupBody> createState() => _SignupBodyState();
// }

// class _SignupBodyState extends State<SignupBody> {

//   String userPhotoUrl = '';

//   File? _image;

//   bool _isLoading = false;

//   final signUpFormKey = GlobalKey<FormState>();

//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   void _getFromCamera() async {
//     final XFile? pickedFile =
//         await ImagePicker().pickImage(source: ImageSource.camera);
//     if (pickedFile != null) {
//       _cropImage(pickedFile.path);
//     }
//     Navigator.pop(context);
//   }

//   void _getFromGallery() async {
//     final XFile? pickedFile =
//         await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       _cropImage(pickedFile.path);
//     }
//     Navigator.pop(context);
//   }

//   void _cropImage(String filepath) async {
//     final croppedFile = await ImageCropper().cropImage(
//       sourcePath: filepath,
//       maxHeight: 1020,
//       maxWidth: 1080,
//     );
//     if (croppedFile != null) {
//       setState(() {
//         _image = File(croppedFile.path);
//       });
//     }
//   }

//   void _showImageDialog() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Please choose an option'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               InkWell(
//                 onTap: _getFromCamera,
//                 child: const Row(
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: Icon(
//                         Icons.camera,
//                         color: Colors.purple,
//                       ),
//                     ),
//                     Text(
//                       'Camera',
//                       style: TextStyle(color: Colors.purple),
//                     ),
//                   ],
//                 ),
//               ),
//               InkWell(
//                 onTap: _getFromGallery,
//                 child: const Row(
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: Icon(
//                         Icons.photo_library,
//                         color: Colors.purple,
//                       ),
//                     ),
//                     Text(
//                       'Gallery',
//                       style: TextStyle(color: Colors.purple),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void submitFormOnSignUp() async {
//     final isValid = signUpFormKey.currentState!.validate();
//     if (!isValid) {
//       if (_image == null) {
//         showDialog(
//             context: context,
//             builder: (context) {
//               return const ErrorAlertDialog(
//                 message: 'Please select an image',
//               );
//             });
//       }
//     }
//     signUpFormKey.currentState!.save();
//     setState(() {
//       _isLoading = true;
//     });
//     // Implement the signup functionality here
//     try {
//       await _auth.createUserWithEmailAndPassword(
//         email: _emailController.text.toLowerCase(),
//         password: _passwordController.text.trim(),
//       );

//       final User? user = _auth.currentUser;
//       uid = user!.uid;

//       final ref = FirebaseStorage.instance
//           .ref()
//           .child('userImages')
//           .child(uid + '.jpg');
//       await ref.putFile(_image!);
//       userPhotoUrl = await ref.getDownloadURL();

//       FirebaseFirestore.instance.collection('users').doc(uid).set(
//         {
//         'userName': _nameController.text,
//         'id': uid,
//         'userNumber': _phoneController.text.trim(),
//         'userEmail': _emailController.text.trim(),
//         'userPhotoUrl': userPhotoUrl,
//         'time': DateTime.now(),
//         'status': 'approved',
//       }
//       );

//       Navigator.pushReplacement(context,
//         MaterialPageRoute(builder: (context) => HomeScreen()));

//     }
//     catch (error)
//     {
//       setState(() {
//         _isLoading = false;
//       });
//       ErrorAlertDialog(message: error.toString(),);
//       }
//     }
//     setState(() {
//       _isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;

//     return SingupBackground(
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Form(
//               key: signUpFormKey,
//               child: InkWell(
//                 onTap: _showImageDialog,
//                 child: CircleAvatar(
//                   radius: screenWidth * 0.15,
//                   backgroundColor: Colors.white24,
//                   backgroundImage: _image == null ? null : FileImage(_image!),
//                   child: _image == null
//                       ? Icon(
//                           Icons.camera_alt,
//                           size: screenWidth * 0.15,
//                           color: Colors.black54,
//                         )
//                       : null,
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: screenHeight * 0.2,
//             ),
//             RoundedInputField(
//               hintText: "Name",
//               icon: Icons.person,
//               onChanged: (value) {
//                 _nameController.text = value;
//               },
//             ),
//             RoundedInputField(
//               hintText: "Email",
//               icon: Icons.email,
//               onChanged: (value) {
//                 _emailController.text = value;
//               },
//             ),
//             RoundedInputField(
//               hintText: "Phone",
//               icon: Icons.phone,
//               onChanged: (value) {
//                 _phoneController.text = value;
//               },
//             ),
//             RoundedPasswordField(
//               onChanged: (value) {
//                 _passwordController.text = value;
//               },
//             ),
//             const SizedBox(height: 5),
//             Align(
//               alignment: Alignment.centerRight,
//               child: TextButton(
//                 onPressed: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => ForgetPasssword()));
//                 },
//                 child: const Text(
//                   'Forgot Password?',
//                   style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 15,
//                       fontStyle: FontStyle.italic),
//                 ),
//               ),
//             ),
//             _isLoading
//                 ? Center(
//                     child: Container(
//                       width: 70,
//                       height: 70,
//                       child: const CircularProgressIndicator(),
//                     ),
//                   )
//                 : RoundedButton(
//                     text: "SIGNUP",
//                     press: () {
//                       submitFormOnSignUp();
//                       // submitformonsignup
//                     },
//                   ),
//             SizedBox(
//               height: screenHeight * 0.1,
//             ),
//             AlreadyHaveAccountCheck(
//               login: false,
//               press: () {
//                 Navigator.pop(context,
//                     MaterialPageRoute(builder: (context) => LoginScreen()));
//               },
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';

import 'package:buyer_seller_app/DialogBox/error_dialog.dart';
import 'package:buyer_seller_app/ForgetPassword/forget_password.dart';
import 'package:buyer_seller_app/HomeScreen/home_screen.dart';
import 'package:buyer_seller_app/LoginScreen/login_screen.dart';
import 'package:buyer_seller_app/SignupScreen/background.dart';
import 'package:buyer_seller_app/widgets/already_have_an_account.dart';
import 'package:buyer_seller_app/widgets/global_var.dart';
import 'package:buyer_seller_app/widgets/rounded_button.dart';
import 'package:buyer_seller_app/widgets/rounded_input_field.dart';
import 'package:buyer_seller_app/widgets/rounded_password_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class SignupBody extends StatefulWidget {
  @override
  State<SignupBody> createState() => _SignupBodyState();
}

class _SignupBodyState extends State<SignupBody> {
  String userPhotoUrl = '';
  File? _image;
  bool _isLoading = false;
  final signUpFormKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _getFromCamera() async {
    final XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _cropImage(pickedFile.path);
    }
    Navigator.pop(context);
  }

  void _getFromGallery() async {
    final XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _cropImage(pickedFile.path);
    }
    Navigator.pop(context);
  }

  void _cropImage(String filepath) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: filepath,
      maxHeight: 1020,
      maxWidth: 1080,
    );
    if (croppedFile != null) {
      setState(() {
        _image = File(croppedFile.path);
      });
    }
  }

  void _showImageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Please choose an option'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: _getFromCamera,
                child: const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.camera,
                        color: Colors.purple,
                      ),
                    ),
                    Text(
                      'Camera',
                      style: TextStyle(color: Colors.purple),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: _getFromGallery,
                child: const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.photo_library,
                        color: Colors.purple,
                      ),
                    ),
                    Text(
                      'Gallery',
                      style: TextStyle(color: Colors.purple),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void submitFormOnSignUp() async {
    final isValid = signUpFormKey.currentState!.validate();
    if (!isValid) {
      if (_image == null) {
        showDialog(
          context: context,
          builder: (context) {
            return ErrorAlertDialog(message: 'Please select an image');
          },
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }
    }
    signUpFormKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.toLowerCase(),
        password: _passwordController.text.trim(),
      );

      final User? user = _auth.currentUser;
      uid = user!.uid;

      final ref = FirebaseStorage.instance
          .ref()
          .child('userImages')
          .child(uid + '.jpg');
      await ref.putFile(_image!);
      userPhotoUrl = await ref.getDownloadURL();

      FirebaseFirestore.instance.collection('users').doc(uid).set(
        {
          'userName': _nameController.text,
          'id': uid,
          'userNumber': _phoneController.text.trim(),
          'userEmail': _emailController.text.trim(),
          'userPhotoUrl': userPhotoUrl,
          'time': DateTime.now(),
          'status': 'approved',
        },
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      showDialog(
        context: context,
        builder: (context) {
          return ErrorAlertDialog(message: error.toString());
        },
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SingupBackground(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: signUpFormKey,
              child: InkWell(
                onTap: _showImageDialog,
                child: CircleAvatar(
                  radius: screenWidth * 0.15,
                  backgroundColor: Colors.white24,
                  backgroundImage: _image == null ? null : FileImage(_image!),
                  child: _image == null
                      ? Icon(
                          Icons.camera_alt,
                          size: screenWidth * 0.15,
                          color: Colors.black54,
                        )
                      : null,
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.2,
            ),
            RoundedInputField(
              hintText: "Name",
              icon: Icons.person,
              onChanged: (value) {
                _nameController.text = value;
              },
            ),
            RoundedInputField(
              hintText: "Email",
              icon: Icons.email,
              onChanged: (value) {
                _emailController.text = value;
              },
            ),
            RoundedInputField(
              hintText: "Phone",
              icon: Icons.phone,
              onChanged: (value) {
                _phoneController.text = value;
              },
            ),
            RoundedPasswordField(
              onChanged: (value) {
                _passwordController.text = value;
              },
            ),
            const SizedBox(height: 5),
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
                  'Forgot Password?',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
            _isLoading
                ? Center(
                    child: Container(
                      width: 70,
                      height: 70,
                      child: const CircularProgressIndicator(),
                    ),
                  )
                : RoundedButton(
                    text: "SIGNUP",
                    press: () {
                      submitFormOnSignUp();
                    },
                  ),
            SizedBox(
              height: screenHeight * 0.1,
            ),
            AlreadyHaveAccountCheck(
              login: false,
              press: () {
                Navigator.pop(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
