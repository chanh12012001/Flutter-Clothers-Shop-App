import 'package:flutter/material.dart';

class Product {
  final String image;
  final String name;
  final int price;

  Product({
    @required this.image,
    @required this.name,
    @required this.price
  });
}