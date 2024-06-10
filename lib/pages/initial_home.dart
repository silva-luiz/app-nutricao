import 'package:app_nutricao/_core/color_list.dart';
import 'package:app_nutricao/components/custom_button.dart';
import 'package:flutter/material.dart';

class InitialHomePage extends StatelessWidget {
  const InitialHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? menuName = "Cardápio Básico #1:";
    List<String>? breakfastItems = ["Omelete", "Suco de laranja"];
    List<String>? lunchItems = ["Arroz", "Feijão"];
    List<String>? dinnerItems = ["Salada", "Sopa"];

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage("assets/background.jpg"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.4),
            BlendMode.dstATop,
          ),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(1.0),
              child: Text(
                'Bem-vindo ao Nutriplan',
                style: TextStyle(
                    fontSize: 26, color: Color.fromARGB(255, 2, 112, 17)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(height: 6),
                  Text(
                    menuName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 2, 112, 17),
                    ),
                  ),
                  const SizedBox(height: 5),
                  _buildListItem("Café da manhã", breakfastItems),
                  _buildListItem("Almoço", lunchItems),
                  _buildListItem("Jantar", dinnerItems),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: CustomButton(
                200,
                'Novo Cardápio',
                () {
                  Navigator.pushNamed(context, '/new_menu');
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(String title, List<String>? items) {
    return Container(
      color: AppColors.greyBackground,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 4.0,
          horizontal: 12.0,
        ),
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: ListTile(
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryColor,
            ),
          ),
          subtitle: Text(
            items!.join(", "),
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textDark,
            ),
          ),
        ),
      ),
    );
  }
}
