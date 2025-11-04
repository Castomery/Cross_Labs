import 'package:flutter/material.dart';
import 'package:lab1/IListItem.dart';

class User implements IListItem {
  final int id;
  final String name;
  final int age;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.age,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['firstName'],
      age: json['age'],
      email: json['email'],
    );
  }
}
