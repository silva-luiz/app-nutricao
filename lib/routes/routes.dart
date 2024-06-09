import 'package:app_nutricao/pages/login.dart';
import 'package:app_nutricao/pages/new_food.dart';
import 'package:app_nutricao/pages/new_menu.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static Map<String, Widget Function(BuildContext)> loadRoutes() {
    return {
      '/login': (context) => const LoginPage(),
      '/new_food': (context) => const NewFoodPage(),
      '/new_menu': (context) => NewMenuPage(),
    };
  }

  static void Function() call(BuildContext context, String rota) {
    return () {
      Navigator.pushNamed(context, rota);
    };
  }
}
