import 'package:flutter/material.dart';

class FoodTypeRadio extends StatefulWidget {
  final Function(FoodType) onChanged;

  const FoodTypeRadio({super.key, required this.onChanged});

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
          title: const Text(
            "Proteína",
            style: TextStyle(fontSize: 18),
          ),
          value: FoodType.proteina,
          groupValue: _selectedValue,
          onChanged: (value) {
            setState(() {
              _selectedValue = value;
            });
            widget.onChanged(value!);
          },
        ),
        RadioListTile(
          title: const Text(
            "Carboidrato",
            style: TextStyle(fontSize: 18),
          ),
          value: FoodType.carboidrato,
          groupValue: _selectedValue,
          onChanged: (value) {
            setState(() {
              _selectedValue = value;
            });
            widget.onChanged(value!);
          },
        ),
        RadioListTile(
          title: const Text(
            "Fruta",
            style: TextStyle(fontSize: 18),
          ),
          value: FoodType.fruta,
          groupValue: _selectedValue,
          onChanged: (value) {
            setState(() {
              _selectedValue = value;
            });
            widget.onChanged(value!);
          },
        ),
        RadioListTile(
          title: const Text(
            "Grão",
            style: TextStyle(fontSize: 18),
          ),
          value: FoodType.grao,
          groupValue: _selectedValue,
          onChanged: (value) {
            setState(() {
              _selectedValue = value;
            });
            widget.onChanged(value!);
          },
        ),
        RadioListTile(
          title: const Text(
            "Bebida",
            style: TextStyle(fontSize: 18),
          ),
          value: FoodType.bebida,
          groupValue: _selectedValue,
          onChanged: (value) {
            setState(() {
              _selectedValue = value;
            });
            widget.onChanged(value!);
          },
        ),
      ],
    );
  }
}
