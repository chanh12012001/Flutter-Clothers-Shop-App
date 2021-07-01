import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app_flutter/providers/orders_provider.dart';
import 'package:grocery_app_flutter/services/order_services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  OrderServices _orderServices = OrderServices();
  User user = FirebaseAuth.instance.currentUser;

  int tag = 0;
  List<String> options = [
    'Tất cả đơn hàng', 'Đã đặt hàng' ,'Được xác nhận', 'Đang lấy hàng',
    'Đang vận chuyển', 'Đã giao hàng',
  ];
  @override
  Widget build(BuildContext context) {

    var _orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text('Đơn hàng của tôi',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(CupertinoIcons.search),
              onPressed: (){}
              ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: ChipsChoice<int>.single(
              choiceStyle: C2ChoiceStyle(
                borderRadius: BorderRadius.all(
                    Radius.circular(3)
                ),
              ),
              value: tag,
              onChanged: (val){
                if(val == 0){
                 setState(() {
                   _orderProvider.status = null;
                 });
                }
                setState((){
                  tag = val;
                  if(tag > 0){
                    _orderProvider.filterOrder(options[val]);
                  }
                });
              },
              choiceItems: C2Choice.listFrom<int, String>(
                source: options,
                value: (i, v) => i,
                label: (i, v) => v,
              ),
            ),
          ),
          Container(
            child:  StreamBuilder<QuerySnapshot>(
              stream: _orderServices.orders
                  .where('userId',isEqualTo: user.uid).where('orderStatus',isEqualTo: tag > 0 ? _orderProvider.status : null)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if(snapshot.data.size == 0){
                  return Center(
                    child: Text('Không có đơn hàng'),
                  );
                }

                return Expanded(
                  child: new ListView(
                    children: snapshot.data.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                      return new Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            ListTile(
                              horizontalTitleGap: 0,
                              leading: CircleAvatar(
                                radius: 15,
                                child: _orderServices.statusIcon(document),
                              ),
                              title: Text(
                                document.data()['orderStatus'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: _orderServices.statusColor(document),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                  'Vào ${DateFormat
                                      .yMMMd()
                                      .format(DateTime.parse(document.data()['timetamp']))}',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Loại thanh toán: ${document.data()['cod'] == true ? 'Thanh toán trực tiếp' : 'Thanh toán trực tuyến'}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text('Tổng tiền: \$${document.data()['total'].toStringAsFixed(1)}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if(document.data()['deliveryBoy']['name'].length > 2)
                            Padding(
                              padding: const EdgeInsets.only(left: 10,right: 10),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: ListTile(
                                  tileColor: Theme.of(context).primaryColor.withOpacity(.2),
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: document.data()['deliveryBoy']['image'] == null ? Container() :
                                    Image.network(document.data()['deliveryBoy']['image'],height: 24,
                                    ),
                                  ),
                                  title: Text(document.data()['deliveryBoy']['name']),
                                  subtitle: Text(_orderServices.statusComment(document)),
                                ),
                              ),
                            ),
                            ExpansionTile(
                                title: Text('Chi tiết đơn hàng',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.black,
                                  ),
                                ),
                              subtitle: Text('Xem chi tiết',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (BuildContext context, int index){
                                      return ListTile(
                                        leading: CircleAvatar(
                                          child: Image.network(document.data()['products'][index]['productImage']),
                                        ),
                                        title: Text(document.data()['products'][index]['productName'] , style: TextStyle(fontSize: 12),),
                                        subtitle:
                                        Text('${document
                                            .data()['products'][index]['qty']} x ${document
                                            .data()['products'][index]['price']
                                            .toStringAsFixed(1)} = ${document
                                            .data()['products'][index]['total']
                                            .toStringAsFixed(1)}',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ) ,
                                        ),
                                      );
                                    },
                                  itemCount: document.data()['products'].length,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 12,right: 12,top: 8,bottom: 8),
                                  child: Card(
                                    elevation: 4,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                  'Cửa hàng: ',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(document.data()['seller']['shopName'],style: TextStyle(color: Colors.grey),),
                                            ],
                                          ),
                                          SizedBox(height: 10,),
                                          if(document.data()['discount'] > 0)
                                          Container(
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Giảm giá: ',
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 12
                                                      ),
                                                    ),

                                                    Text(
                                                      '${document.data()['discount']}',
                                                      style: TextStyle(color: Colors.grey,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 10,),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Mã giảm giá: ',
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 12
                                                      ),
                                                    ),

                                                    Text(
                                                      '${document.data()['discountCode']}',
                                                      style: TextStyle(color: Colors.grey,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 10,),
                                          Row(
                                            children: [
                                              Text(
                                                'Phí giao hàng: ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12
                                                ),
                                              ),

                                              Text(
                                                '${document.data()['deliveryFee'].toString()}',
                                                style: TextStyle(color: Colors.grey,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              height: 3,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
