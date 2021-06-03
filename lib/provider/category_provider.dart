import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shop_app_final/model/categoryicon.dart';
import 'package:flutter_shop_app_final/model/product.dart';

class CategoryProvider with ChangeNotifier {
  List<Product> mensFashion = [];
  Product mensFashionData;
  List<Product> womensFashion = [];
  Product womensFashionData;
  List<Product> shoes = [];
  Product shoesData;
  List<Product> jewelry = [];
  Product jewelryData;
  List<Product> cosmetics = [];
  Product cosmeticsData;


  List<CategoryIcon> mensFashionIcon = [];
  CategoryIcon mensFashionIconData;

  Future<void> getMensFashionIconData() async {
    List<CategoryIcon> newList = [];
    QuerySnapshot mensFashionSnapShot = await FirebaseFirestore.instance
        .collection("categoryicon")
        .doc("EQ1G3dGTa07H12scV0WY")
        .collection("mensfashion")
        .get();
    mensFashionSnapShot.docs.forEach(
          (element) {
            mensFashionIconData = CategoryIcon(image: element["image"]);
        newList.add(mensFashionIconData);
      },
    );
    mensFashionIcon = newList;
    notifyListeners();
  }

  List<CategoryIcon> get getMensFashionIcon {
    return mensFashionIcon;
  }


  List<CategoryIcon> womensFashionIcon = [];
  CategoryIcon womensFashionIconData;

  Future<void> getWomensFashionIconData() async {
    List<CategoryIcon> newList = [];
    QuerySnapshot womensFashionSnapShot = await FirebaseFirestore.instance
        .collection("categoryicon")
        .doc("EQ1G3dGTa07H12scV0WY")
        .collection("womensfashion")
        .get();
    womensFashionSnapShot.docs.forEach(
          (element) {
            womensFashionIconData = CategoryIcon(image: element["image"]);
        newList.add(womensFashionIconData);
      },
    );
    womensFashionIcon = newList;
    notifyListeners();
  }

  List<CategoryIcon> get getWomensFashionIcon {
    return womensFashionIcon;
  }


  List<CategoryIcon> shoesIcon = [];
  CategoryIcon shoesiconData;

  Future<void> getshoesIconData() async {
    List<CategoryIcon> newList = [];
    QuerySnapshot shoesSnapShot = await FirebaseFirestore.instance
        .collection("categoryicon")
        .doc("EQ1G3dGTa07H12scV0WY")
        .collection("shoessandals")
        .get();
    shoesSnapShot.docs.forEach(
          (element) {
        shoesiconData = CategoryIcon(image: element["image"]);
        newList.add(shoesiconData);
      },
    );
    shoesIcon = newList;
    notifyListeners();
  }

  List<CategoryIcon> get getShoeIcon {
    return shoesIcon;
  }


  List<CategoryIcon> jewelryIcon = [];
  CategoryIcon jewelryIconData;
  Future<void> getJewelryIconData() async {
    List<CategoryIcon> newList = [];
    QuerySnapshot jewelrySnapShot = await FirebaseFirestore.instance
        .collection("categoryicon")
        .doc("EQ1G3dGTa07H12scV0WY")
        .collection("jewelry")
        .get();
    jewelrySnapShot.docs.forEach(
          (element) {
            jewelryIconData = CategoryIcon(image: element["image"]);
        newList.add(jewelryIconData);
      },
    );
    jewelryIcon = newList;
    notifyListeners();
  }

  List<CategoryIcon> get getJewelryIcon {
    return jewelryIcon;
  }


  List<CategoryIcon> cosmmeticsIcon = [];
  CategoryIcon cosmmeticsIconData;
  Future<void> getCosmmeticsIconData() async {
    List<CategoryIcon> newList = [];
    QuerySnapshot cosmmeticsSnapShot = await FirebaseFirestore.instance
        .collection("categoryicon")
        .doc("EQ1G3dGTa07H12scV0WY")
        .collection("cosmetics")
        .get();
    cosmmeticsSnapShot.docs.forEach(
          (element) {
            cosmmeticsIconData = CategoryIcon(image: element["image"]);
        newList.add(cosmmeticsIconData);
      },
    );
    cosmmeticsIcon = newList;
    notifyListeners();
  }

