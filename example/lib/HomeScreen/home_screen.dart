import 'package:buyer_seller_app/GeminiScreen/gemini_screen';
import 'package:buyer_seller_app/ProfileScren/profile_screnn.dart';
import 'package:buyer_seller_app/UploadAdScreen/upload_ad_screen.dart';
import 'package:buyer_seller_app/WelcomeScreen/welcome_screen.dart';
import 'package:buyer_seller_app/searchProduct/search_product.dart';
import 'package:buyer_seller_app/widgets/global_var.dart';
import 'package:buyer_seller_app/widgets/listview_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class SectionItem {
  final int index;
  final String title;
  final Widget widget;

  SectionItem(this.index, this.title, this.widget);
}

// geminin ends

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  getMyData() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((results) {
      setState(() {
        userImageUrl = results.data()!['userPhotoUrl'];
        getUserName = results.data()!['userName'];
      });
    });
  }

  getUserAddress() async {
    Position newposition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    position = newposition;

    placemarks =
        await placemarkFromCoordinates(position!.latitude, position!.longitude);
    Placemark placemark = placemarks![0];
    String newCompleteAddress =
        '${placemark.subThoroughfare} ${placemark.thoroughfare}';
    '${placemark.subLocality} ${placemark.locality}';
    '${placemark.subAdministrativeArea} ';
    '${placemark.administrativeArea} ${placemark.postalCode}';
    '${placemark.country}';

    completeAddress = newCompleteAddress;
    print(completeAddress);

    return completeAddress;
  }

  @override
  void initState() {
    super.initState();

    getUserAddress();
    uid = FirebaseAuth.instance.currentUser!.uid;
    userEmail = FirebaseAuth.instance.currentUser!.email!;

    getMyData();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                            sellerId: uid,
                          )),
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.person,
                  color: Colors.green,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to the screen showing Gemini chat interface
                showModalBottomSheet(
                  context: context,
                  builder: (context) => MyHomePage(),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.chat,
                  color: Colors.green,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => searchproduct()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.search,
                  color: Colors.green,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                _auth.signOut().then((value) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => WelcomeScreen()),
                  );
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.logout,
                  color: Colors.green,
                ),
              ),
            ),
          ],
          title: const Text(
            'Home Screen',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 30,
              fontWeight: FontWeight.bold,
              fontFamily: 'Signatra',
            ),
          ),
          centerTitle: false,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('items')
              .orderBy('time', descending: true)
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.data!.docs.isNotEmpty) {
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) =>
                        ListviewWidget(
                          docId: snapshot.data!.docs[index].id,
                          itemcolor: snapshot.data!.docs[index]['itemcolor'],
                          img1: snapshot.data!.docs[index]['urlIMage1'],
                          img2: snapshot.data!.docs[index]['urlIMage2'],
                          img3: snapshot.data!.docs[index]['urlIMage3'],
                          img4: snapshot.data!.docs[index]['urlIMage4'],
                          img5: snapshot.data!.docs[index]['urlIMage5'],
                          userImg: snapshot.data!.docs[index]['imgPro'],
                          name: snapshot.data!.docs[index]['userName'],
                          date: snapshot.data!.docs[index]['time'].toDate(),
                          userId: snapshot.data!.docs[index]['id'],
                          itemname: snapshot.data!.docs[index]['itemname'],
                          postId: snapshot.data!.docs[index]['postId'],
                          itemPrice: snapshot.data!.docs[index]['itemPrice'],
                          itemDescription: snapshot.data!.docs[index]
                              ['itemDescription'],
                          lat: snapshot.data!.docs[index]['lat'],
                          long: snapshot.data!.docs[index]['long'],
                          address: snapshot.data!.docs[index]['address'],
                          userNumber: snapshot.data!.docs[index]['userNumber'],
                        ));
              } else {
                return const Center(
                  child: Text('There is no tasks'),
                );
              }
            }
            return const Center(
              child: Text(
                "Something went wrong",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Add Post',
          child: Icon(Icons.cloud_upload_outlined),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => UploadAdScreen()),
            );
          },
        ),
      );
}
