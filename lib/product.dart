import 'package:flutter/material.dart';
import 'package:lab1/IListItem.dart';

class Product implements IListItem {
  final int id;
  final String name;
  final double price;

  Product({required this.id, required this.name, required this.price});

  @override
  String displayTitle() => name;

  @override
  String displaySubtitle() => "Price: $price ₴";

  @override
  IconData displayIcon() => Icons.shopping_cart;
}