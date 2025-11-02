import 'package:lab1/IListItem.dart';
import './product.dart';
import './user.dart';

final List<IListItem> items = [
  Product(id: 1, name: "Notebook", price: 35000),
  User(id: 1, name: "Alice", email: "alice@example.com", age: 25),
  Product(id: 2, name: "Mouse", price: 900),
  User(id: 2, name: "Bob", email: "bob@example.com", age: 30),
];
