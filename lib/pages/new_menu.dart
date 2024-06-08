import 'package:app_nutricao/_core/color_list.dart';
import 'package:app_nutricao/_core/input_style.dart';
import 'package:flutter/material.dart';

class NewMenuPage extends StatefulWidget {
  const NewMenuPage({super.key});

  @override
  State<NewMenuPage> createState() => _NewMenuPageState();
}

class _NewMenuPageState extends State<NewMenuPage> {
  final List<String> breakfastList = [
    'maçã',
    'café',
    'pãozinho',
    'bisnaguinha'
  ];
  final List<String> lunchList = ['arroz', 'feijão', 'suquinho'];
  final List<String> dinnerList = ['arroz', 'feijão', 'saladinha', 'coquinha'];

  final _formkey = GlobalKey<FormState>();
  final TextEditingController _menuController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Novo cardápio',
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
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    width: 350,
                    child: TextFormField(
                      controller: _menuController,
                      decoration: textInputDecoration("Nome do cardápio"),
                    ),
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Title(
                        color: AppColors.primaryColor,
                        child: const Text(
                          "Café da Manhã",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                      Container(
                        height: 800,
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(breakfastList[index]),
                            );
                          },
                          itemCount: breakfastList.length,
                        ),
                      ),
                    ],
                  ),
                ),
                MealList(label: "Jantinha", mealList: dinnerList),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MealList extends StatelessWidget {
  final String label;
  final List mealList;

  const MealList({
    super.key,
    required this.label,
    required this.mealList,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Title(
            color: AppColors.primaryColor,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryColor,
              ),
            ),
          ),
          Container(
            height: 500,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(mealList[index]),
                );
              },
              itemCount: mealList.length,
            ),
          ),
        ],
      ),
    );
  }
}
