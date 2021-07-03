import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app_flutter/screens/home_screen.dart';
import 'package:grocery_app_flutter/screens/my_orders_screen.dart';
import 'package:grocery_app_flutter/screens/profile_screen.dart';
import 'package:grocery_app_flutter/widgets/cart/cart_notification.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class MainScreen extends StatelessWidget {
  static const String id = 'main-screen';
  @override
  Widget build(BuildContext context) {
    PersistentTabController _controller;
    _controller = PersistentTabController(initialIndex: 0);

    List<Widget> _buildScreens() {
      return [
        HomeScreen(),
        MyOrders(),
        ProfileScreen(),
      ];
    }

    List<PersistentBottomNavBarItem> _navBarsItems() {
      return [
        PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.home),
          title: ("Trang chủ"),
          activeColorPrimary: Colors.lightBlue,
          inactiveColorPrimary: CupertinoColors.systemGrey,
          textStyle: TextStyle(color: Colors.black),
        ),
        PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.bag),
          title: ("Đơn hàng"),
          activeColorPrimary:  Colors.lightBlue,
          inactiveColorPrimary: CupertinoColors.systemGrey,
          textStyle: TextStyle(color: Colors.black),
        ),
        PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.profile_circled),
          title: ("Tài khoản"),
          activeColorPrimary:  Colors.lightBlue,
          inactiveColorPrimary: CupertinoColors.systemGrey,
          textStyle: TextStyle(color: Colors.black),
        ),
      ];
    }

    return Scaffold(

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 56),
        child: CartNotification(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: PersistentTabView(
        context,
        navBarHeight: 56,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        hideNavigationBarWhenKeyboardShows: true,
        decoration: NavBarDecoration(
            borderRadius: BorderRadius.circular(0.0),
            colorBehindNavBar: Colors.white,
            border: Border.all(
                color: Colors.black45
            )
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: ItemAnimationProperties(
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation(
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle:
        NavBarStyle.style1,
      ),
    );
  }
}