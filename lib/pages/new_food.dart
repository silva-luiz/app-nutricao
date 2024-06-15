import 'package:app_nutricao/components/logout_dialog.dart';
import '../components/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:app_nutricao/data/food.dart';
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
  String imagePath = '';
  String selectedFoodType = 'proteina';
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _foodNameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void _updateImagePath(String newPath) {
    setState(() {
      imagePath = newPath;
    });
  }

  void _onFoodTypeChanged(FoodType foodType) {
    setState(() {
      selectedFoodType = foodType.toString().split('.').last;
    });
  }

  Future<void> insereRegistroAlimento() async {
    if (_formKey.currentState!.validate()) {
      String foodName = _foodNameController.text;

      final alimentoExiste = await AlimentoDAO.isFoodRegistered(foodName);
      print(alimentoExiste);

      if (alimentoExiste) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Este alimento já está registrado!"),
          ),
        );
      } else {
        await AlimentoDAO.insertAlimento(
          foodName,
          imagePath,
          selectedFoodType,
          int.parse(_caloriesController.text),
        );

        await AlimentoDAO.printAllAlimentos();
        registerButtonClicked();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ola, bem-vindo!',
          style: TextStyle(color: AppColors.textLight),
        ),
        actions: const [
          LogoutDialog(),
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
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AvatarImage(
                        onImagePathChanged: _updateImagePath,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        width: 350,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 11.0,
                            bottom: 11.0,
                          ),
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
                    FoodTypeRadio(onChanged: _onFoodTypeChanged),
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
                    CustomButton(
                        350, "Adicionar Alimento", insereRegistroAlimento),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  void registerButtonClicked() {
    if (_formKey.currentState!.validate()) {
      print('Form ok');
      Navigator.popAndPushNamed(context, '/home');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Alimento adicionado com sucesso"),
        ),
      );
    } else {
      print('Form nok');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor, preencha corretamente todos os campos!"),
        ),
      );
    }
  }
}
