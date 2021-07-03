import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:grocery_app_flutter/constants.dart';
import 'package:grocery_app_flutter/providers/auth_provider.dart';
import 'package:grocery_app_flutter/providers/cart_provider.dart';
import 'package:grocery_app_flutter/providers/coupon_provider.dart';
import 'package:grocery_app_flutter/providers/location_provider.dart';
import 'package:grocery_app_flutter/providers/order_provider.dart';
import 'package:grocery_app_flutter/providers/store_provider.dart';
import 'package:grocery_app_flutter/screens/cart_screen.dart';
import 'package:grocery_app_flutter/screens/home_screen.dart';
import 'package:grocery_app_flutter/screens/landing_screen.dart';
import 'package:grocery_app_flutter/screens/login_screen.dart';
import 'package:grocery_app_flutter/screens/main_screen.dart';
import 'package:grocery_app_flutter/screens/my_orders_screen.dart';
import 'package:grocery_app_flutter/screens/payment/create_new_card_screen.dart';
import 'package:grocery_app_flutter/screens/payment/credit_card_list.dart';
import 'package:grocery_app_flutter/screens/payment/payment_home.dart';
import 'package:grocery_app_flutter/screens/payment/stripe/existing-cards.dart';
import 'package:grocery_app_flutter/screens/product_details_screen.dart';
import 'package:grocery_app_flutter/screens/product_list_screen.dart';
import 'package:grocery_app_flutter/screens/profile_screen.dart';
import 'package:grocery_app_flutter/screens/profile_update_screen.dart';
import 'package:grocery_app_flutter/screens/splash_screen.dart';
import 'package:grocery_app_flutter/screens/vendor_home_screen.dart';
import 'package:grocery_app_flutter/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
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
        ChangeNotifierProvider(
          create: (_) => OrderProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: kPrimaryColor,
          fontFamily: 'Lato'
      ),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id :(context)=>SplashScreen(),
        HomeScreen.id:(context)=>HomeScreen(),
        WelcomeScreen.id:(context)=>WelcomeScreen(),
        LoginScreen.id:(context)=>LoginScreen(),
        LandingScreen.id:(context)=>LandingScreen(),
        MainScreen.id:(context)=>MainScreen(),
        VendorHomeScreen.id:(context)=>VendorHomeScreen(),
        ProductListScreen.id:(context)=>ProductListScreen(),
        ProductDetailsScreen.id:(context)=>ProductDetailsScreen(),
        CartScreen.id:(context)=>CartScreen(),
        ProfileScreen.id:(context)=>ProfileScreen(),
        UpdateProfile.id:(context)=>UpdateProfile(),
        ExistingCardsPage.id:(context)=>ExistingCardsPage(),
        PaymentHome.id:(context)=>PaymentHome(),
        MyOrders.id:(context)=>MyOrders(),
        CreditCardList.id:(context)=>CreditCardList(),
        CreateNewCreditCard.id:(context)=>CreateNewCreditCard(),
      },
      builder: EasyLoading.init(),
    );

  }
}









