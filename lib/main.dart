// ignore_for_file: avoid_print, use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mubashir/components/constants.dart';
import 'package:mubashir/pages/auth/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences prefs;

final Color _primaryColor = AppColor.primaryColor;

final Color _accentColor = HexColor('#8A02AE');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  prefs = await SharedPreferences.getInstance();

  if (FirebaseAuth.instance.currentUser != null) {
    try {
      await FirebaseFirestore.instance
          .collection('AI_Token')
          .doc("5rotHJQCtnl6Nzn7XsB4")
          .get()
          .then((value) {
        prefs.setString('ai_Token', value.data()["token"]);
        print("ai_Token : ${prefs.getString('ai_Token')}");
      });
    } catch (e) {
      print(e.toString());
    }
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // if (FirebaseAuth.instance.currentUser != null && userData == null) {
    //   Constants.getCuttentUserData();
    // }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'V2V',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: _primaryColor,
        scaffoldBackgroundColor: Colors.grey.shade100,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey)
            .copyWith(secondary: _accentColor),
      ),
      home: SplashPage(context1: context),
    );
  }
}
