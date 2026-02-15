import 'package:meu_doce_custo/features/recipies/models/recipe_category.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class Recipe {
  Recipe({
    this.id,
    this.name,
    this.cost,
    this.recipeCategory,
  });

  String? id;
  String? name;
  num? cost;
  RecipeCategory? recipeCategory;

  @override
  String toString() {
    return 'Receita{id: $id, name: $name, cost: $cost, recipeCategory: $recipeCategory}';
  }

  ParseObject toParseObject() {
    final parseObject = ParseObject('Recipe')
      ..objectId = id
      ..set('name', name ?? '')
      ..set('cost', cost ?? 0)
      ..set('recipe_category', ParseObject('RecipeCategory')..objectId = recipeCategory?.id,
      );

    return parseObject;
  }

  factory Recipe.fromParse(ParseObject parseObject) {
    return Recipe(
      id: parseObject.objectId,
      name: parseObject.get<String>('name'),
      cost: parseObject.get<num>('cost'),
      recipeCategory: parseObject.containsKey('recipe_category') &&
          parseObject.get<ParseObject>('recipe_category') != null
          ? RecipeCategory.fromParse(parseObject.get<ParseObject>('recipe_category')!)
          : null,
    );
  }
}
