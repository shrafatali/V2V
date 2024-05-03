// ignore_for_file: avoid_print

import 'dart:math';

import 'package:geolocator/geolocator.dart';

class HelperUserHome {
  static double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  static double calculateDistanceWithGeo(lat1, lon1, lat2, lon2) {
    // var a = Geolocator.distanceBetween(startLatitude, startLongitude, endLatitude, endLongitude)
    double a = Geolocator.distanceBetween(
      double.tryParse(lat1.toString()),
      double.tryParse(lon1.toString()),
      double.tryParse(lat2.toString()),
      double.tryParse(lon2.toString()),
    );
    return a;
  }
  ////////////////////////////////////////////////////////////////////////////////////////////
  // var p = 0.017453292519943295;
  // var a = 0.5 -
  //     cos((lat2 - lat1) * p) / 2 +
  //     cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
  // return 1000 * 12742 * asin(sqrt(a));

  ///////////////////////////////////////////////////////////////////////////////////////////

  // static double calculateDistanceWithGeo(double lat1, lon1, lat2, lon2) {
  //   var R = 6372.8; // In kilometers
  //   double dLat = _toRadians(lat2 - lat1);
  //   double dLon = _toRadians(lon2 - lon1);
  //   lat1 = _toRadians(lat1);
  //   lat2 = _toRadians(lat2);
  //   double a =
  //       pow(sin(dLat / 2), 2) + pow(sin(dLon / 2), 2) * cos(lat1) * cos(lat2);
  //   double c = 2 * asin(sqrt(a));

  //   var returnValue = R * c;
  //   // print("returnValue KM : $returnValue ");
  //   // print("returnValue Meter : ${returnValue * 100}");
  //   // return (returnValue * 1000);
  //   print("returnValue Meter : $returnValue");
  //   return returnValue;
  // }

///////////////////////////////////////////////////////////////////////////////////////////////
  // var p = 0.017453292519943295;
  // var c = cos;
  // var a = 0.5 -
  //     c((lat2 - lat1) * p) / 2 +
  //     c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;

  // double distanceInzmetters = (12742 * asin(sqrt(a))) / 1000;
  // return distanceInzmetters;

  //////////////////////////////////////////////////////////////////////////////////
}

double _toRadians(double degree) {
  return degree * pi / 180;
  // }
}
