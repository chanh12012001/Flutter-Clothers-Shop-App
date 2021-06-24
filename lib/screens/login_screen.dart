import 'package:flutter/material.dart';
import 'package:grocery_app_flutter/providers/auth_provider.dart';
import 'package:grocery_app_flutter/providers/location_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login-screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _validPhoneNumber = false;
  var _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final locationData = Provider.of<LocationProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: auth.error == 'OTP không hợp lệ' ? true : false,
                    child: Container(
                      child: Column(
                        children: [
                          Text(
                            auth.error,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 5,),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    'ĐĂNG NHẬP',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                      'Nhập vào số điện thoại của bạn',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      )
                  ),
                  SizedBox(height: 20,),
                  TextField(
                    decoration: InputDecoration(
                      prefixText: '+84 ',
                      labelText: 'Số điện thoại di động 10 số',
                    ),
                    autofocus: true,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    controller: _phoneNumberController,
                    onChanged: (value) {
                      if (value.length == 10) {
                        setState(() {
                          _validPhoneNumber = true;
                        });
                      } else {
                        setState(() {
                          _validPhoneNumber = false;
                        });
                      }
                    },
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Expanded(
                        child: AbsorbPointer(
                          absorbing: _validPhoneNumber ? false : true,
                          child: FlatButton(
                            onPressed: () {
                              setState(() {
                                auth.loading = true;
                                auth.screen = 'MapScreen';
                                auth.latitude = locationData.latitude;
                                auth.longitude = locationData.longitude;
                                auth.address = locationData.selectedAddress.addressLine;
                              });
                              String number = '+84${_phoneNumberController.text}.';
                              auth.verifyPhone(
                                context: context,
                                number: number,

                              ).then((value) {
                                _phoneNumberController.clear();
                                setState(() {
                                  auth.loading = false;
                                });
                              });
                            },
                            color: _validPhoneNumber ? Theme.of(context).primaryColor : Colors.grey,
                            child: auth.loading ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ) : Text(
                              _validPhoneNumber ? 'TIẾP TỤC' : 'NHẬP SỐ ĐIỆN THOẠI',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
