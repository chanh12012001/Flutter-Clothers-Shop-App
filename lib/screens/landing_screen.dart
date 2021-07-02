import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app_flutter/providers/location_provider.dart';
import 'package:grocery_app_flutter/screens/main_screen.dart';
import 'package:grocery_app_flutter/screens/map_screen.dart';
import 'package:grocery_app_flutter/services/user_services.dart';

class LandingScreen extends StatefulWidget {
  static const String id = 'landing-screen';

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  LocationProvider _locationProvider = LocationProvider();
  bool _loading = false;
  UserServices _userServices = UserServices();
  User user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {

    _userServices.getUserById(user.uid).then((result){
      if(result.data()['latitude']!=null){
        Navigator.pushReplacementNamed(context, MainScreen.id);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Địa chỉ giao hàng chưa được thiết lập ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Vui lòng cập nhật địa điểm giao hàng của bạn để tìm các cửa hàng gần nhất cho bạn ',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),

            Container(
              width: 600,
              child: Image.asset(
                'images/city.png',
                fit: BoxFit.fill,
                color: Colors.black12,
              ),
            ),
            _loading ? CircularProgressIndicator() : FlatButton(
              color: Theme.of(context).primaryColor,
              onPressed: () async{
                setState(() {
                  _loading = true;
                });

                await _locationProvider.getCurrentPosition();
                if (_locationProvider.permissionAllowed==true) {

                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (BuildContext context) => MapScreen()));
                } else {
                  Future.delayed(Duration(seconds: 4),(){
                    if (_locationProvider.permissionAllowed == false){
                      print('Không cho phép quyền truy cập');
                      setState(() {
                        _loading=false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Vui lòng cho phép quyền truy cập để tìm cửa hàng gần nhất cho bạn '),
                      ));
                    }
                  });
                }
              },
              child: Text(
                'Thiết lập vị trí của bạn',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}