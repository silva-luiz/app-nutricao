import 'package:app_nutricao/_core/color_list.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "Pesquisa",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 26,
                  color: AppColors.primaryColor), ),
            ),
            SearchBar(
              controller: controller,
              padding: const MaterialStatePropertyAll<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 16.0)),
              onTap: () {
                controller.openView();
              },
              onChanged: (_) {
                controller.openView();
              },
              leading: const Icon(Icons.search),
            ),
            Row(
                children: [
                    radius
                ]
            )
        ],
    ),
    );
  }
}  

