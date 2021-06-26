import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app_flutter/providers/store_provider.dart';
import 'package:grocery_app_flutter/services/product_services.dart';
import 'package:provider/provider.dart';

class ProductFilterWidget extends StatefulWidget {
  @override
  _ProductFilterWidgetState createState() => _ProductFilterWidgetState();
}

class _ProductFilterWidgetState extends State<ProductFilterWidget> {

  List _subCatList = [];
  ProductServices _services = ProductServices();

  @override
  void didChangeDependencies() {
    var _store = Provider.of<StoreProvider>(context);

    FirebaseFirestore.instance
        .collection('products').where('category.mainCategory',isEqualTo: _store.SelectedProductCategory)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
       setState(() {
         _subCatList.add(doc['category']['subCategory']);
       });
      });
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    var _storeData = Provider.of<StoreProvider>(context);

    return FutureBuilder<DocumentSnapshot>(
      future: _services.category.doc(_storeData.SelectedProductCategory).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Có lỗi xảy ra");
        }
        if(!snapshot.hasData)
          {
            return Container();
          }
          Map<String, dynamic> data = snapshot.data.data() as Map<String, dynamic>;
          return Container(
            height: 50,
            color: Colors.grey,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                SizedBox(width: 10,),
                ActionChip(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  elevation: 4,
                    label: Text('Bao gồm ${_storeData.SelectedProductCategory}'),
                    onPressed: (){
                      _storeData.selectedCategorySub(null);
                },
                  backgroundColor: Colors.white,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data.data().length.bitLength,
                  physics: ScrollPhysics(),
                  itemBuilder: (BuildContext context, int num){
                    return Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child:
                          _subCatList.contains(data['subCat'][num]['name'])?
                      ActionChip(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        elevation: 4,
                        label: Text(data['subCat'][num]['name']),
                        onPressed: (){
                          _storeData.selectedCategorySub(data['subCat'][num]['name']);
                        },
                        backgroundColor: Colors.white,
                      ) : Container(),
                    );
                  },
                ),
              ],
            ),
          );
      },
    );
  }
}
