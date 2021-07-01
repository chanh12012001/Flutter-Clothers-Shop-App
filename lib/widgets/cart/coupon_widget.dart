import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:grocery_app_flutter/providers/coupon_provider.dart';
import 'package:provider/provider.dart';


class CouponWidget extends StatefulWidget {
  final String couponVendor;
  CouponWidget(this.couponVendor);
  @override
  _CouponWidgetState createState() => _CouponWidgetState();
}

class _CouponWidgetState extends State<CouponWidget> {

  Color color = Colors.grey;
  bool _enable = false;
  bool _visible = false;
  var _couponText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var _coupon = Provider.of<CouponProvider>(context);
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
            child: Row(
              children: [
                Expanded(child: SizedBox(
                  height: 38,
                  child: TextField(
                    controller: _couponText,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.grey[300],
                        hintText: 'Nhập vào mã giảm giá',
                        hintStyle: TextStyle(color: Colors.grey)
                    ),
                    onChanged: (String value){
                      if(value.length<3){
                        setState(() {
                            color = Colors.grey;
                            _enable = false;
                        });
                        if(value.isNotEmpty){
                          setState(() {
                            color = Theme.of(context).primaryColor;
                            _enable = true;
                          });
                        }
                      }
                    },
                  ),
                )),
                AbsorbPointer(
                  absorbing: _enable ? false : true ,
                  child: OutlineButton(
                      borderSide: BorderSide(color: color),
                      onPressed: (){
                        EasyLoading.show(status: 'Đang xác nhận...');
                        _coupon.getCouponDetails(_couponText.text, widget.couponVendor).then((value){
                          if(_coupon.document ==null){
                            setState(() {
                              _coupon.discountRate = 0;
                              _visible = false;
                            });
                            EasyLoading.dismiss();
                            showDialog(_couponText.text, 'không hợp lệ');
                            return;
                          }
                          if(_coupon.expired == false){
                            setState(() {
                              _visible = true;
                            });
                            EasyLoading.dismiss();
                            return;
                          }
                          if(_coupon.expired == true){
                            setState(() {
                              _coupon.discountRate = 0;
                              _visible = false;
                            });
                            EasyLoading.dismiss();
                            showDialog(_couponText.text, 'hợp lệ');
                          }
                        });
                      },
                      child: Text('Áp dụng',style: TextStyle(color: color),)
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: _visible,
            child: _coupon.document == null ? Container() : Padding(
              padding: const EdgeInsets.all(8.0),
              child: DottedBorder(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.deepOrangeAccent.withOpacity(.4),
                        ),
                        width: MediaQuery.of(context).size.width - 80,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 4,),
                              child: Text(_coupon.document.data()['title']),
                            ),
                            Divider(color: Colors.grey[800],),
                            Text(_coupon.document.data()['details']),
                            Text('Giảm ${_coupon.document.data()['discoutRate']}% tổng giá trị đơn hàng'),
                            SizedBox(height: 10,),
                          ],
                        ),
                      ),
                      Positioned(
                        right: -5.0,
                        top: -10.0,
                        child: IconButton(icon: Icon(Icons.clear_outlined),
                          onPressed: (){
                            setState(() {
                              _coupon.discountRate = 0;
                              _visible = false;
                              _couponText.clear();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  showDialog(code, validity){
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context){
        return CupertinoAlertDialog(
          title: Text('Áp dụng mã giảm giá'),
          content: Text('Mã khuyến mãi $code bạn đã điền vào $validity.'),
          actions: [
            FlatButton(
              child: Text('Ok',style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ],
        );
      }
    );
  }

}
