import 'package:flutter/material.dart';

class SearchTypeRadio extends StatefulWidget {
  const SearchTypeRadio({super.key});

  @override
  State<SearchTypeRadio> createState() => _SearchTypeRadioState();
}

enum SearchType { alimento, cardapio }

class _SearchTypeRadioState extends State<SearchTypeRadio> {
  SearchType? _selectedValue = SearchType.alimento;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 160,
          child: RadioListTile(
            title: const Text(
              "Alimento",
              style: TextStyle(fontSize: 14),
            ),
            value: SearchType.alimento,
            groupValue: _selectedValue,
            onChanged: (value) {
              setState(
                () {
                  _selectedValue = value;
                },
              );
            },
          ),
        ),
        SizedBox(
          width: 160,
          child: RadioListTile(
            title: const Text(
              "Cardápio",
              style: TextStyle(fontSize: 14),
            ),
            value: SearchType.cardapio,
            groupValue: _selectedValue,
            onChanged: (value) {
              setState(
                () {
                  _selectedValue = value;
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
