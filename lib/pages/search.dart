import 'package:flutter/material.dart';
import 'package:app_nutricao/components/search_type_radio.dart';
import 'package:app_nutricao/_core/color_list.dart';
import 'package:app_nutricao/data/food.dart';
import 'dart:io';
import 'package:app_nutricao/models/food_model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  SearchType _selectedSearchType = SearchType.alimento;
  List<Alimento> _searchResults = [];

  void _onSearchChanged() async {
    if (_searchController.text.isNotEmpty) {
      if (_selectedSearchType == SearchType.alimento) {
        final results =
            await AlimentoDAO.searchAlimentoByName(_searchController.text);
        setState(() {
          _searchResults = results.map((map) => Alimento.fromMap(map)).toList();
        });
      } else if (_selectedSearchType == SearchType.cardapio) {
        // Implemente a busca no cardápio aqui, se necessário
      }
    } else {
      final results = await AlimentoDAO.getAllAlimentos();
      setState(() {
        _searchResults = results.map((map) => Alimento.fromMap(map)).toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _onSearchChanged();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    "Pesquisa",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 24,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Digite o nome do alimento',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                SearchTypeRadio(
                  onChanged: (SearchType value) {
                    setState(() {
                      _selectedSearchType = value;
                    });
                    _onSearchChanged(); // Atualiza a busca a cada alteração do texto
                  },
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final item = _searchResults[index];
                      ImageProvider<Object>? avatarImage;

                      if (item.imagePath != null) {
                        avatarImage = FileImage(File(item.imagePath!));
                      } else {
                        avatarImage = const AssetImage(
                          'assets/nophoto.png', // Caminho para a imagem padrão
                        );
                      }

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: avatarImage,
                          radius: 30,
                        ),
                        title: Text(
                          item.nome,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Categoria: ${item.categoria}'),
                            Text('Calorias: ${item.calorias.toString()}'),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
