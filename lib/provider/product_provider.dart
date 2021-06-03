import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_shop_app_final/model/cartmodel.dart';
import 'package:flutter_shop_app_final/model/product.dart';
import 'package:flutter_shop_app_final/model/usermodel.dart';

class ProductProvider with ChangeNotifier {
  List<Product> feature = [];
  Product featureData;

  List<CartModel> checkOutModelList = [];
  CartModel checkOutModel;
  List<UserModel> userModelList = [];
  UserModel userModel;

  Future<void> getUserData() async {
    List<UserModel> newList = [];
    User currentUser = FirebaseAuth.instance.currentUser;
    QuerySnapshot userSnapShot =
    await FirebaseFirestore.instance.collection("User").get();
    userSnapShot.docs.forEach(
          (element) {
        if (currentUser.uid == element["UserId"]) {
          userModel = UserModel(
              userAddress: element["UserAddress"],
              userImage: element["UserImage"],
              userEmail: element["UserEmail"],
              userGender: element["UserGender"],
              userName: element["UserName"],
              userPhoneNumber: element["UserNumber"]);
          newList.add(userModel);
        }
        userModelList = newList;
      },
    );
  }

  List<UserModel> get getUserModelList {
    return userModelList;
  }

  void deleteCheckoutProduct(int index) {
    checkOutModelList.removeAt(index);
    notifyListeners();
  }

  void clearCheckoutProduct() {
    checkOutModelList.clear();
    notifyListeners();
  }

  void getCheckOutData({
    int quentity,
    int price,
    String name,
    String color,
    String size,
    String image,
  }) {
    checkOutModel = CartModel(
      color: color,
      size: size,
      price: price,
      name: name,
      image: image,
      quentity: quentity,
    );
    checkOutModelList.add(checkOutModel);
  }

  List<CartModel> get getCheckOutModelList {
    return List.from(checkOutModelList);
  }

  int get getCheckOutModelListLength {
    return checkOutModelList.length;
  }

  Future<void> getFeatureData() async {
    List<Product> newList = [];
    QuerySnapshot featureSnapShot = await FirebaseFirestore.instance
        .collection("products")
        .doc("BplO7XqCLZi4m5sxfZKD")
        .collection("featureproduct")
        .get();
    featureSnapShot.docs.forEach(
          (element) {
        featureData = Product(
            image: element["image"],
            name: element["name"],
            price: element["price"]);
        newList.add(featureData);
      },
    );
    feature = newList;
  }

  List<Product> get getFeatureList {
    return feature;
  }

  List<Product> homeFeature = [];

  Future<void> getHomeFeatureData() async {
    List<Product> newList = [];
    QuerySnapshot featureSnapShot =
    await FirebaseFirestore.instance.collection("homefeature").get();
    featureSnapShot.docs.forEach(
          (element) {
        featureData = Product(
            image: element["image"],
            name: element["name"],
            price: element["price"]);
        newList.add(featureData);
      },
    );
    homeFeature = newList;
    notifyListeners();
  }

  List<Product> get getHomeFeatureList {
    return homeFeature;
  }

  List<Product> homeAchive = [];

  Future<void> getHomeAchiveData() async {
    List<Product> newList = [];
    QuerySnapshot featureSnapShot =
    await FirebaseFirestore.instance.collection("homeachive").get();
    featureSnapShot.docs.forEach(
          (element) {
        featureData = Product(
            image: element["image"],
            name: element["name"],
            price: element["price"]);
        newList.add(featureData);
      },
    );
    homeAchive = newList;
    notifyListeners();
  }

  List<Product> get getHomeAchiveList {
    return homeAchive;
  }

  List<Product> newAchives = [];
  Product newAchivesData;
  Future<void> getNewAchiveData() async {
    List<Product> newList = [];
    QuerySnapshot achivesSnapShot = await FirebaseFirestore.instance
        .collection("products")
        .doc("BplO7XqCLZi4m5sxfZKD")
        .collection("newachives")
        .get();
    achivesSnapShot.docs.forEach(
          (element) {
        newAchivesData = Product(
            image: element["image"],
            name: element["name"],
            price: element["price"]);
        newList.add(newAchivesData);
      },
    );
    newAchives = newList;
    notifyListeners();
  }

  List<Product> get getNewAchiesList {
    return newAchives;
  }

  List<String> notificationList = [];

  void addNotification(String notification) {
    notificationList.add(notification);
  }

  int get getNotificationIndex {
    return notificationList.length;
  }

  get getNotificationList {
    return notificationList;
  }

  List<Product> searchList;
  void getSearchList({List<Product> list}) {
    searchList = list;
  }

  List<Product> searchProductList(String query) {
    List<Product> searchShirt = searchList.where((element) {
      return element.name.toUpperCase().contains(query) ||
          element.name.toLowerCase().contains(query);
    }).toList();
    return searchShirt;
  }
}
