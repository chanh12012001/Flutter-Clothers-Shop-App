import 'package:flutter/material.dart';
import 'package:grocery_app_flutter/providers/auth_provider.dart';
import 'package:grocery_app_flutter/providers/location_provider.dart';
import 'package:grocery_app_flutter/screens/map_screen.dart';
import 'package:grocery_app_flutter/screens/onboard_screen.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  final Key _mapKey = UniqueKey();
  static const String id = 'welcome-screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {

    final auth = Provider.of<AuthProvider>(context);

    bool _validPhoneNumber = false;
    var _phoneNumberController = TextEditingController();

    void showBottomSheet(context) {
      showModalBottomSheet(
        context: context,
        builder: (context)=>StatefulBuilder(
          builder: (BuildContext context, StateSetter myState){
            return Container(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: auth.error == 'Invalid OTP'? true : false,
                      child: Container(
                        child: Column(
                          children: [
                            Text(auth.error,style: TextStyle(color: Colors.red,fontSize: 12),),
                            SizedBox(height: 5,),
                          ],
                        ),
                      ),
                    ),
                    Text(
                      'ĐĂNG NHẬP',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Nhập số điện thoại của bạn để tiếp tục ',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        prefixText: '+84',
                        labelText: 'SĐT di động 10 chữ số',
                      ),
                      autofocus: true,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      controller: _phoneNumberController,
                      onChanged: (value){
                        if(value.length==10){
                          myState((){
                            _validPhoneNumber = true;
                          });
                        }else{
                          myState((){
                            _validPhoneNumber = false;
                          });
                        }
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: AbsorbPointer(
                            absorbing: _validPhoneNumber ? false:true,
                            child: FlatButton(
                              onPressed: () {
                                myState((){
                                  auth.loading=true;
                                });
                                String number ='+84${_phoneNumberController.text}';
                                auth.verifyPhone(context: context, number: number).then((value){
                                  _phoneNumberController.clear();
                                });
                              },
                              color: _validPhoneNumber ? Theme.of(context).primaryColor : Colors.grey,
                              child: auth.loading ? CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ): Text(_validPhoneNumber ? 'TIẾP TỤC' : 'NHẬP SỐ ĐIỆN THOẠI',style: TextStyle(color: Colors.white),),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ).whenComplete((){
        setState(() {
          auth.loading=false;
          _phoneNumberController.clear();
        });
      });
    }

    final locationData = Provider.of<LocationProvider>(context,listen: false);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          children: [
            Positioned(
              right: 0.0,
              top: 10.0,
              child: FlatButton(
                child: Text(
                  'Bỏ qua',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                onPressed: () {},
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: OnBoardScreen(),
                ),
                Text(
                  'Sẵn sàng để đặt hàng từ cửa hàng gần nhất của bạn?',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(
                  height: 10,
                ),
                FlatButton(
                  color: Theme.of(context).primaryColor,
                  child: locationData.loading ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ) : Text(
                    'THIẾT LẬP ĐỊA CHỈ GIAO HÀNG',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async{
                    setState(() {
                      locationData.loading=true;
                    });
                    await locationData.getCurrentPosition();
                    if(locationData.permissionAllowed==true){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => MapScreen()));
                      setState(() {
                        locationData.loading=false;
                      });
                    }else{
                      setState(() {
                        locationData.loading=false;
                      });
                    }
                  },
                ),
                FlatButton(
                  child: RichText(
                    text: TextSpan(
                      text: 'Đã là khách hàng ? ',
                      style: TextStyle(color: Colors.grey),
                      children: [
                        TextSpan(
                          text: 'Đăng nhập',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orangeAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      auth.screen = 'Login';
                    });
                    showBottomSheet(context);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}