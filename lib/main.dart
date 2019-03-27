import 'package:flutter/material.dart';
import 'package:pango_lite/pages/main_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pango Lite',
      home: MainPage(),
    );
  }

}