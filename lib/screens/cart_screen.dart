import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:grocery_app_flutter/providers/auth_provider.dart';
import 'package:grocery_app_flutter/providers/cart_provider.dart';
import 'package:grocery_app_flutter/providers/coupon_provider.dart';
import 'package:grocery_app_flutter/providers/location_provider.dart';
import 'package:grocery_app_flutter/screens/profile_screen.dart';
import 'package:grocery_app_flutter/services/cart_services.dart';
import 'package:grocery_app_flutter/services/order_services.dart';
import 'package:grocery_app_flutter/services/store_services.dart';
import 'package:grocery_app_flutter/services/user_services.dart';
import 'package:grocery_app_flutter/widgets/cart/cart_list.dart';
import 'package:grocery_app_flutter/widgets/cart/cod_toggle.dart';
import 'package:grocery_app_flutter/widgets/cart/coupon_widget.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'map_screen.dart';
class CartScreen extends StatefulWidget {
  final DocumentSnapshot document;
  static const String id = 'cart_screen';
  CartScreen({this.document});
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  StoreServices _store = StoreServices();
  UserServices _userServices = UserServices();
  OrderServices _orderServices = OrderServices();
  CartServices _cartServices = CartServices();
  User user = FirebaseAuth.instance.currentUser;
  DocumentSnapshot doc;
  var textStyle = TextStyle(color: Colors.grey);
  int deliveryFee = 50;
  String _location = '';
  String _address = '';
  bool _loadng = false;
  bool _checkingUser = false;
  double discount = 0;



  @override
  void initState() {
    getPrefs();
    _store.getShopDetails(widget.document.data()['sellerUid']).then((value){
      setState(() {
        doc = value;
      });
    });
    super.initState();
  }

  getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String location = prefs.getString('location');
    String address = prefs.getString('address');
    setState(() {
      _location = location;
      _address = address;
    });
  }

  @override
  Widget build(BuildContext context) {
    var _cartProvider = Provider.of<CartProvider>(context);
    var _payable = _cartProvider.subTotal+deliveryFee-discount;
    final locationData = Provider.of<LocationProvider>(context);
    var userDetails = Provider.of<AuthProvider>(context);
    var _coupon = Provider.of<CouponProvider>(context);
    userDetails.getUserDetails().then((value){
      double subTotal = _cartProvider.subTotal;
      double discountRate = _coupon.discountRate/100;
      setState(() {
        discount = subTotal*discountRate;
      });
    });
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[200],
      bottomSheet: userDetails.snapshot == null ? Container() : Container(
        height: 170,
        color: Colors.blueGrey[900] ,
        child: Column(
          children: [
            Container(
              height: 110,
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text('Giao hàng đến địa chỉ này',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            setState(() {
                              _loadng = true;
                            });
                            locationData.getCurrentPosition().then((value){
                              setState(() {
                                _loadng = false;
                              });
                              if (value != null) {
                                pushNewScreenWithRouteSettings(
                                  context,
                                  settings: RouteSettings(name: MapScreen.id),
                                  screen: MapScreen(),
                                  withNavBar: false,
                                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                );
                              }else {
                                setState(() {
                                  _loadng = false;
                                });
                                print('Permission not allowed');
                              }
                            });
                          },
                          child: _loadng ? CircularProgressIndicator() : Text('Thay đổi',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      userDetails.snapshot.data()['firstName']!=null ? '${userDetails.snapshot
                          .data()['firstName']} ${userDetails.snapshot
                          .data()['firstName']} : $_location, $_address' : '$_location, $_address', maxLines: 3,
                      style: TextStyle(color: Colors.grey, fontSize: 12),),
                  ],
                ),
              ),
            ),
            Center(
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
                      child: _checkingUser ? CircularProgressIndicator() : Text('Thanh toán',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                        color: Colors.redAccent,
                        onPressed: (){
                        EasyLoading.show(status: 'Vui lòng đợi...');
                        _userServices.getUserById(user.uid).then((value){
                          if(value.data()['firstName'] == null){
                           EasyLoading.dismiss();
                            pushNewScreenWithRouteSettings(
                                context,
                                settings: RouteSettings(name: ProfileScreen.id),
                          screen:  ProfileScreen(),
                          pageTransitionAnimation: PageTransitionAnimation.cupertino,
                            );
                          }
                          else{
                            EasyLoading.show(status: 'Vui lòng đợi...');
                            //Todo: payment gateway intergation
                            _saveOrder(_cartProvider,_payable,_coupon);
                            EasyLoading.showSuccess('Đơn hàng của bạn đã được xác nhận');
                        }
                        });
                    }),
                  ],
                ),
              ),
            ),
          ],
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
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      Text('Tổng tiền: \$${_cartProvider.subTotal.toStringAsFixed(1)}',
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
        body: doc == null ? Center(child: CircularProgressIndicator()) : _cartProvider.cartQty > 0 ?  SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 80),
          child: Container(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      ListTile(
                        tileColor: Colors.white,
                        leading: Container(
                          height: 60,
                          width: 60,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                              child: Image.network(doc.data()['imageUrl'], fit: BoxFit.cover,)),
                        ),
                        title: Text(doc.data()['shopName']),
                        subtitle: Text(doc.data()['address'], maxLines: 1, style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),),
                      ),
                      CodToggleSwitch(),
                      Divider(color: Colors.grey[300],),
                    ],
                  ),
                ),
                CartList(document: widget.document,),
                //coupon
                CouponWidget(doc.data()['uid']),
                // bill and details
                Padding(
                  padding: const EdgeInsets.only(right: 4, left: 4, top: 4, bottom: 100),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text('Chi tiết hóa đơn',style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10,),
                            Row(
                              children: [
                                Expanded(child: Text('Tổng giá trị', style: textStyle,)),
                                Text('\$${_cartProvider.subTotal.toStringAsFixed(1)}',
                                  style: textStyle,
                                ),
                                ],
                            ),
                                SizedBox(
                                  height: 10,
                                ),
                                if(discount > 0)
                                Row(
                                  children: [
                                    Expanded(child: Text('Giảm giá', style: textStyle,)),
                                    Text('\$${discount.toStringAsFixed(1)}',
                                      style: textStyle,
                                    ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(child: Text('Phí vận chuyển', style: textStyle,)),
                                Text('\$$deliveryFee',
                                  style: textStyle,
                                ),
                              ],
                            ),
                            Divider(color: Colors.grey,),
                            Row(
                              children: [
                                Expanded(child: Text('Tổng chi phí', style: TextStyle(fontWeight: FontWeight.bold),)),
                                Text('\$${_payable.toStringAsFixed(1)}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                                SizedBox(height: 10,),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Theme.of(context).primaryColor.withOpacity(.3),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Expanded(child: Text('Giảm',style: TextStyle(color: Colors.green),)),
                                        Text('\$${_cartProvider.saving.toStringAsFixed(1)}',style: TextStyle(color: Colors.green),),
                                      ],
                                    ),
                                  ),
                                ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ) : Center(child: Text('Giỏ hàng trống. Tiếp tục mua sắm'),),
      ),
    );
  }

  _saveOrder(CartProvider cartProvider, payable, CouponProvider coupon){
    _orderServices.saveOrder({
      'products': cartProvider.cartList,
      'userId': user.uid,
      'deliveryFee' : deliveryFee,
      'total' : payable,
      'discount' : discount,
      'cod' : cartProvider.cod,
      'discountCode' : coupon.document==null ? null : coupon.document.data()['title'],
      'seller' : {
        'shopName' : widget.document.data()['shopName'],
        'sellerId' : widget.document.data()['sellerUId'],
      },
      'timetamp' : DateTime.now().toString(),
      'orderStatus' : 'Đã đặt hàng',
      'deliveryBoy' : {
        'name' : '',
        'phone' : '' ,
        'location' : '',
      },
    }).then((value){
      _cartServices.deleteCart().then((value){
        _cartServices.checkData().then((value){
          Navigator.pop(context);
        });
      });
    });
  }
}
