import 'package:auth_flutter/Signupscreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyDx_-vZ-Azd_6BWqs8IizomvA9BcI_rMF8",
        authDomain: "first-flutter-cfa12.firebaseapp.com",
        projectId: "first-flutter-cfa12",
        storageBucket: "first-flutter-cfa12.appspot.com",
        messagingSenderId: "134645006791",
        appId: "1:134645006791:web:df8b8a86eacae85a3199e2",
        measurementId: "G-F4VPW2RD8J"
    )
  );

  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Signupscreen(),
    );
  }
}

