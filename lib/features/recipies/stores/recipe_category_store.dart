// ignore_for_file: library_private_types_in_public_api

import 'dart:developer';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

import '../repositories/recipe_category_repository.dart';
import '../../../app/shell/stores/filter_search_store.dart';
import '../../user/stores/user_manager_store.dart';
import '../models/recipe_category.dart';


/*Comando que precisa executar no terminal:
flutter packages pub run build_runner watch
flutter pub run build_runner watch --delete-conflicting-outputs
dart run build_runner watch -d
*/

part 'recipe_category_store.g.dart';

class RecipeCategoryStore = _RecipeCategoryStore with _$RecipeCategoryStore;

abstract class _RecipeCategoryStore with Store {
  final UserManagerStore userManagerStore = GetIt.I<UserManagerStore>();

  _RecipeCategoryStore() {
    // Só mostra os dados se a autoridade não for NULA
    reaction((_) => userManagerStore.tokenData, (tokenData) {
      if (tokenData != null) {
        refreshData();
      }
    });

    autorun((_) async {
      await loadData(page: _page, filterSearchStore: filterStore);
    });
  }

  //monitora qual é o filtro atual
  @observable
  FilterSearchStore filterStore = FilterSearchStore();

  //retorna uma copia do FilterStore atual ou seja uma copia do filtro atual quando abrir a tela para editar o filtro
  FilterSearchStore get getCloneFilterStore => filterStore.cloneFilter();

  @action
  void setFilter(FilterSearchStore value) {
    filterStore = value;
    setPage(0);
    resetPage();
  }

  @readonly
  ObservableList<RecipeCategory> _listCategory = ObservableList();


  @readonly
  ObservableList<RecipeCategory> _listSearch = ObservableList();

  @action
  void runFilter(String value){
    List<RecipeCategory> result = [];

    if(value.isEmpty){
      result = _listCategory;
    }else{
      result = _listCategory.where((element) => element.name!.toLowerCase().contains(value.toLowerCase())).toList();
    }

    _listSearch.clear();

    _listSearch.addAll(result);

  }

  @action
  void setListSearch(List<RecipeCategory> newItems){
    _listSearch.addAll(newItems);
  }

  @readonly
  bool _loading = false;

  @action
  void setLoading(bool value) => _loading = value;

  @readonly
  String? _error;

  @action
  void setError(String? value) => _error = value;

  //PAGINAÇÃO
  @readonly
  int _page = 1;

  @action
  void setPage(int value) => _page = value;

  @readonly
  bool _lastPage = false;

  @action
  void setLastPage(bool value) => _lastPage = value;

  @computed
  int get itemCount => _lastPage ? _listCategory.length : _listCategory.length + 1;

  @computed
  bool get showProgress => _loading && _listCategory.isEmpty;

  @action
  void loadNextPage() {
    _page++;
  }

  @action
  Future<void> refreshData() async {
    setPage(0);
    resetPage();
  }

  void resetPage() {
    _page = 1;
    _listCategory.clear();
    _lastPage = false;
  }

  @action
  void addNewItems(List<RecipeCategory> newItems) {
    if (newItems.length < 15) _lastPage = true;
    _listCategory.addAll(newItems);
  }

  @action
  Future<void> loadData({int? page, required FilterSearchStore filterSearchStore}) async {
    setError(null);
    setLoading(true);

    if (_page == 1) _listCategory.clear();

    try {
      final result = await RecipeCategoryRepository().getAllRecipeCategories(page: _page, filterSearchStore: filterSearchStore);
      addNewItems(result);
      setListSearch(result);
    } catch (e, s) {
      log('Store: Erro ao Carregar Categorias!', error: e.toString(), stackTrace: s);
      return Future.error('Erro ao Carregar Categorias');
    }

    setLoading(false);
  }
}
