import 'package:app_nutricao/_core/color_list.dart';
import 'package:app_nutricao/_core/input_style.dart';
import 'package:app_nutricao/components/custom_button.dart';
import 'package:app_nutricao/components/logout_dialog.dart';
import 'package:flutter/material.dart';
import 'package:app_nutricao/data/food.dart';
import 'package:app_nutricao/data/menu.dart';

class NewMenuPage extends StatefulWidget {
  @override
  _NewMenuPageState createState() => _NewMenuPageState();
}

class _NewMenuPageState extends State<NewMenuPage> {
  final TextEditingController _searchBreakfastController =
      TextEditingController();
  final TextEditingController _searchLunchController = TextEditingController();
  final TextEditingController _searchDinnerController = TextEditingController();

  final TextEditingController _menuNameController = TextEditingController();
  List<String> searchBreakfastResults = [];
  List<String> searchLunchResults = [];
  List<String> searchDinnerResults = [];
  List<String> selectedBreakfastItems = [];
  List<String> selectedLunchItems = [];
  List<String> selectedDinnerItems = [];

  final _formKey = GlobalKey<FormState>();

  Future<void> fetchAllItems() async {
    final items = await AlimentoDAO.getAllAlimentos();
    setState(() {
      allItems = items.map((item) => item['dsc_alm'].toString()).toList();
    });
  }

  Future<void> searchBreakfast(String query) async {
    final results = await AlimentoDAO.searchAlimentoByName(query);
    setState(() {
      if (query.isEmpty) {
        searchBreakfastResults.clear();
      } else {
        searchBreakfastResults =
            results.map((item) => item['dsc_alm'].toString()).toList();
      }
    });
  }

  Future<void> searchLunch(String query) async {
    final results = await AlimentoDAO.searchAlimentoByName(query);
    setState(() {
      if (query.isEmpty) {
        searchLunchResults.clear();
      } else {
        searchLunchResults =
            results.map((item) => item['dsc_alm'].toString()).toList();
      }
    });
  }

  Future<void> searchDinner(String query) async {
    final results = await AlimentoDAO.searchAlimentoByName(query);
    setState(() {
      if (query.isEmpty) {
        searchDinnerResults.clear();
      } else {
        searchDinnerResults =
            results.map((item) => item['dsc_alm'].toString()).toList();
      }
    });
  }

  // Busca informações de cada alimento pra add na lista antes de salvar no banco
  Future<List<Map<String, dynamic>>> fetchItemsInfo(List<String> items) async {
    List<Map<String, dynamic>> itemsInfo = [];
    for (String item in items) {
      List<Map<String, dynamic>> info =
          await AlimentoDAO.searchSpecificAlimentoByName(item);
      if (info.isNotEmpty) {
        itemsInfo.add(info.first);
      }
    }
    return itemsInfo;
  }

