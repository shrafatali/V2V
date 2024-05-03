// ignore_for_file: avoid_print, must_be_immutable, library_private_types_in_public_api

import 'dart:async';

import 'package:alan_voice/alan_voice.dart';
import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:mubashir/components/constants.dart';
import 'package:mubashir/main.dart';
import 'package:mubashir/pages/auth/login_page.dart';
import 'package:mubashir/pages/screens/drawer_screen.dart';
import 'package:mubashir/pages/screens/user_home_page.dart';

Color containerColor = Colors.green;

class SplashPage extends StatefulWidget {
  BuildContext context1;
  SplashPage({Key key, @required this.context1}) : super(key: key);
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  _SplashPageState() {
    AlanVoice.addButton(
      prefs.getString('ai_Token').toString(),
      //  "d34d7454d3a0c0954ae7761f595389182e956eca572e1d8b807a3e2338fdd0dc/stage",
      // "c431af41cd26c7e26d4cf6838d04665f2e956eca572e1d8b807a3e2338fdd0dc/stage",
      // "fb0e7b9738c87bb2fb73e71de68998222e956eca572e1d8b807a3e2338fdd0dc/stage",
      buttonAlign: AlanVoice.BUTTON_ALIGN_RIGHT,
    );

    AlanVoice.onCommand.add((command) => _handleCommand(command.data));
  }

  Future<void> _handleCommand(Map<String, dynamic> command) async {
    print('alertUserUID : $alertUserUID');
    switch (command["command"]) {
      case "TurnRight":
        await startCommunication(widget.context1, "Right");
        if (alertUserUID != '') {
          await updateAlertValue('1');
        } else {
          noUserFoundNearYou();
        }

        break;

      case 'TurnLeft':
        await startCommunication(widget.context1, "Left");
        if (alertUserUID != '') {
          await updateAlertValue('2');
        } else {
          noUserFoundNearYou();
        }

        break;

      case 'Takeover':
        await startCommunication(widget.context1, "Takeover");
        if (alertUserUID != '') {
          await updateAlertValue('3');
        } else {
          noUserFoundNearYou();
        }
        break;

      case 'Stop':
        await startCommunication(widget.context1, "Stop");
        if (alertUserUID != '') {
          await updateAlertValue('4');
        } else {
          noUserFoundNearYou();
        }
        break;

      default:
        await startCommunication(widget.context1, "0");
        if (alertUserUID != '') {
          await updateAlertValue('0');
        } else {
          noUserFoundNearYou();
        }
        break;
    }

    AlanVoice.deactivate();
  }

  updateAlertValue(String value1) async {
    try {
      if (alertUserUID != null) {
        await FirebaseFirestore.instance
            .collection('User')
            .doc(alertUserUID.toString())
            .update({
          'MessangerUID': FieldValue.arrayUnion(
              [FirebaseAuth.instance.currentUser.uid.toString()]),
          'alert': value1.toString(),
          'audioListnStart': true,
        }).whenComplete(() async {
          FlutterRingtonePlayer.play(
            fromAsset: 'assets/audio/success.mp3',
            ios: IosSounds.glass,
            volume: 0.9,
            asAlarm: false,
          );

          print(
              "1 - 11111111111111111111111111111111111111111111111111111111111111");

          // if (value1 != '0') {
          print(
              "2 - 222222222222222222222222222222222222222222222222222222222222");
          String id = DateTime.now().microsecondsSinceEpoch.toString();
          print(id.toString());

          await FirebaseFirestore.instance
              .collection('User')
              .doc(alertUserUID.toString())
              .get()
              .then((reciverUserData) async {
            await FirebaseFirestore.instance
                .collection('User')
                .doc(FirebaseAuth.instance.currentUser.uid.toString())
                .get()
                .then((myData) async {
              print("3 - 3333333333333333333333333333333333333333333333333333");
              await FirebaseFirestore.instance
                  .collection('messages')
                  .doc(id.toString())
                  .set({
                'reciverUserName': reciverUserData["userName"].toString(),
                'senderName': myData["userName"].toString(),
                'message': value1 == '1'
                    ? "Turn Right :  I'm going to switch lane to the right, please give me some space."
                    : value1 == '2'
                        ? "Turn Left : I'm going to switch lane to the left, please give me some space."
                        : value1 == '3'
                            ? "Overtake : I'm going to overtake you, please give me some space and maintain your speed"
                            : value1 == '4'
                                ? "Stop : Accident ahead, please slow down your car"
                                : "",
                'senderUID': FirebaseAuth.instance.currentUser.uid.toString(),
                'reciverUserUID': alertUserUID.toString(),
                'time': FieldValue.serverTimestamp(),
              }).whenComplete(() {
                alertUserUID = '';
                // alertUserLat = '';
                // alertUserLong = '';
              });
            });
          });
          // }
        });
        alertUserUID = '';
        // alertUserLat = '';
        // alertUserLong = '';
      } else {
        print(alertUserUID.toString());
        alertUserUID = '';
        // alertUserLat = '';
        // alertUserLong = '';
      }
    } catch (e) {
      print(e.toString());
    }
  }

  noUserFoundNearYou() {
    FlutterRingtonePlayer.play(
      fromAsset: 'assets/audio/${5}.mp3',
      ios: IosSounds.glass,
      volume: 0.9,
      asAlarm: false,
    );
    alertUserUID = '';
    // alertUserLat = '';
    // alertUserLong = '';
  }

  @override
  void initState() {
    super.initState();
    // loadData(widget.context1);
    Timer(const Duration(milliseconds: 4000), () {
      FirebaseAuth.instance.currentUser != null
          ? Navigator.of(context).pushAndRemoveUntil(
              PageRouteBuilder(
                transitionDuration: const Duration(seconds: 1),
                transitionsBuilder: (BuildContext context,
                    Animation<double> animation,
                    Animation<double> secAnimation,
                    Widget child) {
                  animation =
                      CurvedAnimation(parent: animation, curve: Curves.linear);
                  return SharedAxisTransition(
                    animation: animation,
                    secondaryAnimation: secAnimation,
                    transitionType: SharedAxisTransitionType.horizontal,
                    child: child,
                  );
                },
                pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secAnimation) {
                  return FlutterZoomDrawerPage();
                },
              ),
              (Route<dynamic> route) => false,
            )
          : Navigator.of(context).pushAndRemoveUntil(
              PageRouteBuilder(
                transitionDuration: const Duration(seconds: 1),
                transitionsBuilder: (BuildContext context,
                    Animation<double> animation,
                    Animation<double> secAnimation,
                    Widget child) {
                  animation =
                      CurvedAnimation(parent: animation, curve: Curves.linear);
                  return SharedAxisTransition(
                      animation: animation,
                      secondaryAnimation: secAnimation,
                      transitionType: SharedAxisTransitionType.horizontal,
                      child: child);
                },
                pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secAnimation) {
                  return LoginPage();
                },
              ),
              (Route<dynamic> route) => false,
            );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            // gradient: LinearGradient(
            // colors: [AppColor.primaryColor, AppColor.secColor],
            //     end: Alignment.bottomCenter,
            //     begin: Alignment.topCenter),
            ),
        child: Center(
          child: Image.asset(AppImages.logoImage),
        ),
      ),
    );
  }
}
