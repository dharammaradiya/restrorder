import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restrorder/loginScreen.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    // Add your Firebase project configuration here
    options: const FirebaseOptions(
        apiKey: "AIzaSyBtLoJ83CsPMwQQqpaqMO1H0zcoPBvsC4M",
        projectId: "restrorder-a2e98",
        messagingSenderId: "1077010014992",
        appId: "1:1077010014992:android:e40ce1bda8ecd25fd7fb95",
        databaseURL: "https://restrorder-a2e98-default-rtdb.firebaseio.com"),
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
    // DeviceOrientation.portraitUp
  ]).then(
    (value) {
      runApp(const MyApp());
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: LoginScreen());
  }
}

bool isScreenSizeValid(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  // Define your condition for a valid screen size
  return screenWidth >= 600 && screenHeight >= 600;
}
