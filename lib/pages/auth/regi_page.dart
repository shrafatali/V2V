// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print, use_build_context_synchronously, unused_local_variable

import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:mubashir/components/components.dart';
import 'package:mubashir/components/constants.dart';
import 'package:mubashir/pages/auth/login_page.dart';
import 'package:mubashir/pages/auth/widgets/btn_widget.dart';
import 'package:mubashir/pages/auth/widgets/herder_container.dart';
import 'package:mubashir/utils/helper.dart';

class RegPage extends StatefulWidget {
  @override
  _RegPageState createState() => _RegPageState();
}

class _RegPageState extends State<RegPage> {
  String errorMessage;
  bool isPasswordVisible = true;
  final formKey = GlobalKey<FormState>();

  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController otpC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  TextEditingController confirmPasswordC = TextEditingController();
  TextEditingController carIdC = TextEditingController();
  TextEditingController numberC = TextEditingController();
  TextEditingController emergencyNumberC = TextEditingController();

  EmailOTP emailAuth = EmailOTP();
  bool reciveOTP = false;
  bool isLoading = false;
  bool showRegistranForm = false;

  @override
  void initState() {
    super.initState();
    // emailAuth = EmailAuth(
    //   sessionName: "V2V",
    // );

    // emailAuth.config(remoteServerConfiguration);
  }

  void sendOTP1() async {
    print(emailC.text.trim().toLowerCase().toString());
    setState(() {
      isLoading = true;
    });

    // emailAuth().config();

    var ser = emailAuth.setConfig(
        appEmail: "me@rohitchouhan.com",
        appName: "V2V",
        userEmail: emailC.text.toLowerCase().toString(),
        otpLength: 6,
        otpType: OTPType.digitsOnly);
    var result = await emailAuth.sendOTP();
    print(result);

    if (result == true) {
      Components.showSnackBar(context, 'OTP has been sent');
      setState(() {
        reciveOTP = true;
        isLoading = false;
      });
    } else {
      setState(() {
        reciveOTP = false;
        isLoading = false;
      });
    }
  }

  void verify() {
    setState(() {
      isLoading = true;
    });
    bool result = emailAuth.verifyOTP(
      // recipientMail: emailC.text.trim().toLowerCase(),
      otp: otpC.value.text.trim(),
    );
    print(result);

    if (result == true) {
      setState(() {
        isLoading = false;
        showRegistranForm = true;
      });
      Components.showSnackBar(context, 'Email verification Successfully');
    } else {
      setState(() {
        isLoading = false;
      });
      Components.showSnackBar(context, 'Email verification Failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      color: AppColor.primaryColor,
      inAsyncCall: isLoading,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(bottom: 30),
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  HeaderContainer(),
                  showRegistranForm == true
                      ? Container(
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, top: 30),
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  color: Colors.white,
                                ),
                                padding: const EdgeInsets.only(left: 10),
                                child: TextFormField(
                                  controller: nameC,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please Enter Name';
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Fullname",
                                    prefixIcon: Icon(Icons.person),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  color: Colors.white,
                                ),
                                padding: const EdgeInsets.only(left: 10),
                                child: TextFormField(
                                  controller: numberC,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please Enter Phone Number';
                                    } else if (value.length < 10) {
                                      return 'Please Valid Phone Number';
                                    } else {
                                      return null;
                                    }
                                  },
                                  inputFormatters: [phoneNumberFormatter],
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Phone Number",
                                    prefixIcon: Icon(Icons.call),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  color: Colors.white,
                                ),
                                padding: const EdgeInsets.only(left: 10),
                                child: TextFormField(
                                  controller: emailC,
                                  readOnly: true,
                                  enabled: true,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) =>
                                      Helper.validateEmail(value),
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  color: Colors.white,
                                ),
                                padding: const EdgeInsets.only(left: 10),
                                child: TextFormField(
                                  controller: passwordC,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) =>
                                      Helper.validatePassword1(
                                          value, passwordC.text),
                                  obscureText: isPasswordVisible,
                                  obscuringCharacter: "*",
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        isPasswordVisible
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: AppColor.blackColor
                                            .withOpacity(0.5),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          isPasswordVisible =
                                              !isPasswordVisible;
                                        });
                                      },
                                    ),
                                    border: InputBorder.none,
                                    hintText: "Password",
                                    prefixIcon: const Icon(Icons.vpn_key),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  color: Colors.white,
                                ),
                                padding: const EdgeInsets.only(left: 10),
                                child: TextFormField(
                                  controller: confirmPasswordC,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) => Helper.validatePassword(
                                      value,
                                      passwordC.text,
                                      confirmPasswordC.text),
                                  obscureText: isPasswordVisible,
                                  obscuringCharacter: "*",
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        isPasswordVisible
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: AppColor.blackColor
                                            .withOpacity(0.5),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          isPasswordVisible =
                                              !isPasswordVisible;
                                        });
                                      },
                                    ),
                                    border: InputBorder.none,
                                    hintText: "Confirm Password",
                                    prefixIcon: const Icon(Icons.vpn_key),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  color: Colors.white,
                                ),
                                padding: const EdgeInsets.only(left: 10),
                                child: TextFormField(
                                  controller: carIdC,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please Enter Car ID';
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Car ID",
                                    prefixIcon: Icon(Icons.car_repair_rounded),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  color: Colors.white,
                                ),
                                padding: const EdgeInsets.only(left: 10),
                                child: TextFormField(
                                  controller: emergencyNumberC,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please Enter Phone Number';
                                    } else if (value.length < 10) {
                                      return 'Please Valid Phone Number';
                                    } else {
                                      return null;
                                    }
                                  },
                                  inputFormatters: [phoneNumberFormatter],
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Emergency Phone Number",
                                    prefixIcon: Icon(Icons.call),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 40),
                              Center(
                                child: ButtonWidget(
                                  btnText: "REGISTER",
                                  onClick: () async {
                                    if (formKey.currentState.validate()) {
                                      Components.showAlertDialog(context);
                                      try {
                                        await FirebaseAuth.instance
                                            .createUserWithEmailAndPassword(
                                                email: emailC.text
                                                    .trim()
                                                    .toLowerCase(),
                                                password: passwordC.text);

                                        await FirebaseFirestore.instance
                                            .collection("User")
                                            .doc(FirebaseAuth
                                                .instance.currentUser.uid
                                                .toString())
                                            .set({
                                          'userUID': FirebaseAuth
                                              .instance.currentUser.uid,
                                          'userName': nameC.text.trim(),
                                          'userEmail': emailC.text.trim(),
                                          'userPassword': passwordC.text.trim(),
                                          'userConfirmPassword':
                                              confirmPasswordC.text.trim(),
                                          'phoneNumber':
                                              numberC.text.toString().trim(),
                                          'emPhoneNumber': emergencyNumberC.text
                                              .toString()
                                              .trim(),
                                          'profileImageLink': "0",
                                          'carID':
                                              carIdC.text.toString().trim(),
                                          'available': true,
                                          'alert': '0',
                                          'audioListnStart': false,
                                          // 'dateTime':
                                          //     '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}',
                                          'sendMessage': '0',
                                          'MessangerUID': [],
                                          'lat_long': [],
                                          // 'data': [],
                                        }).then((value) => Components.showSnackBar(
                                                context,
                                                "Account Created Sucessfully"));
                                        Navigator.pop(context);

                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                          PageRouteBuilder(
                                            transitionDuration:
                                                const Duration(seconds: 1),
                                            transitionsBuilder: (BuildContext
                                                    context,
                                                Animation<double> animation,
                                                Animation<double> secAnimation,
                                                Widget child) {
                                              animation = CurvedAnimation(
                                                  parent: animation,
                                                  curve: Curves.linear);
                                              return SharedAxisTransition(
                                                  animation: animation,
                                                  secondaryAnimation:
                                                      secAnimation,
                                                  transitionType:
                                                      SharedAxisTransitionType
                                                          .horizontal,
                                                  child: child);
                                            },
                                            pageBuilder: (BuildContext context,
                                                Animation<double> animation,
                                                Animation<double>
                                                    secAnimation) {
                                              return LoginPage();
                                            },
                                          ),
                                          (Route<dynamic> route) => false,
                                        );
                                      } catch (e) {
                                        Navigator.pop(context);
                                        print(e);

                                        switch (e.toString()) {
                                          case "[firebase_auth/email-already-in-use] The email address is already in use by another account.":
                                            errorMessage =
                                                "The email address is already in use by another account";
                                            break;
                                          case "[firebase_auth/network-request-failed] A network error (such as timeout, interrupted connection or unreachable host) has occurred.":
                                            errorMessage =
                                                "Please Check Internet Connection";
                                            break;
                                          case "[firebase_auth/invalid-email] The email address is badly formatted.":
                                            "Please Enter Valid Email";
                                            break;
                                          default:
                                            errorMessage =
                                                "Sign Up failed, Please try again.";
                                            break;
                                        }
                                        Components.showSnackBar(
                                            context, errorMessage.toString());
                                      }
                                    } else {
                                      Components.showSnackBar(context,
                                          "Please Fill Form Correctly");
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(height: 40),
                              GestureDetector(
                                onTap: (() {
                                  Navigator.pop(context);
                                }),
                                child: RichText(
                                  text: const TextSpan(children: [
                                    TextSpan(
                                        text: "Already a member ? ",
                                        style: TextStyle(color: Colors.black)),
                                    TextSpan(
                                        text: "Login",
                                        style: TextStyle(color: Colors.red)),
                                  ]),
                                ),
                              )
                            ],
                          ),
                        )
                      : Container(
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, top: 30),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  color: Colors.white,
                                ),
                                padding: const EdgeInsets.only(left: 10),
                                child: TextFormField(
                                  controller: emailC,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) =>
                                      Helper.validateEmail(value),
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Email",
                                    prefixIcon: Icon(Icons.email),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: reciveOTP,
                                child: Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    color: Colors.white,
                                  ),
                                  padding: const EdgeInsets.only(left: 10),
                                  child: TextFormField(
                                    controller: otpC,
                                    maxLength: 6,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please Enter OTP';
                                      } else {
                                        return null;
                                      }
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "OTP",
                                      prefixIcon:
                                          Icon(Icons.car_repair_rounded),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 40),
                              Center(
                                child: ButtonWidget(
                                    btnText: reciveOTP == false
                                        ? "Send OTP"
                                        : "Verify",
                                    onClick: () async {
                                      if (formKey.currentState.validate()) {
                                        print('reciveOTP== $reciveOTP');
                                        reciveOTP == false
                                            ? sendOTP1()
                                            : verify();
                                        print(otpC.value.text.toString());
                                      }
                                    }),
                              ),
                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
