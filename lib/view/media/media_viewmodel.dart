import 'package:flutter/material.dart';

class MediaViewModel extends ChangeNotifier {
  final List<Map<String, String>> mediaCategories = [
    {
      'title': '1st Month',
      'image': 'assets/images/first_month.png',
    },
    {
      'title': 'For Women',
      'image': 'assets/images/for_woman.png',
    },
    {
      'title': 'Kids',
      'image': 'assets/images/for_kids.png',
    },
  ];
}
