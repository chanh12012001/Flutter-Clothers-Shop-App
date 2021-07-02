import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app_flutter/providers/location_provider.dart';
import 'package:grocery_app_flutter/screens/landing_screen.dart';
import 'package:grocery_app_flutter/screens/main_screen.dart';
import 'package:grocery_app_flutter/services/user_services.dart';

class AuthProvider with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String smsOtp;
  String verificationId;
  String error = '';
  UserServices _userServices = UserServices();
  bool loading = false;
  LocationProvider locationData = LocationProvider();
  String screen;
  double latitude;
  double longitude;
  String address;
  String location;
  DocumentSnapshot snapshot;

  Future<void> verifyPhone({BuildContext context, String number}) async {
    this.loading = true;
    notifyListeners();

    final PhoneVerificationCompleted verificationCompleted = (PhoneAuthCredential credential) async {
      this.loading = false;
      notifyListeners();
      await _auth.signInWithCredential(credential);
    };

    final PhoneVerificationFailed verificationFailed = (FirebaseAuthException e) {
      this.loading = false;
      print(e.code);
      this.error = e.toString();
      notifyListeners();
    };

    final PhoneCodeSent smsOtpSend = (String verId, int resendToken) async {
      this.verificationId = verId;
      //Mở hộp thoại để nhập OTP SMS đã nhận
      smsOtpDialog(context, number);
    };

    try {
      _auth.verifyPhoneNumber(
        phoneNumber: number,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: smsOtpSend,
        codeAutoRetrievalTimeout: (String verId) {
          this.verificationId = verId;
        },
      );
    } catch (e) {
      this.error = e.toString();
      this.loading = false;
      notifyListeners();
      print(e);
    }
  }

  Future<bool> smsOtpDialog(BuildContext context, String number) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: [
                Text('Mã xác nhận'),
                SizedBox(
                  height: 6,
                ),
                Text(
                  'Nhập OTP 6 chữ số nhận được từ SMS ',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            content: Container(
              height: 85,
              child: TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 6,
                onChanged: (value) {
                  this.smsOtp = value;
                },
              ),
            ),
            actions: [
              FlatButton(
                onPressed: () async {
                  try {
                    PhoneAuthCredential phoneAuthCredential =
                    PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsOtp);

                    final User user = (await _auth.signInWithCredential(phoneAuthCredential)).user;

                    if (user != null) {
                      this.loading = false;
                      notifyListeners();

                      _userServices.getUserById(user.uid).then((snapShot) {
                        if (snapShot.exists) {
                          //Dữ liệu người dùng đã tồn tại
                          if (this.screen == 'Login') {
                            if (snapShot.data()['address'] != null) {
                              Navigator.pushReplacementNamed(context, MainScreen.id);
                            }
                            Navigator.pushReplacementNamed(context, LandingScreen.id);
                          } else {
                            //Cần cập nhật địa chỉ mới đã chọn
                            updateUser(id: user.uid, number: user.phoneNumber);
                            Navigator.pushReplacementNamed(context, MainScreen.id);
                          }
                        } else {
                          _createUser(id: user.uid, number: user.phoneNumber);
                          Navigator.pushReplacementNamed(context, LandingScreen.id);
                        }
                      });
                    } else {
                      print('Đăng nhập thất bại');
                    }
                  } catch (e) {
                    this.error = 'OTP không hợp lệ';
                    notifyListeners();
                    print(e.toString());
                    Navigator.of(context).pop();
                  }
                },
                child: Text(
                  'XONG',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
            ],
          );
        }).whenComplete(() {
      this.loading = false;
      notifyListeners();
    });
  }

  void _createUser({String id, String number}) {
    _userServices.createUserData({
      'id': id,
      'number': number,
      'latitude': this.latitude,
      'longitude': this.longitude,
      'address': this.address,
      'location': this.location,
      'firstName' : 'Chưa xác nhận',
      'lastName' : ' '
    });
    this.loading = false;
    notifyListeners();
  }

  void updateUser({String id,
    String number,}) {
    _userServices.updateUserData({
      'id': id,
      'number': number,
      'latitude': this.latitude,
      'longitude': this.longitude,
      'address': this.address,
      'location': this.location
    });
    this.loading = false;
    notifyListeners();
  }

  getUserDetails()async {
    DocumentSnapshot result = await FirebaseFirestore.instance.collection('users').doc(
        _auth.currentUser.uid).get();
    if(result !=null){
      this.snapshot = result;
      notifyListeners();
    }else{
      this.snapshot = null;
      notifyListeners();
    }
    return result;
  }
}

