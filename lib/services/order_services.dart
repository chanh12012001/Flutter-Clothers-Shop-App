import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderServices{
  CollectionReference orders = FirebaseFirestore.instance.collection('orders');

  Future<DocumentReference>saveOrder(Map<String,dynamic>data){
    var result = orders.add(
      data
    );
    return result;
  }

  Color statusColor(document) {
    if (document.data()['orderStatus'] == 'Đã từ chối') {
      return Colors.red;
    }
    if (document.data()['orderStatus'] == 'Đã chấp nhận') {
      return Colors.blueGrey[400];
    }
    if (document.data()['orderStatus'] == 'Đang lấy hàng') {
      return Colors.pink[900];
    }
    if (document.data()['orderStatus'] == 'Đang giao hàng') {
      return Colors.deepPurpleAccent;
    }
    if (document.data()['orderStatus'] == 'Đã giao hàng') {
      return Colors.green;
    }
    return Colors.orange;
  }

  Icon statusIcon(document) {

    if (document.data()['orderStatus'] == 'Đã chấp nhận') {
      return Icon(Icons.assignment_turned_in_outlined, color: statusColor(document),);
    }
    if (document.data()['orderStatus'] == 'Đang lấy hàng') {
      return Icon(Icons.cases,color: statusColor(document),);

    }
    if (document.data()['orderStatus'] == 'Đang giao hàng') {
      return Icon(Icons.delivery_dining,color: statusColor(document),);

    }
    if (document.data()['orderStatus'] == 'Đã giao hàng') {
      return Icon(Icons.shopping_bag_outlined,color: statusColor(document),);
    }
    return Icon(Icons.assignment_turned_in_outlined,color: statusColor(document),);
  }

  String statusComment(document){
    if(document.data()['orderStatus']=='Đang lấy hàng'){
      return 'Đơn hàng của bạn được chọn bởi ${document.data()['deliveryBoy']['name']}';
    }
    if(document.data()['orderStatus']=='On the way'){
      return 'Người giao hàng của bạn  ${document.data()['deliveryBoy']['name']} đang di chuyển';
    }
    if(document.data()['orderStatus']=='Delivered'){
      return 'Đơn hàng của bạn đã hoàn thành ';
    }
    return 'Ông/bà.${document.data()['deliveryBoy']['name']} giao hàng thành công';
  }
}