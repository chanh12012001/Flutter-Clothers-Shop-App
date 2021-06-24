import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app_flutter/providers/auth_provider.dart';
import 'package:grocery_app_flutter/providers/location_provider.dart';
import 'package:grocery_app_flutter/providers/store_provider.dart';
import 'package:grocery_app_flutter/screens/home_screen.dart';
import 'package:grocery_app_flutter/screens/landing_screen.dart';
import 'package:grocery_app_flutter/screens/login_screen.dart';
import 'package:grocery_app_flutter/screens/map_screen.dart';
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
      }
    );
  }
}
