import 'package:buyer_seller_app/BuyNowScreen/buynowsreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slider/carousel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:buyer_seller_app/HomeScreen/home_screen.dart';

class ImageSliderScreen extends StatefulWidget {
  final String title, urlIMage1, urlIMage2, urlIMage3, urlIMage4, urlIMage5;
  final String itemcolor, userNumber, itemDescription, address, itemPrice;
  final double lat, long;

  ImageSliderScreen({
    required this.title,
    required this.urlIMage1,
    required this.urlIMage2,
    required this.urlIMage3,
    required this.urlIMage4,
    required this.urlIMage5,
    required this.itemcolor,
    required this.userNumber,
    required this.itemDescription,
    required this.address,
    required this.itemPrice,
    required this.lat,
    required this.long,
  });

  @override
  State<ImageSliderScreen> createState() => _ImageSliderScreenState();
}

class _ImageSliderScreenState extends State<ImageSliderScreen>
    with SingleTickerProviderStateMixin {
  static List<String> Links = [];
  TabController? tabController;

  getLinks() {
    Links.add(widget.urlIMage1);
    Links.add(widget.urlIMage2);
    Links.add(widget.urlIMage3);
    Links.add(widget.urlIMage4);
    Links.add(widget.urlIMage5);
  }

  @override
  void initState() {
    super.initState();
    getLinks();
    tabController = TabController(length: 5, vsync: this);
  }

  String? url;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
            widget.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Varela',
              letterSpacing: 2.0,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.teal,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 6, right: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.location_pin,
                      color: Colors.black54,
                    ),
                    const SizedBox(
                      width: 4.0,
                    ),
                    Expanded(
                      child: Text(
                        widget.address,
                        textAlign: TextAlign.justify,
                        overflow: TextOverflow.fade,
                        style: const TextStyle(
                          fontFamily: 'Varela',
                          letterSpacing: 2.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: size.height * 0.5,
                width: size.width,
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Carousel(
                    indicatorBarColor: Colors.black.withOpacity(0.2),
                    autoScrollDuration: const Duration(seconds: 2),
                    animationPageDuration: const Duration(milliseconds: 500),
                    activateIndicatorColor: Colors.black,
                    animationPageCurve: Curves.easeIn,
                    indicatorBarHeight: 30,
                    indicatorHeight: 10,
                    indicatorWidth: 10,
                    unActivatedIndicatorColor: Colors.grey,
                    stopAtEnd: false,
                    autoScroll: true,
                    items: [
                      Image.network(widget.urlIMage1),
                      Image.network(widget.urlIMage2),
                      Image.network(widget.urlIMage3),
                      Image.network(widget.urlIMage4),
                      Image.network(widget.urlIMage5),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 2.0),
                child: Center(
                  child: Text(
                    '\$${widget.itemPrice}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Bebas',
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.brush_outlined),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(widget.itemcolor),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.phone_android),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Text(widget.userNumber),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: Text(
                  widget.itemDescription,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.6),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Varela',
                    letterSpacing: 2.0,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Column(
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints.tightFor(width: 368),
                      child: ElevatedButton(
                        onPressed: () async {
                          url =
                              'https://www.google.com/maps/search/?api=1&query=' +
                                  widget.lat.toString() +
                                  ',' +
                                  widget.long.toString();

                          if (await canLaunch(url!)) {
                            await launch(url!);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black54),
                        ),
                        child: const Text(
                          'Check Seller Location',
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints.tightFor(width: 368),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BuyScreen()),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black54),
                        ),
                        child: const Text(
                          'Checkout',
                        ),
                      ),
                    ),
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
