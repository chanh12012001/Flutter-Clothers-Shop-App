import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:grocery_app_flutter/constants.dart';
import 'package:grocery_app_flutter/providers/order_provider.dart';
import 'package:grocery_app_flutter/screens/payment/create_new_card_screen.dart';
import 'package:grocery_app_flutter/screens/payment/stripe/existing-cards.dart';
import 'package:grocery_app_flutter/services/payment/stripe_payment_service.dart';
import 'package:provider/provider.dart';

class PaymentHome extends StatefulWidget {
  static const String id = 'stripe-honme';

  PaymentHome({Key key}) : super(key: key);

  @override
  PaymentHomeState createState() => PaymentHomeState();
}

class PaymentHomeState extends State<PaymentHome> {
  onItemPress(BuildContext context, int index, amount, orderProvider) async {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, CreateNewCreditCard.id);
        break;
      case 1:
        payViaNewCard(context, amount, orderProvider);
        break;
      case 2:
        Navigator.pushNamed(context, ExistingCardsPage.id);
        break;
    }
  }

  payViaNewCard(
      BuildContext context, amount, OrderProvider orderProvider) async {
    await EasyLoading.show(status: 'Vui lòng đợi...');
    var response = await StripeService.payWithNewCard(
        amount: '${amount}00', currency: 'USD');
    if (response.success == true) {
      orderProvider.success = true;
    }
    await EasyLoading.dismiss();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
          content: Text(response.message),
          duration: new Duration(
              milliseconds: response.success == true ? 1200 : 3000),
        ))
        .closed
        .then((_) {
      Navigator.pop(context);
    });
  }

  @override
  void initState() {
    super.initState();
    StripeService.init();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thanh toán',
          style: TextStyle(color: kTextBlackColor),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: kTextBlackColor),
      ),
      body: Column(
        children: [
          Material(
            elevation: 4,
            child: SizedBox(
                height: 56,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40, top: 10),
                  child: Image.network(
                    'https://stripe.com/img/v3/newsroom/social.png',
                    fit: BoxFit.fitWidth,
                  ),
                )),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  Icon icon;
                  Text text;

                  switch (index) {
                    case 0:
                      icon = Icon(Icons.add_circle, color: theme.primaryColor);
                      text = Text('Thêm thẻ');
                      //TODO : add new cards to firestore
                      break;
                    case 1:
                      icon = Icon(Icons.payment_outlined,
                          color: theme.primaryColor);
                      text = Text('Thanh toán qua thẻ mới');
                      break;
                    case 2:
                      icon = Icon(Icons.credit_card, color: theme.primaryColor);
                      text = Text('Thanh toán qua thẻ hiện có ');
                      break;
                  }

                  return InkWell(
                    onTap: () {
                      onItemPress(
                        context,
                        index,
                        orderProvider.amount,
                        orderProvider,
                      );
                    },
                    child: ListTile(
                      title: text,
                      leading: icon,
                    ),
                  );
                },
                separatorBuilder: (context, index) => Divider(color: theme.primaryColor,),
                itemCount: 3),
          ),
        ],
      ),
    );
  }
}