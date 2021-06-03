import 'package:flutter/material.dart';

class UserModel {
  final String userName;
  final String userEmail;
  final String userGender;
  final String userPhoneNumber;
  final String userImage;
  final String userAddress;

  UserModel(
      {@required this.userEmail,
      @required this.userImage,
      @required this.userAddress,
      @required this.userGender,
      @required this.userName,
      @required this.userPhoneNumber});
}
