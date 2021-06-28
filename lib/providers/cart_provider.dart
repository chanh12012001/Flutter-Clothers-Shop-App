import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:grocery_app_flutter/services/cart_services.dart';

import '../services/cart_services.dart';
import '../services/cart_services.dart';

class CartProvider with ChangeNotifier{

  CartServices _cart = CartServices();
  double subTotal = 0.0;
  int cartQty = 0;
  QuerySnapshot snapshot;

  Future<double>getCartTotal()async{
    var carTotal = 0.0;
     QuerySnapshot snapshot = await _cart.cart.doc(_cart.user.uid).collection('products').get();
    if(snapshot == null){
      return null;
    }
    snapshot.docs.forEach((doc) {
      carTotal = carTotal + doc.data()['total'];
    });

    this.subTotal = carTotal;
    this.cartQty = snapshot.size;
    this.snapshot = snapshot;
    notifyListeners();
    return carTotal;
  }
}