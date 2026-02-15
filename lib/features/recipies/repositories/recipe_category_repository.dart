// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../../../app/shell/stores/filter_search_store.dart';
import '../models/recipe_category.dart';


class RecipeCategoryRepository {
  Future<ParseObject?> createRecipeCategory(RecipeCategory recipeCategory) async {
    try {
      final parseObject = recipeCategory.toParseObject();
      final response = await parseObject.save();

      if (response.success) {
        return response.results?.first;
      } else {
        log('Erro ao criar Categoria da Receita: ${response.error?.message}');
        return null;
      }
    } catch (e, s) {
      log('Repository: Erro ao Criar Categoria da Receita!', error: e.toString(), stackTrace: s);
      return Future.error('Erro ao Criar Categoria da Receita');
    }
  }

  Future<bool> updateRecipeCategory(RecipeCategory recipeCategory) async {
    try {
      final parseObject = recipeCategory.toParseObject();
      final response = await parseObject.save();

      return response.success;
    } catch (e, s) {
      log('Repository: Erro ao Editar Categoria da Receita!', error: e.toString(), stackTrace: s);
      return Future.error('Erro ao Editar Categoria da Receita');
    }
  }

  Future<bool> deleteRecipeCategory(String recipeCategoryId) async {
    try {
      final parseObject = ParseObject('RecipeCategory')..objectId = recipeCategoryId;
      final response = await parseObject.delete();

      return response.success;
    } catch (e, s) {
      log('Repository: Erro ao Deletar Categoria da Receita!', error: e.toString(), stackTrace: s);
      return Future.error('Erro ao Deletar Categoria da Receita');
    }
  }

  Future<List<RecipeCategory>> getAllRecipeCategories({int? page, int limit = 50, FilterSearchStore? filterSearchStore}) async {
    final query = QueryBuilder(ParseObject('RecipeCategory'));

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
        final recipeCategorys = response.results!.map((pl) =>
            RecipeCategory.fromParse(pl)).toList();
        return recipeCategorys;
      } else {
        return [];
      }
    } catch (e, s) {
      log('Repository: Erro ao Buscar Categoria da Receitas!',
          error: e.toString(), stackTrace: s);
      return Future.error('Erro ao Buscar Categoria da Receitas');
    }
  }
}