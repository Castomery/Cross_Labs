import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lab1/IListItem.dart';
import '../post.dart';
import '../user.dart';

class ApiService {

  static Future<List<IListItem>> loadData() async {
    final postRes = await http.get(
      Uri.parse('https://dummyjson.com/posts?limit=10'),
    );

    final userRes = await http.get(
      Uri.parse('https://dummyjson.com/users?limit=10'),
    );

    final postData = jsonDecode(postRes.body);
    final userData = jsonDecode(userRes.body);

    List<Post> posts = (postData['posts'] as List)
        .map((p) => Post.fromJson(p))
        .toList();

    List<User> users = (userData['users'] as List)
        .map((u) => User.fromJson(u))
        .toList();

    final combined = [...posts, ...users];

    combined.shuffle();

    return combined;
  }
}
