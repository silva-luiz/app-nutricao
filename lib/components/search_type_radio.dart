import 'package:flutter/material.dart';

class SearchTypeRadio extends StatefulWidget {
  final ValueChanged<SearchType> onChanged;

  const SearchTypeRadio({Key? key, required this.onChanged}) : super(key: key);

  @override
  _SearchTypeRadioState createState() => _SearchTypeRadioState();
}

enum SearchType { alimento, cardapio }

class _SearchTypeRadioState extends State<SearchTypeRadio> {
  SearchType _selectedValue = SearchType.alimento;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 160,
          child: RadioListTile<SearchType>(
            title: const Text(
              "Alimento",
              style: TextStyle(fontSize: 14),
            ),
            value: SearchType.alimento,
            groupValue: _selectedValue,
            onChanged: (SearchType? value) {
              if (value != null) {
                setState(() {
                  _selectedValue = value;
                });
                widget.onChanged(_selectedValue);
              }
            },
          ),
        ),
        SizedBox(
          width: 160,
          child: RadioListTile<SearchType>(
            title: const Text(
              "Cardápio",
              style: TextStyle(fontSize: 14),
            ),
            value: SearchType.cardapio,
            groupValue: _selectedValue,
            onChanged: (SearchType? value) {
              if (value != null) {
                setState(() {
                  _selectedValue = value;
                });
                widget.onChanged(_selectedValue);
              }
            },
          ),
        ),
      ],
    );
  }
}
