import 'package:flutter/material.dart';

class FoodTypeRadio extends StatefulWidget {
  const FoodTypeRadio({super.key});

  @override
  State<FoodTypeRadio> createState() => _FoodTypeRadioState();
}

enum FoodType { proteina, carboidrato, fruta, grao, bebida }

class _FoodTypeRadioState extends State<FoodTypeRadio> {
  FoodType? _selectedValue = FoodType.proteina;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        RadioListTile(
          title: const Text("Proteína"),
          value: FoodType.proteina,
          dense: true,
          groupValue: _selectedValue,
          onChanged: (value) {
            setState(
              () {
                _selectedValue = value;
              },
            );
          },
        ),

        RadioListTile(
          title: const Text("Carboidrato"),
          value: FoodType.carboidrato,
          dense: true,
          groupValue: _selectedValue,
          onChanged: (value) {
            setState(
              () {
                _selectedValue = value;
              },
            );
          },
        ),

        RadioListTile(
          title: const Text("Fruta"),
          value: FoodType.fruta,
          dense: true,
          groupValue: _selectedValue,
          onChanged: (value) {
            setState(
              () {
                _selectedValue = value;
              },
            );
          },
        ),

        RadioListTile(
          title: const Text("Grão"),
          value: FoodType.grao,
          dense: true,
          groupValue: _selectedValue,
          onChanged: (value) {
            setState(
              () {
                _selectedValue = value;
              },
            );
          },
        ),

        RadioListTile(
          title: const Text("Bebida"),
          value: FoodType.bebida,
          dense: true,
          groupValue: _selectedValue,
          onChanged: (value) {
            setState(
              () {
                _selectedValue = value;
              },
            );
          },
        ),
      ],
    );
  }
}
