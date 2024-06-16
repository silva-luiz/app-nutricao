import 'package:app_nutricao/_core/color_list.dart';
import 'package:app_nutricao/components/custom_button.dart';
import 'package:app_nutricao/data/food.dart';
import 'package:app_nutricao/data/menu.dart';
import 'package:flutter/material.dart';

class InitialHomePage extends StatefulWidget {
  const InitialHomePage({Key? key}) : super(key: key);

  @override
  _InitialHomePageState createState() => _InitialHomePageState();
}

class _InitialHomePageState extends State<InitialHomePage> {
  List<List<List<Map<String, dynamic>>>> cardapios = [];

  @override
  void initState() {
    super.initState();
    _loadCardapios();
  }

  Future<void> _loadCardapios() async {
    try {
      List<Map<String, dynamic>> fetchedCardapios =
          await CardapioDAO.getAllCardapios();
      List<List<List<Map<String, dynamic>>>> parsedCardapios = [];

      for (var cardapio in fetchedCardapios) {
        List<List<Map<String, dynamic>>> parsedCardapio =
            await _parseCardapio(cardapio['str_cdp']);
        parsedCardapios.add(parsedCardapio);
      }

      setState(() {
        cardapios = parsedCardapios;
      });

      await CardapioDAO.printAllCardapios(); // Print somente para debug
    } catch (e) {
      print('Erro ao carregar cardápios: $e');
    }
  }

  Future<List<List<Map<String, dynamic>>>> _parseCardapio(
      String? cardapioStr) async {
    if (cardapioStr == null || cardapioStr.isEmpty) {
      return [];
    }

    List<String> alimentosDeCadaRefeicao = cardapioStr.split(' | ');

    List<List<Map<String, dynamic>>> parsedRefeicoes = [];
    for (String refeicao in alimentosDeCadaRefeicao) {
      List<String> alimentos = refeicao.split(',');
      List<Map<String, dynamic>> alimentosComInfo = [];

      for (String alimento in alimentos) {
        List<Map<String, dynamic>> alimentosInfos =
            await _fetchAlimentoInfo(alimento);
        alimentosComInfo.addAll(alimentosInfos);
      }
      parsedRefeicoes.add(alimentosComInfo);
    }
    return parsedRefeicoes;
  }

  Future<List<Map<String, dynamic>>> _fetchAlimentoInfo(
      String alimentoNome) async {
    try {
      List<Map<String, dynamic>> queryResult =
          await AlimentoDAO.searchSpecificAlimentoByName(alimentoNome);

      List<Map<String, dynamic>> alimentosInfo = [];

      // Se queryResult tiver mais de um alimento com o mesmo nome, tratar cada um
      for (var alimento in queryResult) {
        alimentosInfo.add({
          'nome': alimento['dsc_alm'] ?? alimentoNome,
          'calorias': alimento['cal_alm'] ?? 'N/A',
          'categoria': alimento['ctg_alm'] ?? 'N/A',
        });
      }

      // Se não encontrar nenhum alimento, adicionar um item com valores padrão
      if (alimentosInfo.isEmpty) {
        alimentosInfo.add({
          'nome': alimentoNome,
          'calorias': 'N/A',
          'categoria': 'N/A',
        });
      }

      return alimentosInfo;
    } catch (e) {
      print('Erro ao buscar informações do alimento: $e');
      return [
        {
          'nome': alimentoNome,
          'calorias': 'N/A',
          'categoria': 'N/A',
        }
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(1.0),
                  child: Text(
                    'Bem-vindo ao Nutriplan',
                    style: TextStyle(
                      fontSize: 26,
                      color: Color.fromARGB(255, 2, 112, 17),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 6),
                      for (var cardapio in cardapios)
                        _buildListItem(
                          cardapio,
                        ),
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
        ),
      ),
    );
  }

  Widget _buildListItem(List<List<Map<String, dynamic>>> cardapio) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 12.0, // Aumentando o espaçamento vertical
        horizontal: 12.0,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      width: double.infinity,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: AppColors.gradientTopColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(bottom: 8.0),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.primaryColor,
                    width: 2.0,
                  ),
                ),
              ),
              child: const Text(
                'Cardápio',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
            const SizedBox(
                height: 12), // Espaçamento entre o título e os alimentos
            if (cardapio.isNotEmpty) ...[
              _buildMealItems("Café da manhã", cardapio[0]),
            ],
            if (cardapio.length >= 2) ...[
              const SizedBox(
                  height: 16), // Aumentando o espaçamento entre as refeições
              _buildMealItems("Almoço", cardapio[1]),
            ],
            if (cardapio.length >= 3) ...[
              const SizedBox(
                  height: 16), // Aumentando o espaçamento entre as refeições
              _buildMealItems("Jantar", cardapio[2]),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMealItems(String mealName, List<Map<String, dynamic>> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(bottom: 8.0),
          decoration: BoxDecoration(
            border: Border(
              bottom: const BorderSide(
                color: AppColors.primaryColor,
                width: 2.0,
              ),
              top: mealName ==
                      "Café da manhã" // Verifica se é a primeira refeição
                  ? BorderSide
                      .none // Remove a borda superior apenas no café da manhã
                  : const BorderSide(
                      color: AppColors.primaryColor,
                      width: 2.0,
                    ),
            ),
          ),
          child: Text(
            mealName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
        ),
        const SizedBox(
            height: 8), // Espaçamento entre o título da refeição e os alimentos
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            Widget mealItem = _buildMealItem(items[index]);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                mealItem,
                if (index != items.length - 1)
                  const SizedBox(height: 8), // Espaçamento entre os itens
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildMealItem(Map<String, dynamic> item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                item['nome'],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textDark,
                ),
              ),
            ),
            const SizedBox(width: 8), // Espaçamento entre as colunas
            Expanded(
              child: Text(
                '${item['calorias']} cal.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textDark,
                ),
              ),
            ),
            const SizedBox(width: 8), // Espaçamento entre as colunas
            Expanded(
              child: Text(
                item['categoria'],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textDark,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8), // Espaçamento entre os itens
      ],
    );
  }
}
