import 'package:app_nutricao/data/food.dart';
import 'package:flutter/material.dart';
import 'package:app_nutricao/_core/color_list.dart';
import 'package:app_nutricao/components/logout_dialog.dart';
import 'package:app_nutricao/components/custom_button.dart';
import 'package:app_nutricao/models/food_model.dart';
import 'package:app_nutricao/components/avatar.dart';
import 'package:app_nutricao/components/food_type_radio.dart';
import 'package:app_nutricao/_utils/food_type_converter.dart';

class ModifyFoodPage extends StatefulWidget {
  final Alimento alimento;

  const ModifyFoodPage({Key? key, required this.alimento}) : super(key: key);

  @override
  _ModifyFoodPageState createState() => _ModifyFoodPageState();
}

class _ModifyFoodPageState extends State<ModifyFoodPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _foodNameController;
  late TextEditingController _caloriesController;
  FoodType _selectedCategory = FoodType.proteina;
  String _imagePath = '';

  @override
  void initState() {
    super.initState();
    _foodNameController = TextEditingController(text: widget.alimento.nome);
    _caloriesController =
        TextEditingController(text: widget.alimento.calorias.toString());
    _selectedCategory =
        FoodTypeConverter.convertStringToFoodType(widget.alimento.categoria);
    _imagePath = widget.alimento.imagePath ?? ''; // Manter o imagePath atual
  }

  void _updateImagePath(String path) {
    // Atualiza o _imagePath somente se um novo path for selecionado
    if (path != _imagePath) {
      setState(() {
        _imagePath = path;
      });
    }
  }

  void _deleteAlimento() {
    AlimentoDAO.deleteAlimento(widget.alimento.id).then((_) {
      Navigator.pop(context, true);
    }).catchError((error) {
      print('Erro ao excluir alimento: $error');
    });
  }

  void _onFoodTypeChanged(FoodType foodType) {
    setState(() {
      _selectedCategory = foodType;
    });
  }

  void _updateAlimento() {
    if (_formKey.currentState!.validate()) {
      String nome = _foodNameController.text.trim();
      int calorias = int.parse(_caloriesController.text.trim());
      String categoria = FoodTypeConverter.foodTypeToString(_selectedCategory);
      String imagePath = _imagePath; // Usar o imagePath atualizado

      AlimentoDAO.updateAlimento(
        widget.alimento.id,
        nome,
        imagePath,
        categoria,
        calorias,
      ).then((rowsAffected) {
        Navigator.pop(context, true);
      }).catchError((error) {
        print('Erro ao atualizar alimento: $error');
      });
    }
  }

  InputDecoration textInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(
          color: AppColors.primaryColor,
          width: 2.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Modificar Alimento',
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
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AvatarImage(
                      imagePath: _imagePath, // Usar o _imagePath atualizado
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
                  FoodTypeRadio(
                    onChanged: (foodType) {
                      _onFoodTypeChanged(foodType);
                    },
                  ),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButton(
                        150,
                        "Salvar",
                        _updateAlimento,
                      ),
                      const SizedBox(width: 20),
                      CustomButton(
                        150,
                        "Excluir",
                        _deleteAlimento,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
