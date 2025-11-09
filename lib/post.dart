import 'package:flutter/material.dart';
import 'package:lab1/IListItem.dart';

class Post implements IListItem {
  final String title;
  final String body;
  final List<String> tags;
  final int likes;
  final int dislikes;
  final int views;

  Post({
    required this.title,
    required this.body,
    required this.tags,
    required this.likes,
    required this.dislikes,
    required this.views,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      title: json['title'],
      body: json['body'],
      tags: List<String>.from(json['tags']),
      likes: json['reactions']['likes'],
      dislikes: json['reactions']['dislikes'],
      views: json['views'],
    );
  }
}
