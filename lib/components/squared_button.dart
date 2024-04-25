import 'package:app_nutricao/_core/color_list.dart';
import 'package:flutter/material.dart';

class SquaredButton extends StatelessWidget {
  final String description;
  final IconData icon;
  final void Function() onClick;

  const SquaredButton({required this.description, required this.icon, required this.onClick, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        width: 150,
        height: 120,
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),  // Cor da sombra
                spreadRadius: 0,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: onClick,
                icon: Icon(
                  icon,
                  color: AppColors.textLight,
                  size: 50,
                ),
              ),
              Text(
                description,
                style: const TextStyle(
                  color: AppColors.textLight,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
