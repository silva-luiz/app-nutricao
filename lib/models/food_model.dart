class Alimento {
  final int id;
  final String nome;
  final String? imagePath; // Caminho para a imagem do alimento
  final String categoria;
  final int calorias;

  Alimento({
    required this.id,
    required this.nome,
    this.imagePath,
    required this.categoria,
    required this.calorias,
  });

  factory Alimento.fromMap(Map<String, dynamic> map) {
    return Alimento(
      id: map['id_alm'],
      nome: map['dsc_alm'],
      imagePath: map['fto_alm'],
      categoria: map['ctg_alm'],
      calorias: map['cal_alm'],
    );
  }
}
