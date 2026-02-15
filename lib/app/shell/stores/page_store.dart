// ignore_for_file: library_private_types_in_public_api
import 'package:mobx/mobx.dart';

// Execute um dos comandos para rodar o MobX:
//  - flutter packages pub run build_runner watch
//  - flutter pub run build_runner watch --delete-conflicting-outputs

part 'page_store.g.dart';

class PageStore = _PageStore with _$PageStore;

abstract class _PageStore with Store {
  @readonly
  int _page = 0;

  @action
  void setPage(int value) => _page = value;
}