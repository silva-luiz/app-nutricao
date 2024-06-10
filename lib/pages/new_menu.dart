import 'package:app_nutricao/_core/color_list.dart';
import 'package:app_nutricao/_core/input_style.dart';
import 'package:app_nutricao/components/custom_button.dart';
import 'package:app_nutricao/components/logout_dialog.dart';
import 'package:app_nutricao/data/database_helper.dart';
import 'package:flutter/material.dart';

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
    final items = await Database.exibeTodosRegistrosAlimento();
    setState(() {
      allItems = items.map((item) => item['dsc_alm'].toString()).toList();
    });
  }

  Future<void> searchBreakfast(String query) async {
    final results = await Database.buscaAlimentoPorNome(query);
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
    final results = await Database.buscaAlimentoPorNome(query);
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
    final results = await Database.buscaAlimentoPorNome(query);
    setState(() {
      if (query.isEmpty) {
        searchDinnerResults.clear();
      } else {
        searchDinnerResults =
            results.map((item) => item['dsc_alm'].toString()).toList();
      }
    });
  }

  registerMenu() {
    if (_formKey.currentState!.validate()) {
      print('Form ok');
    } else {
      print('Form nok');
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
            searchBreakfastResults.clear();
            searchLunchResults.clear();
            searchDinnerResults.clear();
          },
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 12.0,
                    bottom: 10.0,
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
                  color: AppColors.primaryColor,
                  child: const Text(
                    "Café da manhã",
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
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
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
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
                SizedBox(
                  height: 70,
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
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                Title(
                  color: AppColors.primaryColor,
                  child: const Text(
                    "Almoço",
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
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
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
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
                SizedBox(
                  height: 70,
                  child: ListView.builder(
                    itemCount: searchLunchResults.length,
                    itemBuilder: (context, index) {
                      return Container(
                        color: Colors.grey[200],
                        child: ListTile(
                          title: Text(searchBreakfastResults[index]),
                          onTap: () {
                            setState(() {
                              selectedLunchItems.add(searchLunchResults[index]);
                              _searchLunchController.clear();
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                Title(
                  color: AppColors.primaryColor,
                  child: const Text(
                    "Jantar",
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
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
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
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
                SizedBox(
                  height: 70,
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
                            });
                          },
                        ),
                      );
                    },
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
