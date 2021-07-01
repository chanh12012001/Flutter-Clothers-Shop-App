

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderServices{
  CollectionReference orders = FirebaseFirestore.instance.collection('orders');

  Future<DocumentReference>saveOrder(Map<String,dynamic>data){
   var result =  orders.add(
      data
    );
   return result;
  }

  Color statusColor(document){
    if(document.data()['orderStatus'] == 'Từ chối'){
      return Colors.red;
    }
    if(document.data()['orderStatus'] == 'Được xác nhận'){
      return Colors.blueGrey[400];
    }
    if(document.data()['orderStatus'] == 'Đang lấy hàng'){
      return Colors.pink[900];
    }
    if(document.data()['orderStatus'] == 'Đang vận chuyển'){
      return Colors.deepPurpleAccent;
    }
    if(document.data()['orderStatus'] == 'Đã giao hàng'){
      return Colors.green;
    }
    return Colors.orange;
  }

  Icon statusIcon(document){
    if(document.data()['orderStatus'] == 'Được xác nhận'){
      return Icon(Icons.assignment_turned_in_outlined, color: statusColor(document),);
    }
    if(document.data()['orderStatus'] == 'Đang lấy hàng'){
      return Icon(Icons.cases, color: statusColor(document),);
    }
    if(document.data()['orderStatus'] == 'Đang vận chuyển'){
      return Icon(Icons.local_shipping, color: statusColor(document),);
    }
    if(document.data()['orderStatus'] == 'Đã giao hàng'){
      return Icon(Icons.all_inbox, color: statusColor(document),);
    }
    return Icon(Icons.assignment_turned_in_outlined, color: statusColor(document),);
  }

  String statusComment(document){
    if(document.data()['orderStatus'] == 'Được lấy hàng'){
      return 'Đơn hàng của bạn đã được lấy hàng bởi ${document
          .data()['deliveryBoy']['name']}';
    }
    if(document.data()['orderStatus'] == 'Đang vận chuyển'){
      return 'Đơn hàng của bạn đã được vận chuyển bởi ${document
          .data()['deliveryBoy']['name']}';
    }
    if(document.data()['orderStatus'] == 'Đã giao hàng'){
      return 'Đơn hàng của bạn đã được giao' ;
    }
    return 'Đơn hàng của bạn đã được xác nhận bởi ${document
        .data()['seller']['shopName']}';
  }
}