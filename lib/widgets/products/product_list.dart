import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app_flutter/providers/store_provider.dart';
import 'package:grocery_app_flutter/services/product_services.dart';
import 'package:grocery_app_flutter/widgets/products/product_card_widget.dart';
import 'package:grocery_app_flutter/widgets/products/product_filter_widget.dart';
import 'package:provider/provider.dart';
class ProductListWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    ProductServices _services = ProductServices();

    var _store = Provider.of<StoreProvider>(context);
    return  FutureBuilder<QuerySnapshot>(
      future: _services.products.where('published',isEqualTo: true).where('category.mainCategory',isEqualTo: _store.SelectedProductCategory).where('category.subCategory',isEqualTo: _store.SelectedSubCategory ).where('seller.sellerUid',isEqualTo: _store.storedetails['uid']).limit(10).get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Có lỗi xảy ra');
        }

        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator(),);
        }
        if(snapshot.data.docs.isEmpty)
        {
          return Container();
        }

        return Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.grey[300],
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10,),
                    child: Text('Có ${snapshot.data.docs.length} sản phẩm',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                        color: Colors.grey[600]
                      ),
                    ),
                  ),
                ],
              ),
            ),
            new ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: snapshot.data.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                return new ProductCard(document);
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
