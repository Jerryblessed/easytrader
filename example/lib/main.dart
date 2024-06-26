import 'package:buyer_seller_app/firebase_options.dart';
import 'package:buyer_seller_app/splashscreen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

// gemini starts
import 'package:flutter_gemini/flutter_gemini.dart';

// gemini ends
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Gemini.init(apiKey: 'AIzaSyDDEdN89laTbTO8JEHJULde5fPm-h1GRGY', enableDebugging: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Easy Trader',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: splashScreen(),
      );
}

// /*
//  Copyright 2018 Square Inc.
 
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
 
//  http://www.apache.org/licenses/LICENSE-2.0
 
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
// */
// import 'dart:async';
// import 'dart:io' show Platform;

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:square_in_app_payments/google_pay_constants.dart'
//     as google_pay_constants;
// import 'package:square_in_app_payments/in_app_payments.dart';
// import 'package:square_in_app_payments/models.dart';

// import 'colors.dart';
// import 'config.dart';
// import 'widgets_/buy_sheet.dart';

// void main() => runApp(MaterialApp(
//       title: 'Super Cookie',
//       home: HomeScreen(),
//     ));

// class HomeScreen extends StatefulWidget {
//   HomeScreenState createState() => HomeScreenState();
// }

// class HomeScreenState extends State<HomeScreen> {
//   bool isLoading = true;
//   bool applePayEnabled = false;
//   bool googlePayEnabled = false;

//   static final GlobalKey<ScaffoldState> scaffoldKey =
//       GlobalKey<ScaffoldState>();

//   @override
//   void initState() {
//     super.initState();
//     _initSquarePayment();

//     SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
//   }

//   Future<void> _initSquarePayment() async {
//     await InAppPayments.setSquareApplicationId(squareApplicationId);

//     var canUseApplePay = false;
//     var canUseGooglePay = false;
//     if (Platform.isAndroid) {
//       await InAppPayments.initializeGooglePay(
//           squareLocationId, google_pay_constants.environmentTest);
//       canUseGooglePay = await InAppPayments.canUseGooglePay;
//     } else if (Platform.isIOS) {
//       await _setIOSCardEntryTheme();
//       await InAppPayments.initializeApplePay(applePayMerchantId);
//       canUseApplePay = await InAppPayments.canUseApplePay;
//     }

//     setState(() {
//       isLoading = false;
//       applePayEnabled = canUseApplePay;
//       googlePayEnabled = canUseGooglePay;
//     });
//   }

//   Future _setIOSCardEntryTheme() async {
//     var themeConfiguationBuilder = IOSThemeBuilder();
//     themeConfiguationBuilder.saveButtonTitle = 'Pay';
//     themeConfiguationBuilder.errorColor = RGBAColorBuilder()
//       ..r = 255
//       ..g = 0
//       ..b = 0;
//     themeConfiguationBuilder.tintColor = RGBAColorBuilder()
//       ..r = 36
//       ..g = 152
//       ..b = 141;
//     themeConfiguationBuilder.keyboardAppearance = KeyboardAppearance.light;
//     themeConfiguationBuilder.messageColor = RGBAColorBuilder()
//       ..r = 114
//       ..g = 114
//       ..b = 114;

//     await InAppPayments.setIOSCardEntryTheme(themeConfiguationBuilder.build());
//   }

//   Widget build(BuildContext context) => MaterialApp(
//       theme: ThemeData(canvasColor: Colors.white),
//       home: Scaffold(
//           body: isLoading
//               ? Center(
//                   child: CircularProgressIndicator(
//                   valueColor:
//                       AlwaysStoppedAnimation<Color>(mainBackgroundColor),
//                 ))
//               : BuySheet(
//                   applePayEnabled: applePayEnabled,
//                   googlePayEnabled: googlePayEnabled,
//                   applePayMerchantId: applePayMerchantId,
//                   squareLocationId: squareLocationId)));
// }
