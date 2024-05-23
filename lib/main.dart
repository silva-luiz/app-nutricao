import 'package:app_nutricao/_core/color_list.dart';
import 'package:app_nutricao/pages/home.dart';
import 'package:app_nutricao/pages/index.dart';
import 'package:app_nutricao/routes/routes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App nutrição',
      //initialRoute: '/login',
      routes: AppRoutes.loadRoutes(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
        useMaterial3: true,
      ),
      home: const Index(),
    );
  }
}
