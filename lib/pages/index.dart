import 'package:app_nutricao/_core/color_list.dart';
import 'package:app_nutricao/pages/add_page.dart';
import 'package:app_nutricao/pages/creditos.dart';
import 'package:app_nutricao/pages/initial_home.dart';
import 'package:flutter/material.dart';

class Index extends StatefulWidget {
  const Index({super.key});

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
   InitialHomePage(),
    SearchPage(),
    AddPage(),
    CreditsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ola, bem-vindo!',
          style: TextStyle(color: AppColors.textLight),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.logout_outlined,
                color: AppColors.textLight,
              ),
            ),
          ),
        ],
        backgroundColor: AppColors.primaryColor,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Inicio',
            backgroundColor: AppColors.textLight,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Buscar',
            backgroundColor: AppColors.textLight,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Adicionar',
            backgroundColor: AppColors.textLight,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Créditos',
            backgroundColor: AppColors.textLight,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primaryColor,
        unselectedIconTheme: IconThemeData(color: AppColors.textGrey),
        selectedIconTheme: IconThemeData(color: AppColors.primaryColor),
        showSelectedLabels: false,
        onTap: _onItemTapped,
      ),
    );
  }
}
