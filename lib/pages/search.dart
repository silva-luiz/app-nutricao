import 'package:app_nutricao/components/search_type_radio.dart';
import 'package:app_nutricao/_core/color_list.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "Pesquisa",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 26,
                  color: AppColors.primaryColor),
            ),
          ),
          SearchAnchor(
            builder: (BuildContext context, SearchController controller) {
              return SearchBar(
                controller: controller,
                padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.symmetric(horizontal: 16.0),
                ),
                onTap: () {
                  controller.openView();
                },
                onChanged: (_) {
                  controller.openView();
                },
                leading: const Icon(Icons.search),
              );
            },
            suggestionsBuilder:
                (BuildContext context, SearchController controller) {
              return List<ListTile>.generate(
                5,
                (int index) {
                  final String item = 'item $index';
                  return ListTile(
                    title: Text(item),
                    onTap: () {},
                  );
                },
              );
            },
          ),
          const SearchTypeRadio(),
        ],
      ),
    );
  }
}
