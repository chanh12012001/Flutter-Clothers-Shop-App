import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:grocery_app_flutter/constants.dart';
import 'package:grocery_app_flutter/screens/payment/create_new_card_screen.dart';
import 'package:grocery_app_flutter/services/payment/stripe_payment_service.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class CreditCardList extends StatelessWidget {
  static const String id = 'manage-cards';

  @override
  Widget build(BuildContext context) {
    StripeService _service = StripeService();

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              Icons.add_circle_rounded,
              color: kTextBlackColor,
            ),
            onPressed: () {
              pushNewScreenWithRouteSettings(
                context,
                settings: RouteSettings(name: CreateNewCreditCard.id),
                screen: CreateNewCreditCard(),
                withNavBar: true,
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            },
          )
        ],
        iconTheme: IconThemeData(color: kTextBlackColor),
        centerTitle: true,
        title: Text(
          'Quản lý thẻ tín dụng',
          style: TextStyle(color: kTextBlackColor),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _service.cards.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Đã xảy ra sự cố');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data.size == 0) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Không có thẻ tín dụng nào được thêm vào tài khoản của bạn'),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).primaryColor),
                    ),
                    child: Text(
                      'Thêm thẻ',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      pushNewScreenWithRouteSettings(
                        context,
                        settings: RouteSettings(name: CreateNewCreditCard.id),
                        screen: CreateNewCreditCard(),
                        withNavBar: true,
                        pageTransitionAnimation: PageTransitionAnimation.cupertino,
                      );
                    },
                  )
                ],
              ),
            );
          }
          return new Container(
            padding: EdgeInsets.only(left: 8, right: 8, top: 10, bottom: 10),
            child: ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (BuildContext context, int index) {
                var card = snapshot.data.docs[index];
                return Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  child: Container(
                    color: Colors.white,
                    child: CreditCardWidget(
                      cardNumber: card['cardNumber'],
                      expiryDate: card['expiryDate'],
                      cardHolderName: card['cardHolderName'],
                      cvvCode: card['cvvCode'],
                      showBackView: false,
                    ),
                  ),
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: 'Xóa',
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () {
                        EasyLoading.show(status: 'Vui lòng đợi...');
                        _service.deleteCreditCard(card.id).whenComplete(() {
                          EasyLoading.dismiss();
                        });
                      },
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}