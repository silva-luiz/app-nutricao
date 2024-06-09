import 'package:app_nutricao/pages/add_page.dart';
import 'package:app_nutricao/pages/index.dart';
import 'package:app_nutricao/pages/login.dart';
import 'package:app_nutricao/pages/initial_home.dart';
import 'package:app_nutricao/pages/new_food.dart';
import 'package:app_nutricao/pages/new_menu.dart';
import 'package:app_nutricao/pages/search.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static Map<String, Widget Function(BuildContext)> loadRoutes() {
    return {
      '/home': (context) => const Index(),
      '/login': (context) => const LoginPage(),
      '/initial_home': (context) => const InitialHomePage(),
      '/add_page': (context) => const AddPage(),
      '/new_food': (context) => const NewFoodPage(),
      '/new_menu': (context) => NewMenuPage(),
      '/search': (context) => const SearchPage(),
    };
  }

  static void Function() call(BuildContext context, String rota) {
    return () {
      Navigator.pushNamed(context, rota);
    };
  }
}
