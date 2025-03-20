import 'package:flutter/material.dart';
import 'package:flutter_submission_1/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Simple Task Manager',
    theme: ThemeData.dark(),
    home: const Home(),
  );
}
