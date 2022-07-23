import 'package:flutter/material.dart';
import 'package:whats_sent/screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Send',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: Screen(),
    );
  }
}
