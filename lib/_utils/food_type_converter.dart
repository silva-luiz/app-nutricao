import 'package:app_nutricao/components/food_type_radio.dart';

class FoodTypeConverter {
  static FoodType convertStringToFoodType(String category) {
    switch (category) {
      case 'proteina':
        return FoodType.proteina;
      case 'carboidrato':
        return FoodType.carboidrato;
      case 'fruta':
        return FoodType.fruta;
      case 'grao':
        return FoodType.grao;
      case 'bebida':
        return FoodType.bebida;
      default:
        return FoodType.proteina;
    }
  }

  static String foodTypeToString(FoodType foodType) {
    switch (foodType) {
      case FoodType.proteina:
        return 'proteina';
      case FoodType.carboidrato:
        return 'carboidrato';
      case FoodType.fruta:
        return 'fruta';
      case FoodType.grao:
        return 'grao';
      case FoodType.bebida:
        return 'bebida';
      default:
        throw Exception('Tipo de alimento desconhecido: $foodType');
    }
  }
}
