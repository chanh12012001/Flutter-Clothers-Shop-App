import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:grocery_app_flutter/services/cart_services.dart';
import 'package:grocery_app_flutter/widgets/cart/counter_widget.dart';

class AddToCartWidget extends StatefulWidget {
  final DocumentSnapshot document;

  AddToCartWidget(this.document);

  @override
  _AddToCartWidgetState createState() => _AddToCartWidgetState();
}

class _AddToCartWidgetState extends State<AddToCartWidget> {
  CartServices _cart = CartServices();
  User user = FirebaseAuth.instance.currentUser;
  bool _loading = true;
  bool _exist = false;
  int _qty = 1;
  String _docId;

  @override
  void initState() {
    getCartData();
    super.initState();
  }

  getCartData() async {
    final snapshot =
    await _cart.cart.doc(user.uid).collection('products').get();
    if (snapshot.docs.length == 0) {
      setState(() {
        _loading = false;
      });
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //Nếu sản phẩm này tồn tại trong giỏ hàng, cần nhận được thông tin chi tiết
    FirebaseFirestore.instance
        .collection('cart')
        .doc(user.uid)
        .collection('products')
        .where('productId', isEqualTo: widget.document.data()['productId'])
        .get()
        .then((QuerySnapshot querySnapshot) => {
      querySnapshot.docs.forEach((doc) {
        if (doc['productId'] == widget.document.data()['productId']) {
        //Nghĩa là sản phẩm đã chọn đã tồn tại trong giỏ hàng, vì vậy không cần thêm lại vào giỏ hàng
          setState(() {
            _exist = true;
            _qty = doc['qty'];
            _docId = doc.id;
          });
        }
      }),
    });

    return _loading ? Container(
      height: 56,
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
        ),
      ),
    ) : _exist ? CounterWidget(
      document: widget.document,
      qty: _qty,
      docId: _docId,
    ) : InkWell(
      onTap: () {
        EasyLoading.show(status: 'Đang theemm vào giỏ hàng');
        _cart.addToCart(widget.document).then((value) {
          setState(() {
            _exist=true;
          });
          EasyLoading.showSuccess('Đã thêm vào giỏ hàng');
        });
      },
      child: Container(
        height: 56,
        color: Colors.red[400],
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.shopping_basket_outlined,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 10,
                ),
                Text('Thêm vào giỏ hàng',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}