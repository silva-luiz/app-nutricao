import 'package:app_nutricao/_utils/utils.dart';
import 'package:app_nutricao/components/squared_button.dart';
import 'package:flutter/material.dart';

class AddPage extends StatelessWidget {
  const AddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 12.0),
            child: Text(
              "Escolha a opção que deseja adicionar",
              style: TextStyle(fontSize: 20),
            ),
          ),
          SquaredButton(
            description: "Novo alimento",
            icon: Icons.fastfood_rounded,
            onClick: () {
              changeRoute(context, '/new_food');
            },
          ),
          SquaredButton(
            description: "Novo cardápio",
            icon: Icons.restaurant_rounded,
            onClick: () {
              changeRoute(context, '/new_menu');
            },
          ),
        ],
      ),
    );
  }
}
