import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app_flutter/providers/cart_provider.dart';
import 'package:provider/provider.dart';
class CartScreen extends StatefulWidget {
  final DocumentSnapshot document;
  static const String id = 'cart_screen';
  CartScreen({this.document});
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    var _cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      bottomSheet: Container(
        height: 60,
        color: Colors.blueGrey[900] ,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${_cartProvider.subTotal.toStringAsFixed(1)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('Đã bao gồm thuế',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 10
                      ),
                    ),
                  ],
                ),
                RaisedButton(
                  child: Text('Thanh toán',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                    color: Colors.redAccent,
                    onPressed: (){
                }),
              ],
            ),
          ),
        ),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBozIsSxrolled){
          return[
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: Colors.white,
              elevation: 0.0,
              title: Column(
                children: [
                  Text(widget.document.data()['shopName'],
                    style: TextStyle(fontSize: 16),
                  ),
                  Row(
                    children: [
                      Text('${_cartProvider.cartQty} sản phẩm',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                      Text('Tổng tiền: ${_cartProvider.subTotal.toStringAsFixed(1)}',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),

                    ],
                  ),
                ],
              ),
            ),
          ];
        },
        body: Center(child: Text('Cart Screen'),),
      ),
    );
  }
}
