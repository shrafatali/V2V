// ignore_for_file: avoid_print, use_build_context_synchronously, must_be_immutable

import 'dart:async';
import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mubashir/components/components.dart';
import 'package:mubashir/components/constants.dart';
import 'package:mubashir/pages/screens/call_emergency.dart';
import 'package:mubashir/pages/screens/profile_page.dart';
import 'package:mubashir/pages/screens/send_alert.dart';
import 'package:mubashir/utils/helper1.dart';
import 'dart:ui' as ui;

String alertUserUID = '';
// String alertUserLat = '';
// String alertUserLong = '';

String userlat = '33.68440';
String userLong = '73.04790';
String userInfoWundow = '';

startCommunication(BuildContext context1, String name) async {
  print('1');

  await getLatLongAllUsers1(context1, name);
  print('4');
}

getLatLongAllUsers1(BuildContext context, String name1) async {
  print('2');
  double lessDistance = 10.0;

  print('ABC');
  QuerySnapshot snap =
      await FirebaseFirestore.instance.collection('User').get();

  for (var document in snap.docs) {
    if (document['userUID'] != FirebaseAuth.instance.currentUser.uid &&
        document['available'] == true) {
      double distanceInzmetters = HelperUserHome.calculateDistanceWithGeo(
        double.parse(document['lat_long'][0].toString()),
        double.parse(document['lat_long'][1].toString()),
        double.parse(userlat),
        double.parse(userLong),
      );

      print('getLatLongAllUsers1 : ${distanceInzmetters.toString()}');

      if (distanceInzmetters >= 0.0 && distanceInzmetters <= 5.0) {
        if (distanceInzmetters <= lessDistance) {
          if (distanceInzmetters >= 0.0 && distanceInzmetters <= 5.0) {
            print('getLatLongAllUsers1 : ${distanceInzmetters.toString()}');
            if (distanceInzmetters <= lessDistance) {
              print("inRAnge $name1");
              if (name1 == "Right" &&
                  double.tryParse(document['lat_long'][1]) >
                      double.tryParse(userLong)) {
                lessDistance = distanceInzmetters;
                alertUserUID = document['userUID'].toString();
              } else if (name1 == "Left" &&
                  double.tryParse(document['lat_long'][1]) <
                      double.tryParse(userLong)) {
                lessDistance = distanceInzmetters;
                alertUserUID = document['userUID'].toString();
              } else if (name1 == "Takeover" &&
                  double.tryParse(document['lat_long'][0]) >
                      double.tryParse(userlat)) {
                lessDistance = distanceInzmetters;
                alertUserUID = document['userUID'].toString();
              } else if (name1 == "Stop" &&
                  double.tryParse(document['lat_long'][0]) <
                      double.tryParse(userlat)) {
                lessDistance = distanceInzmetters;
                alertUserUID = document['userUID'].toString();
              } else {
                print("OUT OF Range");
              }
            }
          }
        }
      }
    }
  }
  print('3');
}

bool cameraMove = true;

class UserHomePage extends StatefulWidget {
  BuildContext context1;
  UserHomePage({Key key, @required this.context1}) : super(key: key);

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  // bool floatingActionButtonIsLoading = false;
  List<Marker> markers = [];
  // List<Placemark> placemarks;

  bool startCommunicationValue = false;

  final Completer<GoogleMapController> googleMapcontroller = Completer();

