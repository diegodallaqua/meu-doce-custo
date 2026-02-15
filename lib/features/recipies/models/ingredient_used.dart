import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../../ingredient/models/ingredient.dart';
import 'recipe.dart';

class IngredientUsed {
  IngredientUsed({
    this.id,
    this.ingredient,
    this.quantity,
    this.parcial_cost,
    this.recipe
  });

  String? id;
  Ingredient? ingredient;
  num? quantity;
  num? parcial_cost;
  Recipe? recipe;

  @override
  String toString() {
    return 'Ingredient Used{id: $id, ingredient: $ingredient, quantity: $quantity, parcial_cost: $parcial_cost, recipe: $recipe}';
  }

  ParseObject toParseObject() {
    final parseObject = ParseObject('IngredientUsed')
      ..objectId = id
      ..set('parcial_cost', parcial_cost!)
      ..set('quantity', quantity!)
      ..set('ingredient', ingredient!.toParseObject())
      ..set('recipe', recipe!.toParseObject());
    return parseObject;
  }

  factory IngredientUsed.fromParse(ParseObject parseObject) {
    return IngredientUsed(
      id: parseObject.objectId,
      quantity: parseObject.get<num>('quantity'),
      parcial_cost: parseObject.get<num>('parcial_cost'),
      ingredient: parseObject.containsKey('ingredient') && parseObject.get<ParseObject>('ingredient') != null
          ? Ingredient.fromParse(parseObject.get<ParseObject>('ingredient')!)
          : null,
      recipe: parseObject.containsKey('recipe') && parseObject.get<ParseObject>('recipe') != null
          ? Recipe.fromParse(parseObject.get<ParseObject>('recipe')!)
          : null,
    );
  }
}
