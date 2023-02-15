import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: const OneSignalFlutter(),
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(fontSize: 24.0),
            centerTitle: true,
          ),
          textTheme: const TextTheme(
            titleLarge: TextStyle(fontSize: 24.0),
          ),
        ),
      );
}

class OneSignalFlutter extends StatefulWidget {
  const OneSignalFlutter({Key? key}) : super(key: key);

  @override
  OneSignalFlutterState createState() => OneSignalFlutterState();
}

class OneSignalFlutterState extends State<OneSignalFlutter> {
  static const oneSignalAppId = 'd7509317-3652-4ff2-aea7-6db90d693a51';

  @override
  void initState() {
    super.initState();
    OneSignal.shared.setAppId(oneSignalAppId);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('OneSignal Flutter'),
        ),
        body: Center(
          child: Text(
            'OneSignal PushNotification',
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.titleLarge!.fontSize),
          ),
        ),
      );
}
