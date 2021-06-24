import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{

  static const NUMBER = 'number'; //để tránh lỗi chính tả
  static const ID = 'id';

  String _number;
  String _id;

  String get number => _number;
  String get id => _id;

  UserModel.formSnapshot(DocumentSnapshot snapshot) {
    _number = snapshot[NUMBER];
    _id = snapshot[ID];
  }
}