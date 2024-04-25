import 'package:buyer_seller_app/ImageSliderScreen/image_slider_screen.dart';
import 'package:buyer_seller_app/widgets/global_var.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class ListviewWidget extends StatefulWidget {
  final String docId,
      itemcolor,
      img1,
      img2,
      img3,
      img4,
      img5,
      userImg,
      name,
      userId,
      itemname,
      postId;
  final String itemPrice, itemDescription, address, userNumber;
  final DateTime date;
  final double lat, long;

  ListviewWidget({
    required this.docId,
    required this.itemcolor,
    required this.img1,
    required this.img2,
    required this.img3,
    required this.img4,
    required this.img5,
    required this.userImg,
    required this.name,
    required this.userId,
    required this.itemname,
    required this.postId,
    required this.itemPrice,
    required this.itemDescription,
    required this.address,
    required this.userNumber,
    required this.date,
    required this.lat,
    required this.long,
  });

  @override
  State<ListviewWidget> createState() => _ListviewWidgetState();
}

class _ListviewWidgetState extends State<ListviewWidget> {
  Future<void> showDialogForupdateData(selectDoc, oldUsername, oldPhoneNumber,
      oldItemprice, oldItemName, olditemcolor, oldtemDescription) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: const Text(
              'Update Data',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: oldUsername,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    hintText: 'Enter your username',
                  ),
                  onChanged: (value) {
                    setState(() {
                      oldUsername = value;
                    });
                  },
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  initialValue: oldPhoneNumber,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    hintText: 'Enter your phone number',
                  ),
                  onChanged: (value) {
                    setState(() {
                      oldPhoneNumber = value;
                    });
                  },
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  initialValue: olditemcolor,
                  decoration: const InputDecoration(
                    labelText: 'Item Color',
                    hintText: 'Enter your item color',
                  ),
                  onChanged: (value) {
                    setState(() {
                      olditemcolor = value;
                    });
                  },
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  initialValue: oldtemDescription,
                  decoration: const InputDecoration(
                    labelText: 'Item Description',
                    hintText: 'Enter your item description',
                  ),
                  onChanged: (value) {
                    setState(() {
                      oldtemDescription = value;
                    });
                  },
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  initialValue: oldItemName,
                  decoration: const InputDecoration(
                    labelText: 'Item Name',
                    hintText: 'Enter your item name',
                  ),
                  onChanged: (value) {
                    setState(() {
                      oldItemName = value;
                    });
                  },
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  initialValue: oldItemprice,
                  decoration: const InputDecoration(
                    labelText: 'Item Price',
                    hintText: 'Enter your item price',
                  ),
                  onChanged: (value) {
                    setState(() {
                      oldItemprice = value;
                    });
                  },
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  updateProfileNameOnExistingPost(oldUsername);
                  _updateUserName(oldUsername, oldPhoneNumber);

                  FirebaseFirestore.instance
                      .collection('items')
                      .doc(selectDoc)
                      .update({
                    'username': oldUsername,
                    'phoneNumber': oldPhoneNumber,
                    'itemPrice': oldItemprice,
                    'itemname': oldItemName,
                    'itemcolor': olditemcolor,
                    'itemDescription': oldtemDescription,
                  }).catchError((onError) {
                    print(onError);
                  });

                  Fluttertoast.showToast(
                    msg: 'Data Updated Successfully',
                    toastLength: Toast.LENGTH_SHORT,
                    backgroundColor: Colors.grey,
                    fontSize: 16.0,
                  );
                },
                child: const Text(
                  'Update now',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> updateProfileNameOnExistingPost(oldUsername) async {
    await FirebaseFirestore.instance
        .collection('items')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((snapshot) {
      for (int index = 0; index < snapshot.docs.length; index++) {
        String userProfileNameinPost = snapshot.docs[index].get('username');

        if (userProfileNameinPost != oldUsername) {
          FirebaseFirestore.instance
              .collection('item')
              .doc(snapshot.docs[index].id)
              .update({
            'username': oldUsername,
          }).then((value) => print('Updated Successfully'));
        }
      }
    });
  }

  Future _updateUserName(oldUsername, oldPhoneNumber) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'username': oldUsername,
      'phoneNumber': oldPhoneNumber,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Card(
        elevation: 16.0,
        shadowColor: Colors.deepPurple,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, Colors.orange],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
          padding: EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onDoubleTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageSliderScreen(
                          title: widget.itemname,
                          itemcolor: widget.itemcolor,
                          userNumber: widget.userNumber,
                          itemDescription: widget.itemDescription,
                          lat: widget.lat,
                          long: widget.long,
                          address: widget.address,
                          itemPrice: widget.itemPrice,
                          urlIMage1: widget.img1,
                          urlIMage2: widget.img2,
                          urlIMage3: widget.img3,
                          urlIMage4: widget.img4,
                          urlIMage5: widget.img5,
                        ),
                      ));
                  // For Imagesliderscreen
                },
                child: Image.network(
                  widget.img1,
                  height: 200.0,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 8.0),
              Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                        widget.userImg,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                          widget.itemname,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                          DateFormat('dd MM , yyyy - hh:mm a')
                              .format(widget.date)
                              .toString(),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    widget.userId != uid
                        ? const Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Column(),
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  showDialogForupdateData(
                                    widget.docId,
                                    widget.name,
                                    widget.userNumber,
                                    widget.itemPrice,
                                    widget.itemname,
                                    widget.itemcolor,
                                    widget.itemDescription,
                                  );
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.green,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  showDialogForupdateData(
                                    widget.docId,
                                    widget.name,
                                    widget.userNumber,
                                    widget.itemPrice,
                                    widget.itemname,
                                    widget.itemcolor,
                                    widget.itemDescription,
                                  );
                                },
                                icon: const Padding(
                                  padding: EdgeInsets.only(right: 8.0),
                                  child: Icon(
                                    Icons.edit_note,
                                    color: Colors.red,
                                    size: 27,
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection('items')
                                        .doc(widget.postId)
                                        .delete();

                                    Fluttertoast.showToast(
                                      msg: 'Data Deleted Successfully',
                                      toastLength: Toast.LENGTH_SHORT,
                                      backgroundColor: Colors.grey,
                                      fontSize: 16.0,
                                    );
                                  },
                                  icon: const Padding(
                                    padding: EdgeInsets.only(right: 8.0),
                                    child: Icon(
                                      Icons.delete_forever,
                                      color: Colors.white,
                                      size: 27,
                                    ),
                                  ))
                            ],
                          )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
