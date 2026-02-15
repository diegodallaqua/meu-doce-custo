// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../models/ingredient_used.dart';
import '../../../app/shell/stores/filter_search_store.dart';

class IngredientUsedRepository {
  Future<ParseObject?> createIngredientUsed(IngredientUsed ingredientUsed) async {
    try {
      final parseObject = ingredientUsed.toParseObject();
      final response = await parseObject.save();

      if (response.success) {
        return response.results?.first;
      } else {
        log('Erro ao criar Ingrediente Usado: ${response.error?.message}');
        return null;
      }
    } catch (e, s) {
      log('Repository: Erro ao Criar Ingrediente Usado!', error: e.toString(), stackTrace: s);
      return Future.error('Erro ao Criar Ingrediente Usado');
    }
  }

  Future<List<IngredientUsed>> getIngredientsUsedByRecipe(String recipeId) async {
    try {
      final query = QueryBuilder<ParseObject>(ParseObject('IngredientUsed'))
        ..whereEqualTo('recipe', ParseObject('Recipe')..objectId = recipeId)
        ..includeObject(['ingredient', 'ingredient.brand']);

      final response = await query.query();

      if (response.success && response.results != null) {
        return response.results!
            .map((e) => IngredientUsed.fromParse(e))
            .toList();
      } else {
        return [];
      }
    } catch (e, s) {
      log('Erro ao buscar IngredientsUsed!', error: e.toString(), stackTrace: s);
      return Future.error('Erro ao buscar IngredientsUsed');
    }
  }

  Future<bool> updateIngredientUsed(IngredientUsed ingredientUsed) async {
    try {
      final parseObject = ingredientUsed.toParseObject();
      final response = await parseObject.save();

      return response.success;
    } catch (e, s) {
      log('Repository: Erro ao Editar Ingrediente Usado!', error: e.toString(), stackTrace: s);
      return Future.error('Erro ao Editar Ingrediente Usado');
    }
  }

  Future<bool> deleteIngredientUsed(String ingredientUsedId) async {
    try {
      final parseObject = ParseObject('IngredientUsed')..objectId = ingredientUsedId;
      final response = await parseObject.delete();

      return response.success;
    } catch (e, s) {
      log('Repository: Erro ao Deletar Ingrediente Usado!', error: e.toString(), stackTrace: s);
      return Future.error('Erro ao Deletar Ingrediente Usado');
    }
  }

  Future<List<IngredientUsed>> getAllIngredientsUsed({int? page, int limit = 15, FilterSearchStore? filterSearchStore}) async {
    final query = QueryBuilder(ParseObject('IngredientUsed'));

    query.includeObject(['ingredient']);
    query.orderByAscending('name');

    if (page != null && page > 0) {
      final int skip = (page - 1) * limit;
      query.setAmountToSkip(skip);
      query.setLimit(limit);
    }

    if (filterSearchStore != null && filterSearchStore.search.isNotEmpty) {
      query.whereContains('name', filterSearchStore.search);
    }

    try {
      final response = await query.query();
      //print(response.results);
      if (response.success && response.results != null) {
        final ingredientUseds = response.results!.map((pl) => IngredientUsed.fromParse(pl)).toList();
        return ingredientUseds;
      } else {
        return [];
      }
    } catch (e, s) {
      log('Repository: Erro ao Buscar Ingrediente Usados!', error: e.toString(), stackTrace: s);
      return Future.error('Erro ao Buscar Ingrediente Usados');
    }
  }
}
