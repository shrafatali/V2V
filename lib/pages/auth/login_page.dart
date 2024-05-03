// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print, use_build_context_synchronously

import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mubashir/components/components.dart';
import 'package:mubashir/components/constants.dart';
import 'package:mubashir/pages/auth/regi_page.dart';
import 'package:mubashir/pages/auth/widgets/btn_widget.dart';
import 'package:mubashir/pages/auth/widgets/herder_container.dart';
import 'package:mubashir/pages/screens/user_home_page.dart';
import 'package:mubashir/utils/helper.dart';

import '../../main.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final emailC = TextEditingController();
  final passwordC = TextEditingController();

  String errorMessage;
  bool isPasswordVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(bottom: 30),
          child: Column(
            children: <Widget>[
              HeaderContainer(),
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20, top: 30),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.only(left: 10),
                        child: TextFormField(
                          controller: emailC,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) => Helper.validateEmail(value),
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Email",
                            prefixIcon: Icon(Icons.email),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.only(left: 10),
                        child: TextFormField(
                          controller: passwordC,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) =>
                              Helper.validatePassword1(value, passwordC.text),
                          obscureText: isPasswordVisible,
                          obscuringCharacter: "*",
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(
                                isPasswordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: AppColor.blackColor.withOpacity(0.5),
                              ),
                              onPressed: () {
                                setState(() {
                                  isPasswordVisible = !isPasswordVisible;
                                });
                              },
                            ),
                            border: InputBorder.none,
                            hintText: "Password",
                            prefixIcon: const Icon(Icons.vpn_key),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Center(
                        child: ButtonWidget(
                          onClick: () async {
                            if (formKey.currentState.validate()) {
                              try {
                                Components.showAlertDialog(context);
                                await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                  email: emailC.text.trim().toLowerCase(),
                                  password: passwordC.text.trim(),
                                )
                                    .then((result) async {
                                  if (result != null) {
                                    var documentData = await FirebaseFirestore
                                        .instance
                                        .collection('User')
                                        .doc(result.user.uid)
                                        .get();
                                    print(documentData['userName']);

                                    print(FirebaseAuth.instance.currentUser);

                                    prefs.setString(
                                        'Username', documentData['userName']);
                                    prefs.setString(
                                        'UserID',
                                        FirebaseAuth.instance.currentUser.uid
                                            .toString());
                                    prefs.setString(
                                        'Email', documentData['userEmail']);

                                    prefs.setString(
                                        'PhoneNo', documentData['phoneNumber']);
                                    prefs.setString('emPhoneNumber',
                                        documentData['emPhoneNumber']);
                                    prefs.setString('ProfilePicture',
                                        documentData['profileImageLink']);

                                    prefs.setString(
                                        'carID', documentData['carID']);
                                    print(FirebaseAuth.instance.currentUser);
                                    Navigator.of(context).pushAndRemoveUntil(
                                      PageRouteBuilder(
                                        transitionDuration:
                                            const Duration(seconds: 1),
                                        transitionsBuilder:
                                            (BuildContext context,
                                                Animation<double> animation,
                                                Animation<double> secAnimation,
                                                Widget child) {
                                          animation = CurvedAnimation(
                                              parent: animation,
                                              curve: Curves.linear);
                                          return SharedAxisTransition(
                                              animation: animation,
                                              secondaryAnimation: secAnimation,
                                              transitionType:
                                                  SharedAxisTransitionType
                                                      .horizontal,
                                              child: child);
                                        },
                                        pageBuilder: (BuildContext context,
                                            Animation<double> animation,
                                            Animation<double> secAnimation) {
                                          return UserHomePage(
                                            context1: context,
                                          );
                                        },
                                      ),
                                      (Route<dynamic> route) => false,
                                    );
                                    Components.showSnackBar(
                                        context, "Login Sucessfully");
                                    // }
                                    // }).catchError((e) async {
                                    //   await FirebaseAuth.instance.signOut();
                                    //   Navigator.of(context).pop();
                                    //   Components.showSnackBar(
                                    //       context, 'You are not allowed to login from this panel');
                                    // });
                                  }
                                });
                              } catch (e) {
                                Navigator.pop(context);
                                print(e);
                                switch (e.toString()) {
                                  case "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.":
                                    errorMessage =
                                        "User with this email doesn't exist.";
                                    break;
                                  case "[firebase_auth/wrong-password] The password is invalid or the user does not have a password.":
                                    errorMessage =
                                        "Please Enter Correct Password.";
                                    break;
                                  case "[firebase_auth/network-request-failed] A network error (such as timeout, interrupted connection or unreachable host) has occurred.":
                                    errorMessage =
                                        "Please Check Internet Connection";
                                    break;
                                  case "[firebase_auth/invalid-email] The email address is badly formatted.":
                                    errorMessage = "Please Enter Valid Email";
                                    break;
                                  default:
                                    errorMessage =
                                        "An undefined Error happened.";
                                    break;
                                }
                                Components.showSnackBar(
                                    context, errorMessage.toString());
                              }
                            }
                          },
                          btnText: "LOGIN",
                        ),
                      ),
                      const SizedBox(height: 40),
                      GestureDetector(
                        onTap: (() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegPage()));
                        }),
                        child: RichText(
                          text: const TextSpan(children: [
                            TextSpan(
                                text: "Don't have an account ? ",
                                style: TextStyle(color: Colors.black)),
                            TextSpan(
                                text: "Registor",
                                style: TextStyle(color: Colors.red)),
                          ]),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
