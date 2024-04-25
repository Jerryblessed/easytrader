import 'package:buyer_seller_app/HomeScreen/home_screen.dart';
import 'package:buyer_seller_app/widgets/global_var.dart';
import 'package:buyer_seller_app/widgets/listview_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

class ProfileScreen extends StatefulWidget {
  final String sellerId;
  ProfileScreen({required this.sellerId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Call getResult() when the widget is initialized
    getResult();
  }

  _buildBackButton() => IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        },
      );

  _buildUserImage() => Container(
        width: 50,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            // Use addUserImageUrl variable here
            image: NetworkImage(addUserImageUrl),
            fit: BoxFit.fill,
          ),
        ),
      );

  void _showSyncfusionCharts(BuildContext context) {
    // Implement logic to show Syncfusion charts in a slide-up window
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        child: Center(
          child: SfCircularChart(
            series: <CircularSeries>[
              // Create your series here (e.g., pie series)
              PieSeries<ChartData, String>(
                dataSource: _getChartData(),
                xValueMapper: (ChartData data, _) => data.category,
                yValueMapper: (ChartData data, _) => data.value,
                dataLabelSettings:
                    DataLabelSettings(isVisible: true), // Show data labels
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ignore: prefer_expression_function_bodies
  List<ChartData> _getChartData() {
    // Implement your logic to fetch and prepare the chart data
    // For example:
    return [
      ChartData('Milk', 27),
      ChartData('Milk', 7),
      ChartData('Cocoa', 5),
      ChartData('Butter', 3),
      // Add more data items as needed
    ];
  }

  // void _showSyncfusionCharts(BuildContext context) {
  //   // Implement logic to show Syncfusion charts in a slide-up window
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext context) => Container(
  //       height: MediaQuery.of(context).size.height * 0.8,
  //       child: Center(
  //         child: SfCircularChart(
  //           series: <CircularSeries>[
  //             // Create your series here (e.g., pie series)
  //             PieSeries<ChartData, String>(
  //               dataSource: _getChartData(),
  //               xValueMapper: (ChartData data, _) => data.category,
  //               yValueMapper: (ChartData data, _) => data.value,
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // // ignore: prefer_expression_function_bodies
  // List<ChartData> _getChartData() {
  //   // Implement your logic to fetch and prepare the chart data
  //   // For example:
  //   return [
  //     ChartData('Milk', 4),
  //     ChartData('Cocoa', 5),
  //     ChartData('Butter', 3),
  //     // Add more data items as needed
  //   ];
  // }

  getResult() {
    FirebaseFirestore.instance
        .collection('items')
        .where('id', isEqualTo: widget.sellerId)
        .where('status', isEqualTo: 'approved')
        .get()
        .then((results) {
      setState(() {
        items = results;
        // Use the fetched data to set variables
        addUserName = items!.docs[0].get('userName');
        addUserImageUrl = items!.docs[0].get('imgPro');
      });
    });
  }

  QuerySnapshot? items;

  @override
  Widget build(BuildContext context) => Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [Colors.orange, Colors.teal],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        )),
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
              )),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              // Change with your logo asset
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.pie_chart),
                onPressed: () => _showSyncfusionCharts(context),
              ),
              IconButton(
                icon: Icon(Icons.insert_chart),
                onPressed: () {
                  // Add your logic to display charts
                },
              ),
            ],
            title: Row(
              children: [
                _buildUserImage(),
                const SizedBox(
                  width: 10,
                ),
                Text(addUserName),
              ],
            ),
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('items')
                .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
                            userNumber: snapshot.data!.docs[index]
                                ['userNumber'],
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
              ));
            },
          ),
        ),
      );
}

class ChartData {
  final String category;
  final double value;

  ChartData(this.category, this.value);
}
