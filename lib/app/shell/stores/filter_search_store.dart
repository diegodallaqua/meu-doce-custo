import 'package:mobx/mobx.dart';

part 'filter_search_store.g.dart';

class FilterSearchStore = _FilterSearchStore with _$FilterSearchStore;

abstract class _FilterSearchStore with Store {
  _FilterSearchStore() {
    clearFilters();
  }

  FilterSearchStore cloneFilter() {
    return FilterSearchStore();
  }

  @readonly
  bool _visibleSearch = false;

  @action
  void setVisibleSearch() => _visibleSearch = !_visibleSearch;

  @action
  void setVisibleSearchFalse() => _visibleSearch = false;

  @readonly
  int _filterCount = 0;

  @computed
  bool get isFilterCount => _search != '';

  @computed
  int get getCountFilter {
    int cont = 0;
    if (_search != '') {
      cont++;
    }
    return cont;
  }

  @action
  void setFilterCountZero() => _filterCount = 0;

  @readonly
  bool _tradeSearch = false;

  @action
  void setTradeSearch(bool value) => _tradeSearch = value;

  @readonly
  String _search = '';

  @action
  void setSearch(String value) => _search = value;

  @observable
  bool showErrors = false;

  @action
  void invalidSendPressed() => showErrors = true;

  @computed
  bool get isFormValid => _search.length >= 0;

  @action
  void clearFilters() {
    setSearch('');
    setFilterCountZero();
  }
}
