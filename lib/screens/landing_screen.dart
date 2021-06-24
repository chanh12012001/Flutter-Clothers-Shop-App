import 'package:flutter/material.dart';
import 'package:grocery_app_flutter/providers/location_provider.dart';
import 'package:grocery_app_flutter/screens/map_screen.dart';

class LandingScreen extends StatefulWidget {
  static const String id = 'landing-screen';
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  LocationProvider _locationProvider = LocationProvider();
  bool _loading = false;

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
                'Chưa thiết lập địa chỉ giao hàng',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Vui lòng cập nhật địa chỉ giao hàng của bạn để tìm cửa hàng gần nhất',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey
                ),
              ),
            ),
          //  CircularProgressIndicator(),
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
                if (_locationProvider.permissionAllowed == true) {
                  Navigator.pushReplacementNamed(context, MapScreen.id);
                } else {
                  Future.delayed(Duration(seconds: 4), () {
                    if (_locationProvider.permissionAllowed == false) {
                      print('permission not allowed');
                      setState(() {
                        _loading = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Vui lòng cho phép truy cập vị cập vị trí để tìm những cửa hàng gần nhất cho bạn. ',),
                      ));
                    }
                  });
                }
              },
              child: Text(
                'Thiết lập địa chỉ của bạn',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
