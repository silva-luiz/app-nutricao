import 'package:app_nutricao/models/food_model.dart'; // Importa a classe Alimento

class Cardapio {
  final int id;
  final String nome;
  final List<Alimento> alimentos;

  Cardapio({
    required this.id,
    required this.nome,
    required this.alimentos,
  });

  factory Cardapio.fromMap(Map<String, dynamic> map) {
    return Cardapio(
      id: map['id_cdp'],
      nome: map['dsc_cdp'], // Corrigido para 'dsc_cdp'
      alimentos: [], // Inicialmente vazio, será populado posteriormente
    );
  }
}
