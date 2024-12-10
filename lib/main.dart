import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:revisao_mobile/screens/home_screen.dart';

import 'controller_binding.dart';

void main() {
  ControllerBinding().dependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Revisão Sistemas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}

