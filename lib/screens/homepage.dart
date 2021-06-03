import 'dart:math';

import 'package:flutter_shop_app_final/model/categoryicon.dart';
import 'package:flutter_shop_app_final/model/usermodel.dart';
import 'package:flutter_shop_app_final/screens/about.dart';
import 'package:flutter_shop_app_final/screens/checkout.dart';
import 'package:flutter_shop_app_final/screens/contactus.dart';
import 'package:flutter_shop_app_final/screens/detailscreen.dart';
import 'package:flutter_shop_app_final/screens/list_product.dart';
import 'package:flutter_shop_app_final/screens/profilescreen.dart';
import 'package:flutter_shop_app_final/widgets/singeproduct.dart';

import '../provider/product_provider.dart';
import '../provider/category_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:provider/provider.dart';
import '../model/product.dart';
import '../widgets/notification_button.dart';
import 'login.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

CategoryProvider categoryProvider;
ProductProvider productProvider;

class _HomePageState extends State<HomePage> {
  Widget _buildCategoryProduct({String image, int color}) {
    return CircleAvatar(
      maxRadius: height * 0.1 / 2.1,
      backgroundColor: Color(color),
      child: Container(
        height: 40,
        child: Image(
          color: Colors.white,
          image: NetworkImage(image),
        ),
      ),
    );
  }

  double height, width;
  bool homeColor = true;
  bool checkoutColor = false;
  bool aboutColor = false;
  bool contactUsColor = false;
  bool profileColor = false;

  MediaQueryData mediaQuery;

  Widget _buildUserAccountsDrawerHeader() {
    List<UserModel> userModel = productProvider.userModelList;
    return Column(
        children: userModel.map((e) {
          return UserAccountsDrawerHeader(
            accountName: Text(
              e.userName,
              style: TextStyle(color: Colors.black),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: e.userImage == null
                  ? AssetImage("assets/images/userImage.png")
                  : NetworkImage(e.userImage),
            ),
            decoration: BoxDecoration(color: Color(0xfff2f2f2)),
            accountEmail: Text(e.userEmail, style: TextStyle(color: Colors.black)),
          );
        }).toList());
  }