  List<CategoryIcon> get getCosmeticsIcon {
    return cosmmeticsIcon;
  }

  Future<void> getMensFashionData() async {
    List<Product> newList = [];
    QuerySnapshot MensFashionSnapShot = await FirebaseFirestore.instance
        .collection("category")
        .doc("BOnzkPqb567FdAwvsGTD")
        .collection("menfashion")
        .get();
    MensFashionSnapShot.docs.forEach(
          (element) {
        mensFashionData = Product(
            image: element["image"],
            name: element["name"],
            price: element["price"]);
        newList.add(mensFashionData);
      },
    );
    mensFashion = newList;
    notifyListeners();
  }

  List<Product> get getMensFashionList {
    return mensFashion;
  }

  Future<void> getWomensFashionData() async {
    List<Product> newList = [];
    QuerySnapshot womensFashionSnapShot = await FirebaseFirestore.instance
        .collection("category")
        .doc("BOnzkPqb567FdAwvsGTD")
        .collection("womenfashion")
        .get();
    womensFashionSnapShot.docs.forEach(
          (element) {
        womensFashionData = Product(
            image: element["image"],
            name: element["name"],
            price: element["price"]);
        newList.add(womensFashionData);
      },
    );
    womensFashion = newList;
    notifyListeners();
  }

  List<Product> get getWomensFashionList {
    return womensFashion;
  }

  Future<void> getShoesData() async {
    List<Product> newList = [];
    QuerySnapshot shoesSnapShot = await FirebaseFirestore.instance
        .collection("category")
        .doc("BOnzkPqb567FdAwvsGTD")
        .collection("shoessandals")
        .get();
    shoesSnapShot.docs.forEach(
          (element) {
        shoesData = Product(
            image: element["image"],
            name: element["name"],
            price: element["price"]);
        newList.add(shoesData);
      },
    );
    shoes = newList;
    notifyListeners();
  }

  List<Product> get getshoesList {
    return shoes;
  }

  Future<void> getJewelryData() async {
    List<Product> newList = [];
    QuerySnapshot jewelrySnapShot = await FirebaseFirestore.instance
        .collection("category")
        .doc("BOnzkPqb567FdAwvsGTD")
        .collection("jewelry")
        .get();
    jewelrySnapShot.docs.forEach(
          (element) {
        jewelryData = Product(
            image: element["image"],
            name: element["name"],
            price: element["price"]);
        newList.add(jewelryData);
      },
    );
    jewelry = newList;
    notifyListeners();
  }

  List<Product> get getJewelryList {
    return jewelry;
  }

  Future<void> getCosmeticsData() async {
    List<Product> newList = [];
    QuerySnapshot cosmeticsSnapShot = await FirebaseFirestore.instance
        .collection("category")
        .doc("BOnzkPqb567FdAwvsGTD")
        .collection("cosmetics")
        .get();
    cosmeticsSnapShot.docs.forEach(
          (element) {
        cosmeticsData = Product(
            image: element["image"],
            name: element["name"],
            price: element["price"]);
        newList.add(cosmeticsData);
      },
    );
    cosmetics = newList;
    notifyListeners();
  }

  List<Product> get getCosmeticsList {
    return cosmetics;
  }

  List<Product> searchList;
  void getSearchList({List<Product> list}) {
    searchList = list;
  }

  List<Product> searchCategoryList(String query) {
    List<Product> searchShirt = searchList.where((element) {
      return element.name.toUpperCase().contains(query) ||
          element.name.toLowerCase().contains(query);
    }).toList();
    return searchShirt;
  }
}
