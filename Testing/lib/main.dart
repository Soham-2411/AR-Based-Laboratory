import 'package:arbasedlab/ARpage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'AR',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: ARModels());
  }
}
