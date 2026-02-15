// ignore_for_file: depend_on_referenced_packages
import 'dart:developer';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../models/brand.dart';
import '../../../app/shell/stores/filter_search_store.dart';

class BrandRepository {
  Future<ParseObject?> createBrand(Brand brand) async {
    try {
      final parseObject = brand.toParseObject();
      final response = await parseObject.save();

      if (response.success) {
        return response.results?.first;
      } else {
        log('Erro ao criar Marca: ${response.error?.message}');
        return null;
      }
    } catch (e, s) {
      log('Repository: Erro ao Criar Marca!', error: e.toString(), stackTrace: s);
      return Future.error('Erro ao Criar Marca');
    }
  }

  Future<bool> updateBrand(Brand brand) async {
    try {
      final parseObject = brand.toParseObject();
      final response = await parseObject.save();

      return response.success;
    } catch (e, s) {
      log('Repository: Erro ao Editar Marca!', error: e.toString(), stackTrace: s);
      return Future.error('Erro ao Editar Marca');
    }
  }

  Future<bool> deleteBrand(String brandId) async {
    try {
      final parseObject = ParseObject('Brand')..objectId = brandId;
      final response = await parseObject.delete();

      return response.success;
    } catch (e, s) {
      log('Repository: Erro ao Deletar Marca!', error: e.toString(), stackTrace: s);
      return Future.error('Erro ao Deletar Marca');
    }
  }

  Future<List<Brand>> getAllBrands({int? page, int limit = 100, FilterSearchStore? filterSearchStore}) async {
    final query = QueryBuilder(ParseObject('Brand'));

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
        final brands = response.results!.map((pl) => Brand.fromParse(pl)).toList();
        return brands;
      } else {
        return [];
      }
    } catch (e, s) {
      log('Repository: Erro ao Buscar Marcas!', error: e.toString(), stackTrace: s);
      return Future.error('Erro ao Buscar Marcas');
    }
  }
}
