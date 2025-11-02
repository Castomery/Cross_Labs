import 'package:flutter/material.dart';
import 'package:lab1/IListItem.dart';

class User implements IListItem {
  final int id;
  final String name;
  final String email;
  final int age;

  User({required this.id, required this.name, required this.email, required this.age});

  @override
  String displayTitle() => name;

  @override
  String displaySubtitle() => "$email, age: $age";

  @override
  IconData displayIcon() => Icons.person;
}
