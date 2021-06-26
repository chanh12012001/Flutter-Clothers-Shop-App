import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app_flutter/providers/store_provider.dart';
import 'package:grocery_app_flutter/services/product_services.dart';
import 'package:grocery_app_flutter/widgets/products/product_card_widget.dart';
import 'package:provider/provider.dart';
class RecentlyAddedProduct extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    ProductServices _services = ProductServices();
    var _store = Provider.of<StoreProvider>(context);
    return  FutureBuilder<QuerySnapshot>(
      future: _services.products.where('published',isEqualTo: true).where('collection',isEqualTo: 'Được thêm gần đây').where('seller.sellerUid',isEqualTo: _store.storedetails['uid']).limit(10).get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Có lỗi xảy ra');
        }

        if (!snapshot.hasData) {
          return Container();
        }
        if(snapshot.data.docs.isEmpty)
        {
          return Container();
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.teal[100],
                  ),
                  child: Text('Được thêm gần đây',
                    style: TextStyle(
                        shadows: <Shadow>[
                          Shadow(
                              offset: Offset(2.0,2.0),
                              blurRadius: 3.0,
                              color: Colors.black
                          )
                        ],
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30
                    ),
                  ),
                ),
              ),
            ),
            new ListView(
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