  registerMenu() async {
    if (_formKey.currentState!.validate()) {
      // Formulário validado, podemos salvar o cardápio no banco de dados
      final menuName = _menuNameController.text;
      final List<Map<String, dynamic>> breakfastInfo =
          await fetchItemsInfo(selectedBreakfastItems);
      final List<Map<String, dynamic>> lunchInfo =
          await fetchItemsInfo(selectedLunchItems);
      final List<Map<String, dynamic>> dinnerInfo =
          await fetchItemsInfo(selectedDinnerItems);

      // Convertendo a lista de informações de alimentos em uma lista de strings
      final List<String> breakfastStr =
          breakfastInfo.map((info) => info['dsc_alm']).toList().cast<String>();
      final List<String> lunchStr =
          lunchInfo.map((info) => info['dsc_alm']).toList().cast<String>();
      final List<String> dinnerStr =
          dinnerInfo.map((info) => info['dsc_alm']).toList().cast<String>();

      // Verifica se houve problemas com a consulta
      if (breakfastStr.isEmpty || lunchStr.isEmpty || dinnerStr.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                "Alimento não encontrado. Verifique os alimentos selecionados."),
          ),
        );
        return;
      }

      // Inserindo o cardápio no banco de dados
      await CardapioDAO.insertCardapio(menuName, 1,
          "${breakfastStr.join(',')} | ${lunchStr.join(',')} | ${dinnerStr.join(',')}");

      // Mostrar mensagem de sucesso
      Navigator.popAndPushNamed(context, '/home');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Cardápio criado com sucesso!"),
        ),
      );

      // Limpar os campos e listas após salvar
      _menuNameController.clear();
      _searchBreakfastController.clear();
      _searchLunchController.clear();
      _searchDinnerController.clear();
      setState(() {
        searchBreakfastResults.clear();
        searchLunchResults.clear();
        searchDinnerResults.clear();
        selectedBreakfastItems.clear();
        selectedLunchItems.clear();
        selectedDinnerItems.clear();
      });
      CardapioDAO.printAllCardapios(); // Print somente para debug
    } else {
      // Formulário não validado
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor, preencha corretamente todos os campos!"),
        ),
      );
    }
  }

  List<String> allItems = [];
  @override
  void initState() {
    super.initState();
    fetchAllItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Novo cardápio',
          style: TextStyle(color: AppColors.textLight),
        ),
        actions: const [
          LogoutDialog(),
        ],
        backgroundColor: AppColors.primaryColor,
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            _searchBreakfastController.clear();
            _searchLunchController.clear();
            _searchDinnerController.clear();
            setState(() {
              searchBreakfastResults.clear();
              searchLunchResults.clear();
              searchDinnerResults.clear();
            });
          },
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 12.0,
                    bottom: 30.0,
                  ),
                  child: SizedBox(
                    width: 350,
                    child: TextFormField(
                      controller: _menuNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, digite um nome para o cardápio';
                        }
                        if (selectedBreakfastItems.isEmpty ||
                            selectedLunchItems.isEmpty ||
                            selectedDinnerItems.isEmpty) {
                          return "";
                        }
                        return null;
                      },
                      decoration: textInputDecoration("Nome do cardápio"),
                    ),
                  ),
                ),
                Title(
                  // Add item cafe da manhã
                  color: AppColors.primaryColor,
                  child: const Text(
                    "Café da manhã",
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 350,
                    child: TextFormField(
                      controller: _searchBreakfastController,
                      decoration: InputDecoration(
                        labelText: 'Adicionar novo alimento',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            String searchTerm =
                                _searchBreakfastController.text.toLowerCase();
                            setState(() {
                              searchBreakfastResults = allItems
                                  .where((item) =>
                                      item.toLowerCase().contains(searchTerm))
                                  .toList();
                            });
                          },
                        ),
                      ),
                      onChanged: (String value) {
                        String searchTerm = value.toLowerCase();
                        setState(() {
                          searchBreakfastResults = allItems
                              .where((item) =>
                                  item.toLowerCase().contains(searchTerm))
                              .toList();
                        });
                      },
                    ),
                  ),
                ),
                // Resultados abaixo do texto
                SizedBox(
                  height: searchBreakfastResults.isEmpty
                      ? 0
                      : 200, // Ajuste a altura para mostrar mais itens
                  child: Scrollbar(
                    thumbVisibility: true, // Mostra a barra de rolagem
                    child: ListView.builder(
                      itemCount: searchBreakfastResults.length,
                      itemBuilder: (context, index) {
                        return Container(
                          color: Colors.grey[200],
                          child: ListTile(
                            title: Text(searchBreakfastResults[index]),
                            onTap: () {
                              setState(() {
                                selectedBreakfastItems
                                    .add(searchBreakfastResults[index]);
                                _searchBreakfastController.clear();
                                searchBreakfastResults
                                    .clear(); // Limpar resultados
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Visibility(
                    visible: selectedBreakfastItems.isNotEmpty,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      width: 350,
                      padding: const EdgeInsets.all(8.0),
                      child: Wrap(
                        spacing: 8.0,
                        children: selectedBreakfastItems
                            .map(
                              (item) => Chip(
                                label: Text(item),
                                onDeleted: () {
                                  setState(() {
                                    selectedBreakfastItems.remove(item);
                                  });
                                },
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ),
                Title(
                  color: AppColors.primaryColor,
                  child: const Text(
                    "Almoço",
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 350,
                    child: TextFormField(
                      controller: _searchLunchController,
                      decoration: InputDecoration(
                        labelText: 'Adicionar novo alimento',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            String searchTerm =
                                _searchLunchController.text.toLowerCase();
                            setState(() {
                              searchLunchResults = allItems
                                  .where((item) =>
                                      item.toLowerCase().contains(searchTerm))
                                  .toList();
                            });
                          },
                        ),
                      ),
                      onChanged: (String value) {
                        String searchTerm = value.toLowerCase();
                        setState(() {
                          searchLunchResults = allItems
                              .where((item) =>
                                  item.toLowerCase().contains(searchTerm))
                              .toList();
                        });
                      },
                    ),
                  ),
                ),
                // Adiciona a lista de resultados logo abaixo da caixa de texto
                SizedBox(
                  height: searchLunchResults.isEmpty
                      ? 0
                      : 150, // Ajuste a altura para mostrar mais itens
                  child: Scrollbar(
                    thumbVisibility: true, // Mostra a barra de rolagem
                    child: ListView.builder(
                      itemCount: searchLunchResults.length,
                      itemBuilder: (context, index) {
                        return Container(
                          color: Colors.grey[200],
                          child: ListTile(
                            title: Text(searchLunchResults[index]),
                            onTap: () {
                              setState(() {
                                selectedLunchItems
                                    .add(searchLunchResults[index]);
                                _searchLunchController.clear();
                                searchLunchResults
                                    .clear(); // Limpar os resultados de pesquisa ao selecionar um item
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Visibility(
                    visible: selectedLunchItems.isNotEmpty,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      width: 350,
                      padding: const EdgeInsets.all(8.0),
                      child: Wrap(
                        spacing: 8.0,
                        children: selectedLunchItems
                            .map(
                              (item) => Chip(
                                label: Text(item),
                                onDeleted: () {
                                  setState(() {
                                    selectedLunchItems.remove(item);
                                  });
                                },
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ),
                Title(
                  color: AppColors.primaryColor,
                  child: const Text(
                    "Jantar",
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 350,
                    child: TextFormField(
                      controller: _searchDinnerController,
                      decoration: InputDecoration(
                        labelText: 'Adicionar novo alimento',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            String searchTerm =
                                _searchDinnerController.text.toLowerCase();
                            setState(() {
                              searchDinnerResults = allItems
                                  .where((item) =>
                                      item.toLowerCase().contains(searchTerm))
                                  .toList();
                            });
                          },
                        ),
                      ),
                      onChanged: (String value) {
                        String searchTerm = value.toLowerCase();
                        setState(() {
                          searchDinnerResults = allItems
                              .where((item) =>
                                  item.toLowerCase().contains(searchTerm))
                              .toList();
                        });
                      },
                    ),
                  ),
                ),
                // Adiciona a lista de resultados logo abaixo da caixa de texto
                SizedBox(
                  height: searchDinnerResults.isEmpty
                      ? 0
                      : 150, // Ajuste a altura para mostrar mais itens
                  child: Scrollbar(
                    thumbVisibility: true, // Mostra a barra de rolagem
                    child: ListView.builder(
                      itemCount: searchDinnerResults.length,
                      itemBuilder: (context, index) {
                        return Container(
                          color: Colors.grey[200],
                          child: ListTile(
                            title: Text(searchDinnerResults[index]),
                            onTap: () {
                              setState(() {
                                selectedDinnerItems
                                    .add(searchDinnerResults[index]);
                                _searchDinnerController.clear();
                                searchDinnerResults
                                    .clear(); // Limpar os resultados de pesquisa ao selecionar um item
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Visibility(
                    visible: selectedDinnerItems.isNotEmpty,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      width: 350,
                      padding: const EdgeInsets.all(8.0),
                      child: Wrap(
                        spacing: 8.0,
                        children: selectedDinnerItems
                            .map(
                              (item) => Chip(
                                label: Text(item),
                                onDeleted: () {
                                  setState(() {
                                    selectedDinnerItems.remove(item);
                                  });
                                },
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ),
                CustomButton(350, "Criar novo cardápio", registerMenu),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
