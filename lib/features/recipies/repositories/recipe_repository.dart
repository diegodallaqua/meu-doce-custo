// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../models/recipe.dart';
import '../../../app/shell/stores/filter_search_store.dart';

class RecipeRepository {
  Future<ParseObject?> createRecipe(Recipe recipe) async {
    try {
      final parseObject = recipe.toParseObject();

      final currentUser = await ParseUser.currentUser() as ParseUser?;
      if (currentUser == null) {
        throw Exception('Usuário não autenticado.');
      }

      final acl = ParseACL(owner: currentUser);
      acl.setReadAccess(userId: currentUser.objectId!, allowed: true);
      acl.setWriteAccess(userId: currentUser.objectId!, allowed: true);

      parseObject.setACL(acl);

      final response = await parseObject.save();

      if (response.success) {
        return response.results?.first;
      } else {
        log('Erro ao criar Receita: ${response.error?.message}');
        return null;
      }
    } catch (e, s) {
      log('Repository: Erro ao Criar Receita!', error: e.toString(), stackTrace: s);
      return Future.error('Erro ao Criar Receita');
    }
  }

  Future<bool> updateRecipe(Recipe recipe) async {
    try {
      final parseObject = recipe.toParseObject();
      final response = await parseObject.save();

      return response.success;
    } catch (e, s) {
      log('Repository: Erro ao Editar Receita!', error: e.toString(), stackTrace: s);
      return Future.error('Erro ao Editar Receita');
    }
  }


  Future<bool> deleteRecipe(String recipeId) async {
    try {
      final parseObject = ParseObject('Recipe')..objectId = recipeId;
      final response = await parseObject.delete();

      return response.success;
    } catch (e, s) {
      log('Repository: Erro ao Deletar Receita!', error: e.toString(), stackTrace: s);
      return Future.error('Erro ao Deletar Receita');
    }
  }

  Future<List<Recipe>> getAllRecipes({int? page, int limit = 15, FilterSearchStore? filterSearchStore}) async {
    final query = QueryBuilder(ParseObject('Recipe'));

    query.includeObject(['recipe_category', 'ingredients_used.ingredient', 'ingredients_used.ingredient.brand']);
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
      if (response.success && response.results != null) {
        final recipes = response.results!.map((pl) =>
            Recipe.fromParse(pl)).toList();
        return recipes;
      } else {
        return [];
      }
    } catch (e, s) {
      log('Repository: Erro ao Buscar Receitas!',
          error: e.toString(), stackTrace: s);
      return Future.error('Erro ao Buscar Receitas');
    }
  }
}
