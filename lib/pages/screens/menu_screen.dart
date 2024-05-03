// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'dart:async';

import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:mubashir/components/components.dart';
import 'package:mubashir/components/constants.dart';
import 'package:mubashir/main.dart';
import 'package:mubashir/pages/auth/splash_screen.dart';
import 'package:mubashir/pages/screens/profile_page.dart';
import 'package:mubashir/pages/screens/user_home_page.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  var userData;

  getCuttentUserData() async {
    userData = await FirebaseFirestore.instance
        .collection('User')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();
    setState(() {});
  }

  Timer _timer;
  @override
  void initState() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      getCuttentUserData();
    });

    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null && userData == null) {
      getCuttentUserData();
    }
    return userData != null
        ? SafeArea(
            child: Scaffold(
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: AppColor.pagesColor,
                            radius: 50,
                            backgroundImage: userData['profileImageLink'] != '0'
                                ? NetworkImage(
                                    userData['profileImageLink'].toString(),
                                  )
                                : Image.asset(
                                    Components.showPersonIcon(context),
                                    fit: BoxFit.fill,
                                  ).image,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
                            child: Text(
                              '${userData['userName']}',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColor.blackColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              '${userData['userEmail']}',
                              style: TextStyle(
                                color: AppColor.blackColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          onTap: () {
                            ZoomDrawer.of(context).close();
                          },
                          leading: const Icon(
                            Icons.home,
                          ),
                          title: const Text('Dashboard'),
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                transitionDuration: const Duration(seconds: 1),
                                transitionsBuilder: (BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secAnimation,
                                    Widget child) {
                                  animation = CurvedAnimation(
                                      parent: animation, curve: Curves.linear);
                                  return SharedAxisTransition(
                                      animation: animation,
                                      secondaryAnimation: secAnimation,
                                      transitionType:
                                          SharedAxisTransitionType.horizontal,
                                      child: child);
                                },
                                pageBuilder: (BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secAnimation) {
                                  return const ProfilePage();
                                },
                              ),
                            );
                          },
                          leading: const Icon(
                            Icons.person,
                          ),
                          title: const Text('Profile'),
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.compost_outlined,
                          ),
                          title: const Text('Available'),
                          trailing: Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Switch(
                              activeColor: AppColor.primaryColor,
                              value: userData['available'] ?? false,
                              onChanged: (value) async {
                                Components.showAlertDialog(context);
                                await FirebaseFirestore.instance
                                    .collection("User")
                                    .doc(FirebaseAuth.instance.currentUser.uid
                                        .toString())
                                    .update({
                                  'available': value,
                                });
                                setState(() {
                                  getCuttentUserData();
                                });
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.camera_outdoor_rounded,
                          ),
                          title: const Text('Camera Move'),
                          trailing: Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Switch(
                              activeColor: AppColor.primaryColor,
                              value: cameraMove,
                              onChanged: (value) async {
                                setState(() {
                                  cameraMove = !cameraMove;
                                });
                              },
                            ),
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            CoolAlert.show(
                              context: context,
                              backgroundColor: AppColor.primaryColor,
                              confirmBtnColor: AppColor.primaryColor,
                              barrierDismissible: false,
                              type: CoolAlertType.confirm,
                              text: 'you want to Logout?',
                              onConfirmBtnTap: () async {
                                Components.showAlertDialog(context);
                                await FirebaseAuth.instance
                                    .signOut()
                                    .whenComplete(() {
                                  Timer(const Duration(seconds: 3), () {
                                    prefs.clear();
                                    Get.offAll(
                                        () => SplashPage(context1: context));
                                  });
                                });
                              },
                              confirmBtnText: 'Logout',
                              showCancelBtn: true,
                            );
                          },
                          // iconColor: AppColor.red,
                          // textColor: AppColor.red,
                          leading: const Icon(
                            Icons.power_settings_new,
                          ),
                          title: const Text('Logout'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                  ],
                ),
              ),
            ),
          )
        : CircularProgressIndicator(
            color: AppColor.primaryColor,
          );
  }
}
