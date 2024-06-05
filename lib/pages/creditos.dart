import 'package:app_nutricao/_core/color_list.dart';
import 'package:flutter/material.dart';

class CreditsPage extends StatelessWidget {
  const CreditsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "Créditos",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 26,
                  color: AppColors.primaryColor),
            ),
          ),
          DevCard(
              name: 'Carolina Medella',
              subtitle: 'carrolmedella',
              photo: 'assets/carol.jpeg'),
          DevCard(
              name: 'Gabriela Gasch', subtitle: '', photo: 'assets/gabi.jpeg'),
          DevCard(
              name: 'João Vitor Rafagnin',
              subtitle: 'jrafagnin',
              photo: 'assets/joao.jpeg'),
          DevCard(
              name: 'Luiz Henrique Gomes',
              subtitle: 'silva-luiz',
              photo: 'assets/luizera.jpeg'),
          DevCard(
              name: 'Nicolas Duque',
              subtitle: 'Nicolasduquee',
              photo: 'assets/nicolau.jpeg'),
          DevCard(
              name: 'Rafael Bazolli',
              subtitle: 'rafaelbazolli',
              photo: 'assets/rafael.jpeg'),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class DevCard extends StatelessWidget {
  final String name;
  final String subtitle;
  final String photo;

  const DevCard(
      {required this.name,
      required this.subtitle,
      required this.photo,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 10, 10, 0),
      child: Card(
        child: ListTile(
          leading: CircleAvatar(backgroundImage: AssetImage(photo), radius: 36),
          title: Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(subtitle),
        ),
      ),
    );
  }
}
