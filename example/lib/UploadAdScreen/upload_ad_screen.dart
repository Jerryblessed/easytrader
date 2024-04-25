import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

import 'package:buyer_seller_app/widgets/global_var.dart';
import 'package:buyer_seller_app/DialogBox/loading_dialog.dart';
import 'package:buyer_seller_app/HomeScreen/home_screen.dart';

class UploadAdScreen extends StatefulWidget {
  @override
  State<UploadAdScreen> createState() => _UploadAdScreenState();
}

class _UploadAdScreenState extends State<UploadAdScreen> {
  String postId = Uuid().v4();
  bool uploading = false, next = false;

  final List<File> _selectedImages = [];
  List<String> urlsList = [];

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String name = '';
  String phoneNos = '';
  double val = 0;

  String itemPrice = '';
  String itemname = '';
  String itemcolor = '';
  String itemDescription = '';

  @override
  void initState() {
    super.initState();
    getNameOfUser();
  }

  void getNameOfUser() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((snapshot) async {
      if (snapshot.exists) {
        setState(() {
          name = snapshot.data()!['userName'];
          phoneNos = snapshot.data()!['userNumber'];
        });
      }
    });
  }

  void chooseImage() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (pickedFile != null) {
      setState(() {
        _selectedImages.add(File(pickedFile.path));
      });
    } else {
      print('No image selected.');
    }
  }

  Future<void> uploadFile() async {
    int i = 1;
    for (var img in _selectedImages) {
      setState(() {
        val = i / _selectedImages.length;
      });

      var ref = FirebaseStorage.instance
          .ref()
          .child('image/${path.basename(img.path)}');

      await ref.putFile(img).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          urlsList.add(value);
          i++;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange, Colors.teal],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange, Colors.teal],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
          ),
          title: Text(
            next ? 'Please write Items Details' : 'Choose Item Images',
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 30,
              fontWeight: FontWeight.bold,
              fontFamily: 'Signatra',
            ),
          ),
          actions: [
            next
                ? Container()
                : ElevatedButton(
                    onPressed: () {
                      if (_selectedImages.length == 5) {
                        setState(() {
                          uploading = true;
                          next = true;
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select 5 images'),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      'Next',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Varela',
                      ),
                    ),
                  )
          ],
        ),
        body: next
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 20),
                      TextField(
                        decoration: const InputDecoration(
                          hintText: 'Enter Item Price',
                        ),
                        onChanged: (value) {
                          setState(() {
                            itemPrice = value;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      TextField(
                        decoration: const InputDecoration(
                          hintText: 'Enter Item name',
                        ),
                        onChanged: (value) {
                          setState(() {
                            itemname = value;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      TextField(
                        decoration: const InputDecoration(
                          hintText: 'Enter Item color',
                        ),
                        onChanged: (value) {
                          setState(() {
                            itemcolor = value;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      TextField(
                        decoration: const InputDecoration(
                          hintText: 'Enter Item Description',
                        ),
                        onChanged: (value) {
                          setState(() {
                            itemDescription = value;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: ((context) {
                                  return const LoadingAlerDialog(
                                      message: 'uploading....');
                                }));
                            uploadFile().whenComplete(() {
                              FirebaseFirestore.instance
                                  .collection('items')
                                  .doc(postId)
                                  .set({
                                'userName': name,
                                'id': _auth.currentUser!.uid,
                                'postId': postId, // Add the user ID here
                                'userNumber': phoneNos,
                                'itemPrice': itemPrice,
                                'itemname': itemname,
                                'itemcolor': itemcolor,
                                'itemDescription': itemDescription,
                                'urlIMage1': urlsList[0].toString(),
                                'urlIMage2': urlsList[1].toString(),
                                'urlIMage3': urlsList[2].toString(),
                                'urlIMage4': urlsList[3].toString(),
                                'urlIMage5': urlsList[4].toString(),
                                'imgPro': userImageUrl,
                                'lat': position!.latitude,
                                'long': position!.longitude,
                                'address': completeAddress,
                                'time': DateTime.now(),
                                'status': 'approved',
                              });
                              Fluttertoast.showToast(
                                  msg: 'Item uploaded successfully');
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()));
                            }).catchError((onError) {
                              print(onError);
                            });
                          },
                          child: const Text(
                            'Upload',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Varela',
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            : Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: GridView.builder(
                      itemCount: _selectedImages.length + 1,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 4.0,
                        mainAxisSpacing: 4.0,
                      ),
                      itemBuilder: (context, index) {
                        return index == 0
                            ? Center(
                                child: IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    !uploading ? chooseImage() : null;
                                  },
                                ),
                              )
                            : Container(
                                margin: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image:
                                        FileImage(_selectedImages[index - 1]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                      },
                    ),
                  ),
                  uploading
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Uploading...',
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(height: 10),
                              CircularProgressIndicator(
                                value: val,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    Colors.green),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                ],
              ),
      ),
    );
  }
}