  Timer _timer;
  @override
  void initState() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      loadData(widget.context1);
      getLatLongAllUsers(context);
      getLatLongAllUsersMissBehaving(context);
    });

    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      getCuttentUserData();
    });

    super.initState();
  }

  Future<Position> getUserCurrentLocation(BuildContext context) async {
    // Components.showAlertDialog(context);
    // setState(() {
    //   floatingActionButtonIsLoading = true;
    // });
    await Geolocator.requestPermission().then((value) {
      //
    }).onError((error, stackTrace) {
      //
      // setState(() {
      //   floatingActionButtonIsLoading = false;
      // });
      Components.showSnackBar(context, error.toString());
    });

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  var userData;
  var userDataAlertValue;

  bool audioListnStart = false;

  getCuttentUserData() async {
    try {
      userData = await FirebaseFirestore.instance
          .collection('User')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .get();
      print(userData.toString());
      userDataAlertValue = userData['alert'];

      if (userData['audioListnStart'] == true) {
        audioListnStart = true;
      }

      print(userDataAlertValue);
      setState(() {});

      if (userDataAlertValue == '1' && audioListnStart == true) {
        playAudio(1);
      } else if (userDataAlertValue == '2' && audioListnStart == true) {
        playAudio(2);
      } else if (userDataAlertValue == '3' && audioListnStart == true) {
        playAudio(3);
      } else if (userDataAlertValue == '4' && audioListnStart == true) {
        playAudio(4);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  playAudio(int value) async {
    FlutterRingtonePlayer.play(
      fromAsset: 'assets/audio/$value.mp3',
      ios: IosSounds.glass,
      volume: 0.9,
      asAlarm: false,
    );
    setState(() {
      audioListnStart = false;
      userDataAlertValue = null;
    });

    try {
      await FirebaseFirestore.instance
          .collection('User')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .update({
        'audioListnStart': false,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Geolocator.getPositionStream().listen((Position position) async {
    //   placemarks =
    //       await placemarkFromCoordinates(position.latitude, position.longitude);
    //   userlat = '${position.latitude}';
    //   userLong = '${position.longitude}';
    //   userInfoWundow =
    //       'My Current : ${placemarks.reversed.last.country}, ${placemarks.reversed.last.locality}, ${placemarks.reversed.last.street}';
    //   print('New ${userlat.toString()} : ${userLong.toString()}');
    // });

    bool canPop = true;
    return WillPopScope(
      onWillPop: () async {
        if (canPop) {
          setState(() {
            startCommunicationValue = false;
          });
          return false;
        } else {
          return false;
        }
      },
      child: Scaffold(
        appBar: startCommunicationValue == false
            ? AppBar(
                leading: IconButton(
                  onPressed: () {
                    ZoomDrawer.of(context).open();
                  },
                  icon: Icon(
                    Icons.menu,
                    color: AppColor.primaryColor,
                  ),
                ),
                title: RichText(
                  text: TextSpan(
                    children: [
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Text(
                          "V",
                          style: TextStyle(
                            fontSize: 20,
                            color: AppColor.blackColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Text(
                          '2',
                          style: TextStyle(
                            fontSize: 20,
                            color: AppColor.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Text(
                          "V",
                          style: TextStyle(
                            fontSize: 20,
                            color: AppColor.blackColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                centerTitle: true,
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: GestureDetector(
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
                      child: CircleAvatar(
                        backgroundColor: AppColor.primaryColor,
                        backgroundImage: Image.asset(
                          Components.showPersonIcon(context),
                          fit: BoxFit.fill,
                        ).image,
                      ),
                    ),
                  ),
                ],
              )
            : AppBar(
                backgroundColor: AppColor.primaryColor,
                leading: IconButton(
                    onPressed: () {
                      setState(() {
                        startCommunicationValue = !startCommunicationValue;
                      });
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: AppColor.whiteColor,
                    )),
                elevation: 0,
                title: Text(
                  "Start Communication",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColor.whiteColor,
                  ),
                ),
                centerTitle: true,
              ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .6,
                width: double.infinity,
                child: Scaffold(
                  body: GoogleMap(
                    mapType: MapType.normal,
                    markers: Set<Marker>.of(markers),
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                          double.tryParse(userlat), double.tryParse(userLong)),
                      zoom: 14.4746,
                    ),
                    // circles: {
                    //   Circle(
                    //     circleId: const CircleId("0"),
                    //     center: LatLng(
                    //         double.tryParse(userlat), double.tryParse(userLong)),
                    //     radius: 100,
                    //     strokeWidth: 2,
                    //     strokeColor: AppColor.primaryColor,
                    //     visible: true,
                    //   ),
                    // },
                    onMapCreated: (mapController) {
                      googleMapcontroller.complete(mapController);
                    },
                    zoomGesturesEnabled: true,
                    tiltGesturesEnabled: false,
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * .277,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: AppColor.primaryColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    )),
                child: startCommunicationValue == false
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                startCommunicationValue =
                                    !startCommunicationValue;
                              });
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height * .1,
                              width: MediaQuery.of(context).size.width * .9,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 2),
                              decoration: BoxDecoration(
                                  color: AppColor.whiteColor,
                                  borderRadius: BorderRadius.circular(15)),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 22,
                                    backgroundColor: AppColor.pagesColor,
                                    // maxRadius: MediaQuery.of(context).size.height * .06,
                                    backgroundImage: const AssetImage(
                                      'assets/icons/1_start_communication.png',
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "Start Communication",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: AppColor.blackColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SendAlertPage(),
                                    ),
                                  );
                                },
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * .1,
                                  width:
                                      MediaQuery.of(context).size.width * .45,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 3),
                                  decoration: BoxDecoration(
                                      color: AppColor.whiteColor,
                                      borderRadius: BorderRadius.circular(15)),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundColor: AppColor.pagesColor,
                                        // maxRadius: MediaQuery.of(context).size.height * .06,
                                        backgroundImage: const AssetImage(
                                          'assets/icons/3_send_alert.png',
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          "Send Alert",
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: AppColor.blackColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // setState(() {
                                  //   callEmmergency = !callEmmergency;
                                  // });
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CallEmergencyPage(),
                                    ),
                                  );
                                },
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * .1,
                                  width:
                                      MediaQuery.of(context).size.width * .45,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 2),
                                  decoration: BoxDecoration(
                                      color: AppColor.whiteColor,
                                      borderRadius: BorderRadius.circular(15)),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundColor: AppColor.pagesColor,
                                        // maxRadius: MediaQuery.of(context).size.height * .06,
                                        backgroundImage: const AssetImage(
                                          'assets/icons/2_call_emergency.jpeg',
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          "Call Emergency",
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: AppColor.blackColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("messages")
                                // .where("userUID",
                                //     isEqualTo: FirebaseAuth.instance.currentUser.uid)
                                .orderBy('time', descending: true)
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<
                                        QuerySnapshot<Map<String, dynamic>>>
                                    snapshot) {
                              if (snapshot.hasData && snapshot.data != null) {
                                if (snapshot.data.docs.isNotEmpty) {
                                  return ListView.builder(
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      Map<String, dynamic> documentData =
                                          snapshot.data.docs[index].data();

                                      Timestamp timestamp =
                                          documentData["time"];
                                      DateTime dateTime = timestamp.toDate();

                                      if (documentData.isNotEmpty) {
                                        if (documentData['reciverUserUID'] ==
                                            FirebaseAuth
                                                .instance.currentUser.uid
                                                .toString()) {
                                          return Card(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 3),
                                            elevation: 5,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: ListTile(
                                              horizontalTitleGap: 7,
                                              // leading: CircleAvatar(
                                              //   backgroundColor: AppColor.primaryColor,
                                              //   backgroundImage: documentData[
                                              //               'profileImageLink'] !=
                                              //           "0"
                                              //       ? NetworkImage(
                                              //           documentData['profileImageLink'])
                                              //       : const NetworkImage(
                                              //           "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSXlbMgzYw0M94bT-Sp1UGBBHLj60mz3wVtWQ&usqp=CAU"),
                                              // ),
                                              title: Text(
                                                  documentData['senderName']),
                                              subtitle: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    dateTime
                                                        .toString()
                                                        .substring(0, 16),
                                                    style: TextStyle(
                                                      // fontSize: 15,
                                                      color:
                                                          AppColor.blackColor,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  Text(documentData["message"]),
                                                ],
                                              ),
                                            ),
                                          );
                                        } else {
                                          return const SizedBox(
                                              height: 0, width: 0);
                                        }
                                      } else {
                                        return const SizedBox(
                                            height: 0, width: 0);
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
                                      style:
                                          TextStyle(color: AppColor.blackColor),
                                    ),
                                  );
                                }
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: AppColor.whiteColor,
                                  ),
                                );
                              }
                            }),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // double calculateDistance(lat1, lon1, lat2, lon2) {
  //   print(double.tryParse(lat2.toString().substring(0, 6)).toString());
  //   var p = 0.016453292519943295;
  //   var a = 0.5 -
  //       cos((double.tryParse(lat2.toString().substring(0, 7)) -
  //                   double.tryParse(lat1.toString().substring(0, 7))) *
  //               p) /
  //           2 +
  //       cos(double.tryParse(lat1.toString().substring(0, 7)) * p) *
  //           cos(double.tryParse(lat2.toString().substring(0, 7)) * p) *
  //           (1 -
  //               cos((double.tryParse(lon2.toString().substring(0, 7)) -
  //                       double.tryParse(lon1.toString().substring(0, 7))) *
  //                   p)) /
  //           2;
  //   return 12742 * asin(sqrt(a));
  // }

  loadData(BuildContext context) async {
    getUserCurrentLocation(context).then((value) async {
      try {
        // print('${userlat.toString()} : ${userLong.toString()}');

        List<Placemark> placemarks =
            await placemarkFromCoordinates(value.latitude, value.longitude);

        userlat = '${value.latitude}';
        userLong = '${value.longitude}';
        userInfoWundow =
            'My Current : ${placemarks.reversed.last.country}, ${placemarks.reversed.last.locality}, ${placemarks.reversed.last.street}';

        await FirebaseFirestore.instance
            .collection('User')
            .doc(FirebaseAuth.instance.currentUser.uid)
            .update({
          'lat_long': [
            userlat,
            userLong,
            '${placemarks.reversed.last.country}, ${placemarks.reversed.last.locality}, ${placemarks.reversed.last.street}'
          ],
        });

        // new
        if (cameraMove == true) {
          GoogleMapController controller = await googleMapcontroller.future;

          setState(() {
            controller.animateCamera(
              CameraUpdate.newCameraPosition(CameraPosition(
                  zoom: 17,
                  target:
                      LatLng(double.parse(userlat), double.parse(userLong)))),
            );
          });
        }
      } catch (e) {
        print(e.toString());
      }
    });
  }

  void getLatLongAllUsers(BuildContext context) async {
    print('ABC');
    QuerySnapshot snap =
        await FirebaseFirestore.instance.collection('User').get();

    List<Marker> list = [];
    for (var document in snap.docs) {
      if (document['userUID'] != FirebaseAuth.instance.currentUser.uid &&
          document['available'] == true) {
        list.add(
          Marker(
            infoWindow: InfoWindow(title: document['lat_long'][2].toString()),
            markerId: MarkerId(document['userUID'].toString()),
            position: LatLng(
              double.parse(document['lat_long'][0].toString()),
              double.parse(document['lat_long'][1].toString()),
            ),
          ),
        );
      }
    }
    markers.clear();
    final Uint8List markerIcon =
        await getBytesFromAsset('assets/icons/currentLocationIcon.png', 100);
    markers.add(
      Marker(
        infoWindow: InfoWindow(title: userInfoWundow.toString()),
        markerId: MarkerId(FirebaseAuth.instance.currentUser.uid.toString()),
        position: LatLng(double.parse(userlat.toString()),
            double.parse(userLong.toString())),
        icon: BitmapDescriptor.fromBytes(markerIcon),
      ),
    );
    setState(() {
      markers.addAll(list);
    });
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  getLatLongAllUsersMissBehaving(BuildContext context) async {
    double lessDistance = 5.0;
    String userMissBehavingUID = '';
    double distanceInzmetters;
    bool userExist = false;

    // print('ABC');
    QuerySnapshot snap =
        await FirebaseFirestore.instance.collection('User').get();

    for (var document in snap.docs) {
      if (document['userUID'] != FirebaseAuth.instance.currentUser.uid &&
          document['available'] == true) {
        distanceInzmetters = HelperUserHome.calculateDistanceWithGeo(
          double.parse(document['lat_long'][0].toString()),
          double.parse(document['lat_long'][1].toString()),
          double.parse(userlat),
          double.parse(userLong),
        );
        print(
            'getLatLongAllUsersMissBehaving : ${distanceInzmetters.toString()}');

        if (distanceInzmetters >= 0.0 && distanceInzmetters <= 3.0) {
          if (distanceInzmetters < lessDistance) {
            lessDistance = distanceInzmetters;
            userMissBehavingUID = document['userUID'].toString();
          }
        }
      }
    }

    // Components.showSnackBar(
    //     context, 'DM : ${distanceInzmetters.toString()} , LD : $lessDistance');
    var userData = await FirebaseFirestore.instance
        .collection('User')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();

    List list = userData.data()['MessangerUID'];

    for (int i = 0; i < list.length; i++) {
      if (list[i] == userMissBehavingUID) {
        userExist = true;
      }
    }
    if (userMissBehavingUID != '') {
      if (userData.data()['MessangerUID'].length != 0 && userExist == true) {
        print('Contain');
        userMissBehavingUID = '';
      } else {
        FlutterRingtonePlayer.play(
          fromAsset: 'assets/audio/missbehaving.mp3',
          ios: IosSounds.glass,
          volume: 0.9,
          asAlarm: false,
        );
        userMissBehavingUID = '';
      }
      userMissBehavingUID = '';
    }
  }
}
