import 'package:buyer_seller_app/HomeScreen/home_screen.dart';
import 'package:buyer_seller_app/widgets/listview_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class searchproduct extends StatefulWidget {
  @override
  State<searchproduct> createState() => _searchproductState();
}

class _searchproductState extends State<searchproduct> {
  final TextEditingController _searchQueryController = TextEditingController();
  String searchText = '';
  bool _isSearching = false;

  Widget _buildSearchfield() {
    return TextFormField(
      controller: _searchQueryController,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: 'Search Product',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white, fontSize: 10),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  updateSearchQuery(String newQuery) {
    setState(() {
      searchText = newQuery;
      print('search query: $newQuery');
    });
  }

  List<Widget> _buildSearchList() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchQueryController == null ||
                _searchQueryController.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _ClearSearchQuery();
          },
        )
      ];
    }
    return <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      )
    ];
  }

  _ClearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery('');
    });
  }

  _startSearch() {
    ModalRoute.of(context)!
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));
    setState(() {
      _isSearching = true;
    });
  }

  _stopSearching() {
    _ClearSearchQuery();
    setState(() {
      _isSearching = false;
    });
  }

  _buildtTitle(BuildContext context) {
    return Text(
      'Search Product',
      style: Theme.of(context).textTheme.headline6,
    );
  }

  _buildbackButton() {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.white),
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      },
    );
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
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: _isSearching ? const BackButton() : _buildbackButton(),
          title: _isSearching ? _buildSearchfield() : _buildtTitle(context),
          actions: _buildSearchList(),
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
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('items')
              .where('itemname',
                  isGreaterThanOrEqualTo: _searchQueryController.text.trim())
              .where('status', isEqualTo: 'approved')
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
                    itemBuilder: (BuildContext context, int index) {
                      return ListviewWidget(
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
                      );
                    });
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
}
