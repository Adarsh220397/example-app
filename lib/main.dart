import 'package:example_app/src/screens/mobile_number_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Example App',
      theme: ThemeData(
        backgroundColor: Colors.black,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color.fromARGB(255, 1, 16, 39),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: const TextStyle(color: Colors.white),
          hintStyle: const TextStyle(color: Colors.grey),
          focusColor: Colors.white,
          fillColor: Color.fromARGB(255, 1, 16, 39),
          filled: true,

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          // enabledBorder: OutlineInputBorder(
          //     borderRadius: BorderRadius.circular(30),
          //     borderSide: const BorderSide(width: 2.0, color: Colors.white10)),
          // errorBorder: OutlineInputBorder(
          //     borderRadius: BorderRadius.circular(5),
          //     borderSide: BorderSide(width: 2.0, color: Colors.red.shade400)),
          // focusedErrorBorder: OutlineInputBorder(
          //     borderRadius: BorderRadius.circular(5),
          //     borderSide: BorderSide(width: 2.0, color: Colors.red.shade500)),
          // disabledBorder: OutlineInputBorder(
          //     borderRadius: BorderRadius.circular(5),
          //     borderSide:
          //         const BorderSide(width: 2.0, color: ColorConstants.appCardColor)),
        ),
      ),
      home: const MobileNumberScreen(),
    );
  }
}
