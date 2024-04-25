import 'package:buyer_seller_app/WelcomeScreen/body.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WelcomeBody(),
    );
  }
}



// import 'package:buyer_seller_app/WelcomeScreen/blackground.dart';
// import 'package:flutter/material.dart';

// class WelcomeScreen extends StatelessWidget {
//   // const MyWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: WelcomeBackground()
//     );
    


//   }
// }



// Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.orange, Colors.teal],
//             begin: Alignment.centerLeft,
//             end: Alignment.centerRight,
//             stops: [0.0, 1.0],
//             tileMode: TileMode.clamp,
//           ),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Image.asset(
//                 'assets/images/logo.png',
//                 height: 350,
//                 width: 200,
//               ),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Center(
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.pushNamed(context, '/login');
//                 },
//                 child: const Text('Login'),
//               ),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             Center(
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.pushNamed(context, '/register');
//                 },
//                 child: const Text('Register'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );