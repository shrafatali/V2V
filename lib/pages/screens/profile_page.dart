// ignore_for_file: avoid_print, must_be_immutable, prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mubashir/components/components.dart';
import 'package:mubashir/components/constants.dart';
import 'package:mubashir/main.dart';
import 'package:mubashir/utils/helper.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String imagePathProfile;

  bool isPasswordVisible = true;
  final formKey = GlobalKey<FormState>();

  final TextEditingController username =
      TextEditingController(text: prefs.getString('Username'));

  final TextEditingController emailC =
      TextEditingController(text: prefs.getString('Email'));

  final TextEditingController phoneNo =
      TextEditingController(text: prefs.getString('PhoneNo'));
//

  final TextEditingController emergencyPhoneNo =
      TextEditingController(text: prefs.getString('emPhoneNumber'));

  final TextEditingController carID =
      TextEditingController(text: prefs.getString('carID'));

  File profilePicture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    profilePicture == null
                        ? CircleAvatar(
                            backgroundColor: AppColor.pagesColor,
                            radius: 50,
                            backgroundImage:
                                prefs.getString('ProfilePicture') != '0'
                                    ? NetworkImage(
                                        prefs.getString('ProfilePicture'),
                                      )
                                    : Image.asset(
                                        Components.showPersonIcon(context),
                                        fit: BoxFit.contain,
                                      ).image,
                          )
                        : CircleAvatar(
                            backgroundColor: AppColor.pagesColor,
                            radius: 50,
                            backgroundImage: Image.file(profilePicture).image,
                          ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        pickImage();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.edit,
                            color: AppColor.primaryColor,
                            size: 16,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Edit Profile",
                            style: TextStyle(color: AppColor.primaryColor),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Hi there ${prefs.getString('Username')}!",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline4.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColor.blackColor),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.only(left: 10),
                      child: TextFormField(
                        controller: username,
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
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.only(left: 10),
                      child: TextFormField(
                        controller: phoneNo,
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
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.only(left: 10),
                      child: TextFormField(
                        controller: emailC,
                        readOnly: true,
                        enabled: true,
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
                        controller: carID,
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
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.only(left: 10),
                      child: TextFormField(
                        controller: emergencyPhoneNo,
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
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState.validate()) {
                            Components.showAlertDialog(context);
                            String profileLink;
                            if (profilePicture != null) {
                              profileLink =
                                  await uploadImage(File(profilePicture.path));
                            }

                            await FirebaseFirestore.instance
                                .collection('User')
                                .doc(FirebaseAuth.instance.currentUser.uid
                                    .toString())
                                .update({
                              'profileImageLink': profileLink ??
                                  prefs.getString('ProfilePicture'),
                              'userName': username.text.trim().toString(),
                              'phoneNumber': phoneNo.text.trim().toString(),
                              'emPhoneNumber':
                                  emergencyPhoneNo.text.trim().toString(),
                              'carID': carID.text.trim().toString(),
                            }).whenComplete(() async {
                              var documentData = await FirebaseFirestore
                                  .instance
                                  .collection('User')
                                  .doc(FirebaseAuth.instance.currentUser.uid
                                      .toString())
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

                              prefs.setString('carID', documentData['carID']);

                              Components.showSnackBar(context,
                                  "Profile Data Updated Successfully 🥰");
                              Navigator.pop(context);
                              Navigator.pop(context);
                            });
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              AppColor.primaryColor),
                          foregroundColor: MaterialStateProperty.all<Color>(
                              AppColor.whiteColor),
                          overlayColor: MaterialStateProperty.all<Color>(
                              AppColor.primaryColor.withOpacity(0.1)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              side: BorderSide(color: AppColor.primaryColor),
                            ),
                          ),
                        ),
                        child: const Text("Save"),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future pickImage() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: const Center(child: Text("Where want you pick")),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                        onTap: (() {
                          pickMedia(ImageSource.camera);
                          Navigator.pop(context);
                        }),
                        child: const Icon(Icons.camera_alt)),
                    const SizedBox(height: 5),
                    const Text("Carmera")
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: (() {
                        pickMedia(ImageSource.gallery);
                        Navigator.pop(context);
                      }),
                      child: const Icon(Icons.photo),
                    ),
                    const SizedBox(height: 5),
                    const Text("Gallery")
                  ],
                ),
              ],
            ));
      },
    );
  }

  XFile file;
  void pickMedia(ImageSource source) async {
    file = await ImagePicker().pickImage(source: source);

    if (file != null) {
      setState(() {
        profilePicture = File(file.path.toString());
      });
    }
  }

  Future uploadImage(File imagePath) async {
    FirebaseStorage storage = FirebaseStorage.instance;

    String postId = DateTime.now().millisecondsSinceEpoch.toString();

    Reference reference = storage.ref().child("Profileimages/$postId");

    //Upload the file to firebase
    await reference.putFile(imagePath);
    String downloadsUrlImage = await reference.getDownloadURL();
    print(downloadsUrlImage);
    return downloadsUrlImage;
  }
}
