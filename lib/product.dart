import 'package:flutter/material.dart';
import 'package:lab1/IListItem.dart';

class Product implements IListItem {
  final int id;
  final String name;
  final double price;

  Product({
    required this.id,
    required this.name,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['title'],
      price: (json['price'] as num).toDouble(),
    );
  }
}
