import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app_flutter/widgets/categories_widget.dart';
import 'package:grocery_app_flutter/widgets/products/best_selling_product.dart';
import 'package:grocery_app_flutter/widgets/products/featured_products.dart';
import 'package:grocery_app_flutter/widgets/products/recently_added_products.dart';
import 'package:grocery_app_flutter/widgets/vendor_appbar.dart';
import 'package:grocery_app_flutter/widgets/vendor_banner.dart';
import 'package:provider/provider.dart';

import '../providers/store_provider.dart';
import '../widgets/image_slider.dart';

class VendorHomeScreeen extends StatelessWidget {
  static const String id = 'vendor_screen';
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            VendorAppBar(),
          ];
        },
        body: ListView(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
           VendorBanner(),
            VendorCategories(),
            RecentlyAddedProduct(),
            FeaturedProducts(),
            BestSellingProduct(),
          ],
        ),
      ),
    );
  }
}