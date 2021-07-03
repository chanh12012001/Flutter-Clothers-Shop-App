import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app_flutter/providers/cart_provider.dart';
import 'package:grocery_app_flutter/providers/location_provider.dart';
import 'package:grocery_app_flutter/screens/map_screen.dart';
import 'package:grocery_app_flutter/screens/profile_screen.dart';
import 'package:grocery_app_flutter/services/user_services.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartBottomSheet extends StatefulWidget {
  @override
  _CartBottomSheetState createState() => _CartBottomSheetState();
}

class _CartBottomSheetState extends State<CartBottomSheet> {
  UserServices _userService = UserServices();
  User user = FirebaseAuth.instance.currentUser;

  String _location = '';
  String _address = '';
  bool _loading = false;
  bool _checkingUser=false;

  getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String location = prefs.getString('location');
    String address = prefs.getString('address');
    setState(() {
      _location = location;
      _address = address;
    });
  }

  @override
  void initState() {
    getPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationProvider>(context);
    var _cartProvider = Provider.of<CartProvider>(context);

    return Container(
      height: 140,
      color: Colors.blueGrey[900],
      child: Column(
        children: [
          Container(
            height: 80,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Giao hàng đến địa chỉ này: ',
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          setState(() {
                            _loading=true;
                          });
                          locationData.getCurrentPosition().then((value){
                            setState(() {
                              _loading=false;
                            });
                            if (value!=null) {
                              pushNewScreenWithRouteSettings(
                                context,
                                settings: RouteSettings(name: MapScreen.id),
                                screen: MapScreen(),
                                withNavBar: false,
                                pageTransitionAnimation: PageTransitionAnimation.cupertino,
                              );
                            } else {
                              setState(() {
                                _loading=false;
                              });
                            }
                          });
                        },
                        child: _loading ? CircularProgressIndicator(): Text(
                          'Thay đổi',
                          style: TextStyle(color: Colors.red,fontSize: 12),
                        ),
                      )
                    ],
                  ),
                  Text(
                    '$_location, $_address',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${_cartProvider.subTotal.toStringAsFixed(0)}\đ',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '(Đã bao gồm tất cả thuế)',
                        style: TextStyle(color: Colors.green, fontSize: 10),
                      )
                    ],
                  ),
                  RaisedButton(
                      child: _checkingUser ? CircularProgressIndicator() : Text(
                        'THANH TOÁN',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      color: Colors.redAccent,
                      onPressed: () {
                        setState(() {
                          _checkingUser=true;
                        });
                        _userService.getUserById(user.uid).then((value){
                          if(value.data()['userName']==null){
                            setState(() {
                              _checkingUser=false;
                            });
                            //need to confirm user name before placing order
                            pushNewScreenWithRouteSettings(
                              context,
                              settings: RouteSettings(name: ProfileScreen.id),
                              screen: ProfileScreen(),
                              pageTransitionAnimation: PageTransitionAnimation.cupertino,
                            );
                          }else{
                            //xác nhận thanh toán phương thức (cash on delivery or pay online)
                            setState(() {
                              _checkingUser=false;
                            });
                          }
                        });
                      }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
