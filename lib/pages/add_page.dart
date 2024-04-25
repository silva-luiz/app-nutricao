import 'package:app_nutricao/_core/color_list.dart';
import 'package:app_nutricao/components/custom_button.dart';
import 'package:app_nutricao/components/squared_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AddPage extends StatelessWidget {
  const AddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding:  EdgeInsets.only(top: 10.0, bottom: 12.0),
            child: Text(
              "Escolha a opcao que deseja adicionar",
              style: TextStyle(fontSize: 20),
            ),
          ),
          SquaredButton(
            description: "Novo alimento",
            icon: Icons.fastfood_rounded,
            onClick: () {
              print("ok");
            },
          ),
          SquaredButton(
            description: "Novo cardapio",
            icon: Icons.restaurant_rounded,
            onClick: () {
              print("ok");
            },
          ),
        ],
      ),
    );
  }
}
