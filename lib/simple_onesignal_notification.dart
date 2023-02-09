// // cHuq4XZbSVCPsV6K8A0to2:APA91bHsxn2x8zaOnr1UiY_joG-jJhCKLOp_yzINKHJxjD8toPyBz2o3qHGOyWhX31xjxxaVC9JU48IXfeGxFo0vZyXmP588aw09sgqzZ6q48_tTt31SMV9mKHZ2TJmsweJTdD46cR3
// // import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';
//
// void main() async {
//   // WidgetsFlutterBinding.ensureInitialized();
//   // await Firebase.initializeApp();
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: Home(),
//     );
//   }
// }
//
// class Home extends StatefulWidget {
//   const Home({Key? key}) : super(key: key);
//
//   @override
//   HomeState createState() => HomeState();
// }
//
// class HomeState extends State<Home> {
//   // static const oneSignalAppId = '';
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     // OneSignal.shared.setLogLevel(OSLogLevel.debug, OSLogLevel.none);
//     // OneSignal.shared.setAppId("5f334f2a-7993-4789-9ddb-4a2a02e16bc8");
//     OneSignal.shared.setAppId("d7509317-3652-4ff2-aea7-6db90d693a51");
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("OneSignal"),
//       ),
//       body: const Center(child: Text("OneSignal PushNotification")),
//     );
//   }
// }
