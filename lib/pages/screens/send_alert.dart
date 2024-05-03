// ignore_for_file: use_key_in_widget_constructors, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mubashir/components/constants.dart';

class SendAlertPage extends StatefulWidget {
  @override
  State<SendAlertPage> createState() => _SendAlertPageState();
}

class _SendAlertPageState extends State<SendAlertPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: AppColor.whiteColor,
            )),
        elevation: 0,
        title: Text(
          "Send Alert",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColor.whiteColor,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(13.0),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("messages")
                // .where("senderUID",
                //     isEqualTo: FirebaseAuth.instance.currentUser.uid)
                .orderBy('time', descending: true)
                .snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                if (snapshot.data.docs.isNotEmpty) {
                  return ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      Map<String, dynamic> documentData =
                          snapshot.data.docs[index].data();

                      Timestamp timestamp = documentData["time"];
                      DateTime dateTime = timestamp.toDate();

                      if (documentData.isNotEmpty) {
                        if (documentData['senderUID'] ==
                            FirebaseAuth.instance.currentUser.uid.toString()) {
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 3),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              horizontalTitleGap: 7,
                              title: Text(documentData['reciverUserName']),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    dateTime.toString().substring(0, 16),
                                    style: TextStyle(
                                      // fontSize: 15,
                                      color: AppColor.blackColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(documentData["message"]),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return const SizedBox(height: 0, width: 0);
                        }
                      } else {
                        return const SizedBox(height: 0, width: 0);
                      }
                    },
                    // separatorBuilder: (BuildContext context, int) {
                    //   return const Divider();
                    // },
                    itemCount: snapshot.data.docs.length,
                  );
                } else {
                  return Center(
                    child: Text(
                      "No Data Found",
                      style: TextStyle(color: AppColor.blackColor),
                    ),
                  );
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    color: AppColor.primaryColor,
                  ),
                );
              }
            }),
      ),
    );
  }
}
