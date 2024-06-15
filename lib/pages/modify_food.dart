import 'package:flutter/material.dart';
import 'package:app_nutricao/models/food_model.dart';

class ModifyFoodPage extends StatelessWidget {
  final Alimento alimento;

  const ModifyFoodPage({super.key, required this.alimento});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modificar Alimento'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Alimento Selecionado:',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              alimento.nome,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text('Categoria: ${alimento.categoria}'),
            Text('Calorias: ${alimento.calorias.toString()}'),
            // Aqui você pode adicionar os campos e widgets para modificar o alimento
          ],
        ),
      ),
    );
  }
}
