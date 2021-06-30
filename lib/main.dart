import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:grocery_app_flutter/providers/auth_provider.dart';
import 'package:grocery_app_flutter/providers/cart_provider.dart';
import 'package:grocery_app_flutter/providers/coupon_provider.dart';
import 'package:grocery_app_flutter/providers/location_provider.dart';
import 'package:grocery_app_flutter/providers/store_provider.dart';
import 'package:grocery_app_flutter/screens/cart_screen.dart';
import 'package:grocery_app_flutter/screens/home_screen.dart';
import 'package:grocery_app_flutter/screens/landing_screen.dart';
import 'package:grocery_app_flutter/screens/login_screen.dart';
import 'package:grocery_app_flutter/screens/map_screen.dart';
import 'package:grocery_app_flutter/screens/product_details_screen.dart';
import 'package:grocery_app_flutter/screens/product_list_screen.dart';
import 'package:grocery_app_flutter/screens/profile_screen.dart';
import 'package:grocery_app_flutter/screens/profile_update_screen.dart';
import 'package:grocery_app_flutter/screens/vendor_home_screen.dart';
import 'package:grocery_app_flutter/screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'screens/main_screen.dart';
import 'screens/splash_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => AuthProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => LocationProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => StoreProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => CartProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => CouponProvider(),
      ),
    ],
    child: MyApp(),
  ),);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF84c225),
        fontFamily: 'Lato'
      ),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id : (context) => SplashScreen(),
        HomeScreen.id : (context) => HomeScreen(),
        WelcomeScreen.id : (context) => WelcomeScreen(),
        MapScreen.id : (context) => MapScreen(),
        LoginScreen.id : (context) => LoginScreen(),
        LandingScreen.id : (context) => LandingScreen(),
        MainScreen.id : (context) => MainScreen(),
        VendorHomeScreeen.id : (context) => VendorHomeScreeen(),
        ProductListScreen.id : (context) => ProductListScreen(),
        ProductDetailScreen.id : (context) => ProductDetailScreen(),
        CartScreen.id : (context) => CartScreen(),
        ProfileScreen.id : (context) => ProfileScreen(),
        UpdateProfile.id : (context) => UpdateProfile(),


      },
      builder: EasyLoading.init(
      ),
    );
  }
}
