// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:mubashir/components/constants.dart';

class HeaderContainer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [AppColor.primaryColor, AppColor.secColor],
              //[orangeColors, orangeLightColors],
              end: Alignment.bottomCenter,
              begin: Alignment.topCenter),
          borderRadius:
              const BorderRadius.only(bottomLeft: Radius.circular(100))),
      child: Stack(
        children: <Widget>[
          Center(
            child: Image.asset(AppImages.logoImage),
          ),
        ],
      ),
    );
  }
}
