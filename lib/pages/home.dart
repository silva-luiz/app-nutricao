import 'package:app_nutricao/_core/color_list.dart';
import 'package:app_nutricao/components/custom_button.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // Aplicando uma imagem de fundo
        image: DecorationImage(
          image: const AssetImage("assets/background.jpg"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black
                .withOpacity(0.4), // Reduz a opacidade da imagem para 50%
            BlendMode.dstATop, // Mantém a imagem visível sob a cor do filtro
          ),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Bem-vindo ao Nutriplan',
                style: TextStyle(fontSize: 26, color: AppColors.textDark),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Para iniciar, crie seu primeiro cardápio',
                  style: TextStyle(
                      fontSize: 18,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w700)),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: CustomButton(200, "Novo Cardápio", () {
                print("ok");
              }),
            )
          ],
        ),
      ),
    );
  }
}
