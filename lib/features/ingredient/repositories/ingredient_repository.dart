// ignore_for_file: depend_on_referenced_packages
import 'dart:developer';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../models/ingredient.dart';
import '../../../app/shell/stores/filter_search_store.dart';

class IngredientRepository {
  Future<ParseObject?> createIngredient(Ingredient ingredient) async {
    try {
      final parseObject = ingredient.toParseObject();

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
        log('Erro ao criar Ingrediente: ${response.error?.message}');
        return null;
      }
    } catch (e, s) {
      log('Repository: Erro ao Criar Ingrediente!', error: e.toString(), stackTrace: s);
      return Future.error('Erro ao Criar Ingrediente');
    }
  }

  Future<bool> updateIngredient(Ingredient ingredient) async {
    try {
      final parseObject = ingredient.toParseObject();
      final response = await parseObject.save();

      return response.success;
    } catch (e, s) {
      log('Repository: Erro ao Editar Ingrediente!', error: e.toString(), stackTrace: s);
      return Future.error('Erro ao Editar Ingrediente');
    }
  }

  Future<bool> deleteIngredient(String ingredientId) async {
    try {
      final parseObject = ParseObject('Ingredient')..objectId = ingredientId;
      final response = await parseObject.delete();

      return response.success;
    } catch (e, s) {
      log('Repository: Erro ao Deletar Ingrediente!', error: e.toString(), stackTrace: s);
      return Future.error('Erro ao Deletar Ingrediente');
    }
  }

  Future<List<Ingredient>> getAllIngredients({int? page, int limit = 1000, FilterSearchStore? filterSearchStore}) async {
    final query = QueryBuilder(ParseObject('Ingredient'));

    query.includeObject(['brand']);
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
        final ingredients = response.results!.map((pl) => Ingredient.fromParse(pl)).toList();
        return ingredients;
      } else {
        return [];
      }
    } catch (e, s) {
      log('Repository: Erro ao Buscar Ingredientes!', error: e.toString(), stackTrace: s);
      return Future.error('Erro ao Buscar Ingredientes');
    }
  }
}
