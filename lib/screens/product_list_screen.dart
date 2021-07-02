import 'package:flutter/material.dart';
import 'package:grocery_app_flutter/constants.dart';
import 'package:grocery_app_flutter/providers/store_provider.dart';
import 'package:grocery_app_flutter/widgets/products/product_filter_widget.dart';
import 'package:grocery_app_flutter/widgets/products/product_list.dart';
import 'package:provider/provider.dart';

class ProductListScreen extends StatelessWidget {
  static const String id = 'product-list-screen';

  @override
  Widget build(BuildContext context) {
    var  _storeProvider = Provider.of<StoreProvider>(context);
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
                floating: true,
                snap: true,
                title: Text(
                  _storeProvider.selectedProductCategory,
                  style: TextStyle(color: kTextBlackColor),
                ),
                iconTheme: IconThemeData(color: kTextBlackColor
                ),
                expandedHeight: 110,
                flexibleSpace: Padding(
                  padding: EdgeInsets.only(top: 88),
                  child: Container(
                    height: 56,
                    color: Colors.grey,
                    child: ProductFilterWidget(),
                  ),
                )
            ),
          ];
        },
        body: ListView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          children: [
            ProductListWidget(),
          ],
        ),
      ),
    );
  }
}
