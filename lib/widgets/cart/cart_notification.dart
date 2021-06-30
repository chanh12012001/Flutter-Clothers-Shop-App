import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app_flutter/providers/cart_provider.dart';
import 'package:grocery_app_flutter/screens/cart_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../services/cart_services.dart';
import '../../services/cart_services.dart';

class CartNotification extends StatefulWidget {
  @override
  _CartNotificationState createState() => _CartNotificationState();
}

class _CartNotificationState extends State<CartNotification> {
  CartServices _cart = CartServices();
  DocumentSnapshot document;

  @override
  Widget build(BuildContext context) {
    final _cartProvider = Provider.of<CartProvider>(context);
    _cartProvider.getCartTotal();
    _cart.getShopName().then((value){
      setState(() {
        document = value;
      });
    });
    return Visibility(
      visible: _cartProvider.distance <= 10 ? _cartProvider.cartQty > 0 ? true : false : false,
      child: Container(
        height: 45,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(12),
            topLeft: Radius.circular(12),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('${_cartProvider.cartQty} sản phẩm',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(' | ', style: TextStyle( color: Colors.white),),
                        Text('\$${_cartProvider.subTotal.toStringAsFixed(1)}',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                    if(document.exists)
                    Text('Từ ${document.data()['shopName']}',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 10
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: (){
                  pushNewScreenWithRouteSettings(
                    context,
                    settings: RouteSettings(name: CartScreen.id),
                    screen: CartScreen(
                      document: document,
                    ),
                    withNavBar: false,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
                child: Container(
                  child: Row(
                    children: [
                      Text('Xem giỏ hàng',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 5,),
                      Icon(Icons.shopping_cart_outlined,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
