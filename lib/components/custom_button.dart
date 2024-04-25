import 'package:app_nutricao/_core/color_list.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final double _width;
  final String _label;
  final void Function() _onClick;

  const CustomButton(this._width, this._label, this._onClick, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SizedBox(
        width: _width,
        child: ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor),
            onPressed: _onClick,
            child: Text(_label,
                style: const TextStyle(color: AppColors.textLight))),
      ),
    );
  }
}