  Widget _buildMyDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          _buildUserAccountsDrawerHeader(),
          ListTile(
            selected: homeColor,
            onTap: () {
              setState(() {
                homeColor = true;
                contactUsColor = false;
                checkoutColor = false;
                aboutColor = false;
                profileColor = false;
              });
            },
            leading: Icon(Icons.home),
            title: Text("Home"),
          ),
          ListTile(
            selected: checkoutColor,
            onTap: () {
              setState(() {
                checkoutColor = true;
                contactUsColor = false;
                homeColor = false;
                profileColor = false;
                aboutColor = false;
              });
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (ctx) => CheckOut()));
            },
            leading: Icon(Icons.shopping_cart),
            title: Text("Giỏ hàng"),
          ),
          ListTile(
            selected: aboutColor,
            onTap: () {
              setState(() {
                aboutColor = true;
                contactUsColor = false;
                homeColor = false;
                profileColor = false;
                checkoutColor = false;
              });
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (ctx) => About()));
            },
            leading: Icon(Icons.info),
            title: Text("Thông tin"),
          ),
          ListTile(
            selected: profileColor,
            onTap: () {
              setState(() {
                aboutColor = false;
                contactUsColor = false;
                homeColor = false;
                profileColor = true;
                checkoutColor = false;
              });
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (ctx) => ProfileScreen(),
                ),
              );
            },
            leading: Icon(Icons.info),
            title: Text("Profile"),
          ),
          ListTile(
            selected: contactUsColor,
            onTap: () {
              setState(() {
                contactUsColor = true;
                checkoutColor = false;
                profileColor = false;
                homeColor = false;
                aboutColor = false;
              });
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (ctx) => ContactUs()));
            },
            leading: Icon(Icons.phone),
            title: Text("Liên hệ chúng tôi"),
          ),
          ListTile(
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (ctx) => Login()));
            },
            leading: Icon(Icons.exit_to_app),
            title: Text("Đăng xuất"),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSlider() {
    return Container(
      height: height * 0.26,
      child: Carousel(
        autoplay: true,
        showIndicator: false,
        images: [
          AssetImage("assets/images/banner1.jpg"),
          AssetImage("assets/images/banner2.jpg"),
          AssetImage("assets/images/banner1.jpg"),
        ],
      ),
    );
  }

  Widget _buildWomenFashionIcon() {
    List<CategoryIcon> womenFashionIcon = categoryProvider.getWomensFashionIcon;
    List<Product> womenFashion = categoryProvider.getWomensFashionList;
    return Row(
        children: womenFashionIcon.map((e) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => ListProduct(
                    name: "Thời trang nữ",
                    snapShot: womenFashion,
                  ),
                ),
              );
            },
            child: _buildCategoryProduct(image: e.image, color: 0xff33dcfd),
          );
        }).toList());
  }

  Widget _buildMenFashionIcon() {
    List<Product> mensFashion = categoryProvider.getMensFashionList;
    List<CategoryIcon> mensFashionIcon = categoryProvider.getMensFashionIcon;
    return Row(
        children: mensFashionIcon.map((e) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => ListProduct(
                    name: "Thời trang nam",
                    snapShot: mensFashion,
                  ),
                ),
              );
            },
            child: _buildCategoryProduct(image: e.image, color: 0xfff38cdd),
          );
        }).toList());
  }

  Widget _buildShoeIcon() {
    List<CategoryIcon> shoeIcon = categoryProvider.getShoeIcon;
    List<Product> shoes = categoryProvider.getshoesList;
    return Row(
        children: shoeIcon.map((e) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => ListProduct(
                    name: "Giày, dép",
                    snapShot: shoes,
                  ),
                ),
              );
            },
            child: _buildCategoryProduct(
              image: e.image,
              color: 0xff4ff2af,
            ),
          );
        }).toList());
  }

  Widget _buildJewelryIcon() {
    List<CategoryIcon> jewelryIcon = categoryProvider.getJewelryIcon;
    List<Product> jewelry = categoryProvider.getJewelryList;
    return Row(
        children: jewelryIcon.map((e) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => ListProduct(
                    name: "Trang sức",
                    snapShot: jewelry,
                  ),
                ),
              );
            },
            child: _buildCategoryProduct(
              image: e.image,
              color: 0xff74acf7,
            ),
          );
        }).toList());
  }

  Widget _buildCosmeticsIcon() {
    List<CategoryIcon> cosmeticsIcon = categoryProvider.getCosmeticsIcon;
    List<Product> cosmetics = categoryProvider.getJewelryList;
    return Row(
        children: cosmeticsIcon.map((e) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => ListProduct(
                    name: "Mỹ phẩm",
                    snapShot: cosmetics,
                  ),
                ),
              );
            },
            child: _buildCategoryProduct(
              image: e.image,
              color: 0xfffc6c8d,
            ),
          );
        }).toList());
  }

  Widget _buildCategory() {
    return Column(
      children: <Widget>[
        Container(
          height: height * 0.1 - 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Danh mục",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Container(
          height: 60,
          width: double.infinity,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              _buildMenFashionIcon(),
              _buildWomenFashionIcon(),
              _buildShoeIcon(),
              _buildJewelryIcon(),
              _buildCosmeticsIcon(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeature() {
    List<Product> featureProduct;

    featureProduct = productProvider.getFeatureList;

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Nổi bật",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (ctx) => ListProduct(
                      name: "Featured",
                      isCategory: false,
                      snapShot: featureProduct,
                    ),
                  ),
                );
              },
              child: Text(
                "Xem thêm",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        Row(
          children: productProvider.getHomeFeatureList.map((e) {
            return Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (ctx) => DetailScreen(
                              image: e.image,
                              price: e.price,
                              name: e.name,
                            ),
                          ),
                        );
                      },
                      child: SingleProduct(
                        image: e.image,
                        price: e.price,
                        name: e.name,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (ctx) => DetailScreen(
                              image: e.image, price: e.price, name: e.name),
                        ),
                      );
                    },
                    child: SingleProduct(
                      image: e.image,
                      price: e.price,
                      name: e.name,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildNewAchives() {
    List<Product> newAchivesProduct = productProvider.getNewAchiesList;
    return Column(
      children: <Widget>[
        Container(
          height: height * 0.1 - 30,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Sản phẩm mới",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (ctx) => ListProduct(
                            name: "Sản phẩm mới",
                            isCategory: false,
                            snapShot: newAchivesProduct,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "Xem thêm",
                      style:
                      TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        Row(
            children: productProvider.getHomeAchiveList.map((e) {
              return Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (ctx) => DetailScreen(
                                          image: e.image,
                                          price: e.price,
                                          name: e.name,
                                        ),
                                      ),
                                    );
                                  },
                                  child: SingleProduct(
                                      image: e.image, price: e.price, name: e.name),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (ctx) => DetailScreen(
                                        image: e.image,
                                        price: e.price,
                                        name: e.name,
                                      ),
                                    ),
                                  );
                                },
                                child: SingleProduct(
                                    image: e.image, price: e.price, name: e.name),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              );
            }).toList()),
      ],
    );
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  void getCallAllFunction() {
    categoryProvider.getMensFashionData();
    categoryProvider.getWomensFashionData();
    categoryProvider.getShoesData();
    categoryProvider.getJewelryData();
    categoryProvider.getCosmeticsData();

    categoryProvider.getMensFashionIconData();
    categoryProvider.getWomensFashionIconData();
    categoryProvider.getshoesIconData();
    categoryProvider.getJewelryIconData();
    categoryProvider.getCosmmeticsIconData();

    productProvider.getNewAchiveData();
    productProvider.getFeatureData();
    productProvider.getHomeFeatureData();
    productProvider.getHomeAchiveData();
    productProvider.getUserData();
  }

  @override
  Widget build(BuildContext context) {
    categoryProvider = Provider.of<CategoryProvider>(context);
    productProvider = Provider.of<ProductProvider>(context);
    getCallAllFunction();
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _key,
      drawer: _buildMyDrawer(),
      appBar: AppBar(
        title: Text(
          "Trang chủ",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.grey[100],
        leading: IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.black,
            ),
            onPressed: () {
              _key.currentState.openDrawer();
            }),
        actions: <Widget>[
          NotificationButton(),
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: <Widget>[
            Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildImageSlider(),
                  _buildCategory(),
                  SizedBox(
                    height: 20,
                  ),
                  _buildFeature(),
                  _buildNewAchives()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
