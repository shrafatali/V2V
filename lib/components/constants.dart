import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppColor {
  static Color appColorDark = const Color.fromRGBO(12, 10, 34, 1);

  static Color blackColor = const Color.fromRGBO(12, 10, 34, 1);
  static Color whiteColor = const Color.fromRGBO(255, 255, 255, 1);
  static Color pagesColor = const Color.fromRGBO(235, 235, 235, 1);

////new colors for this app
  static Color primaryColor = const Color(0xff6cceb7);
  static Color secColor = const Color(0xff6cceb0);
}

class Constants {
  static SharedPreferences prefs;
}

var phoneNumberFormatter = MaskTextInputFormatter(
    mask: '+92##########',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy);

class AppImages {
  static String logoImage = 'assets/images/logo1.png';
}
