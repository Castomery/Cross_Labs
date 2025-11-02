import 'package:flutter/material.dart';

abstract class IListItem {
  String displayTitle();
  String displaySubtitle();
  IconData displayIcon();
}
