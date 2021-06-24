import 'package:cloud_firestore/cloud_firestore.dart';

class StoreServices{
  getTopPickedStore() {
    return FirebaseFirestore.instance.collection('vendors').where(
        'accVerified', isEqualTo: true).where('isTopPicked', isEqualTo: true).where('shopOpen', isEqualTo: true).orderBy('shopName').snapshots();
  }

  getNearByStore() {
    return FirebaseFirestore.instance.collection('vendors').where(
        'accVerified', isEqualTo: true).orderBy('shopName').snapshots();
  }

  getNearByStorePagination() {
    return FirebaseFirestore.instance.collection('vendors').where(
        'accVerified', isEqualTo: true).orderBy('shopName');
  }
}