import 'package:flutter/material.dart';
import 'package:grocery_app_flutter/providers/store_provider.dart';
import 'package:grocery_app_flutter/widgets/products/product_list.dart';
import 'package:grocery_app_flutter/widgets/vendor_appbar.dart';
import 'package:provider/provider.dart';

class ProductListScreen extends StatelessWidget {
static const String id = 'product-list-screen';
  @override
  Widget build(BuildContext context) {
    var _storeProvider = Provider.of<StoreProvider>(context);
    return Scaffold(
          body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return [
               SliverAppBar(
                 title: Text(
                   _storeProvider.SelectedProductCategory,
                   style: TextStyle(color: Colors.white
                   ),
                 ),
                 iconTheme: IconThemeData(
                   color: Colors.white
                 ),
               ),
              ];
            },
            body: ListView(
              padding: EdgeInsets.zero ,
              shrinkWrap: true,
              children: [
                ProductListWidget(),
              ],
            ),
          ),
    );
  }
}
