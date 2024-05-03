import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:mubashir/components/constants.dart';
import 'package:mubashir/pages/screens/menu_screen.dart';
import 'package:mubashir/pages/screens/user_home_page.dart';

class FlutterZoomDrawerPage extends StatelessWidget {
  FlutterZoomDrawerPage({Key key}) : super(key: key);

  final zoomDrawerController = ZoomDrawerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ZoomDrawer(
        controller: zoomDrawerController,
        borderRadius: 24.0,
        showShadow: true,
        shadowLayer2Color: AppColor.primaryColor,
        shadowLayer1Color: AppColor.primaryColor.withOpacity(0.5),
        angle: 0.0,
        drawerShadowsBackgroundColor: Colors.grey[300],
        slideWidth: MediaQuery.of(context).size.width * 0.75,
        menuScreenWidth: MediaQuery.of(context).size.width * 0.75,
        mainScreen: UserHomePage(context1: context),
        menuScreen: const MenuScreen(),
        style: DrawerStyle.defaultStyle,
        moveMenuScreen: false,
      ),
    );
  }
}
