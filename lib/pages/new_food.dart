import 'package:app_nutricao/components/custom_button.dart';
import 'package:flutter/material.dart';

import '../_core/color_list.dart';
import '../_core/input_style.dart';
import '../components/avatar.dart';
import '../components/food_type_radio.dart';

class NewFoodPage extends StatefulWidget {
  const NewFoodPage({super.key});

  @override
  State<NewFoodPage> createState() => _NewFoodPageState();
}

class _NewFoodPageState extends State<NewFoodPage> {
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _foodNameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

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
      body: Padding(
        padding: const EdgeInsets.only(bottom: 45),
        child: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: Center(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Insira a imagem do alimento',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: AvatarImage(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        width: 350,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 11.0, bottom: 11.0),
                          child: TextFormField(
                             validator: (value) {
                        if (value == null || value.length < 2) {
                          return 'Por favor, digite um alimento válido';
                        }
                        return null;
                      },
                            controller: _foodNameController,
                            decoration: textInputDecoration("Nome do alimento"),
                          ),
                        ),
                      ),
                    ),
                    const Text(
                      'Categoria',
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                    const FoodTypeRadio(),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Calorias (porção 100g/100ml)",
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                    SizedBox(
                      width: 350,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 11.0),
                        child: TextFormField(
                           validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, digite um valor calórico válido';
                        }
                        return null;
                      },
                          controller: _caloriesController,
                          keyboardType: TextInputType.number,
                          decoration: textInputDecoration("Calorias"),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    CustomButton(350, "Adicionar Alimento", registerButtonClicked),
                  ],
                ),
              )),
        ),
      ),
    );
  }

    registerButtonClicked() {
    if (_formKey.currentState!.validate()) {
      print('Form ok');
    } else {
      print('Form nok');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Por favor, preencha corretamente todos os campos!")));
    }
  }
}
