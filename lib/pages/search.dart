import 'dart:io';
import 'package:app_nutricao/data/food.dart';
import 'package:flutter/material.dart';
import 'package:app_nutricao/components/search_type_radio.dart';
import 'package:app_nutricao/_core/color_list.dart';
import 'package:app_nutricao/data/menu.dart';
import 'package:app_nutricao/pages/modify_food.dart';
import 'package:app_nutricao/models/food_model.dart';
import 'package:app_nutricao/models/menu_model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  SearchType _selectedSearchType = SearchType.alimento;
  List<dynamic> _searchResults = [];

  void _onSearchChanged() async {
    final searchText = _searchController.text.toString();
    if (searchText.isNotEmpty) {
      if (_selectedSearchType == SearchType.alimento) {
        final results = await AlimentoDAO.searchAlimentoByName(searchText);
        setState(() {
          _searchResults = results.map((map) => Alimento.fromMap(map)).toList();
        });
      } else if (_selectedSearchType == SearchType.cardapio) {
        final results = await CardapioDAO.searchCardapioByName(searchText);
        setState(() {
          _searchResults = _parseCardapioResults(results);
        });
      }
    } else {
      _loadData(); // Chama a função para carregar os dados corretos quando o campo de pesquisa está vazio
    }
  }

  void _loadData() async {
    if (_selectedSearchType == SearchType.alimento) {
      final results = await AlimentoDAO.getAllAlimentos();
      setState(() {
        _searchResults = results.map((map) => Alimento.fromMap(map)).toList();
        print('Carregando todos os alimentos: $_searchResults');
      });
    } else if (_selectedSearchType == SearchType.cardapio) {
      setState(() {
        _searchResults = []; // Limpa a lista de resultados de alimentos
      });
      final results = await CardapioDAO.getAllCardapios();
      setState(() {
        _searchResults = _parseCardapioResults(results);
        print('Carregando todos os cardápios: $_searchResults');
      });
    }
  }

  List<Cardapio> _parseCardapioResults(List<Map<String, dynamic>> results) {
    List<Cardapio> cardapios = [];
    Map<int, Cardapio> cardapioMap = {};

    // Mapeia os resultados para cardápios e alimentos
    for (var map in results) {
      // Verifica se o id_cdp é nulo ou não
      int? cardapioId = map['id_cdp'] as int?;
      if (cardapioId == null) {
        continue; // Ignora este item e passa para o próximo
      }

      if (!cardapioMap.containsKey(cardapioId)) {
        cardapioMap[cardapioId] = Cardapio(
          id: cardapioId,
          nome: map['dsc_cdp'] ?? '',
          alimentos: [],
        );
        cardapios.add(cardapioMap[cardapioId]!);
      }

      // Adiciona o alimento ao cardápio
      cardapioMap[cardapioId]!.alimentos.add(Alimento(
            id: map['id_alm'] ?? 0,
            nome: map['dsc_alm'] ?? '',
            categoria: map['cat_alm'] ?? '',
            calorias: map['cal_alm'] ?? 0,
            imagePath: map['fto_alm'] ?? '',
          ));
    }
    return cardapios;
  }

  void _loadAlimentos() async {
    if (_selectedSearchType == SearchType.alimento) {
      final results = await AlimentoDAO.getAllAlimentos();
      setState(() {
        _searchResults = results.map((map) => Alimento.fromMap(map)).toList();
        print('Carregando todos os alimentos: $_searchResults');
      });
    } else if (_selectedSearchType == SearchType.cardapio) {
      final results = await CardapioDAO.getAllCardapios();
      setState(() {
        _searchResults = _parseCardapioResults(results);
        print('Carregando todos os cardápios: $_searchResults');
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _onSearchChanged();
    _loadData();
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
                    hintText: 'Digite algo...',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                SearchTypeRadio(
                  onChanged: (SearchType value) {
                    setState(() {
                      _selectedSearchType = value;
                    });
                    _onSearchChanged();
                  },
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final item = _searchResults[index];
                      if (item is Alimento) {
                        ImageProvider<Object>? avatarImage;
                        if (item.imagePath != null) {
                          avatarImage = FileImage(File(item.imagePath!));
                        } else {
                          avatarImage = const AssetImage(
                            'assets/nophoto.png', // Caminho para a imagem padrão
                          );
                        }

                        return ListTile(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ModifyFoodPage(alimento: item),
                              ),
                            );
                            if (result != null && result) {
                              _loadAlimentos();
                            }
                          },
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
                      } else if (item is Cardapio) {
                        return ListTile(
                          onTap: () {
                            // Implementar ação de visualizar cardápio
                            _showCardapioDetails(item);
                          },
                          title: Text(
                            item.nome,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text('ID: ${item.id}'),
                        );
                      }
                      return const SizedBox.shrink();
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

  void _showCardapioDetails(Cardapio cardapio) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(cardapio.nome),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('ID: ${cardapio.id}'),
              const SizedBox(height: 10),
              Text('Alimentos:'),
              ...cardapio.alimentos.map((alimento) => ListTile(
                    title: Text(alimento.nome),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Categoria: ${alimento.categoria}'),
                        Text('Calorias: ${alimento.calorias.toString()}'),
                      ],
                    ),
                  )),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }
}
