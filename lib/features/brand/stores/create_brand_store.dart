import 'dart:developer';
import 'package:meu_doce_custo/features/brand/models/brand.dart';
import 'package:mobx/mobx.dart';

import '../repositories/brand_repository.dart';


/*Comando que precisa executar no terminal:
flutter packages pub run build_runner watch
flutter pub run build_runner watch --delete-conflicting-outputs
dart run build_runner watch -d
*/

part 'create_brand_store.g.dart';

class CreateBrandStore = _CreateBrandStore with _$CreateBrandStore;

abstract class _CreateBrandStore with Store {
  _CreateBrandStore(this.brand) {
    _name = brand?.name ?? '';
  }

  late Brand? brand;

  @readonly
  String _name = '';

  @action
  void setName(String value) => _name = value;

  @computed
  bool get nameValid => _name.length >= 2;

  String? get nameError {
    if (!showErrors || nameValid) {
      return null;
    } else if (_name.isEmpty) {
      return 'Campo Obrigatório';
    } else if (_name.length < 3) {
      return 'Nome muito curto';
    } else {
      return ('Nome inválido');
    }
  }

  @readonly
  bool _savedOrUpdatedOrDeleted = false;

  @action
  void setSavedOrUpdatedOrDeleted(bool value) => _savedOrUpdatedOrDeleted = value;

  @readonly
  bool _loading = false;

  @action
  void setLoading(bool value) => _loading = value;

  @observable
  String? error;

  @action
  void setError(String? value) => error = value;

  @observable
  bool showErrors = false;

  @action
  void invalidSendPressed() => showErrors = true;

  @computed
  bool get isFormValid => nameValid && !_loading;

  @computed
  dynamic get createPressed => isFormValid ? _createBrand : null;

  dynamic get editPressed => isFormValid ? _editBrand : null;

  Future<void> _createBrand() async {
    setError(null);
    setLoading(true);

    brand = Brand(
      name: _name,
    );

    try {
      await BrandRepository().createBrand(brand!);
      setSavedOrUpdatedOrDeleted(true);
    } catch (e, s) {
      log('Store: Erro ao Criar Marca!', error: e.toString(), stackTrace: s);
      setError(e.toString());
    }

    setLoading(false);
  }

  @action
  Future<void> _editBrand() async {
    setError(null);
    setLoading(true);

    brand!.name = _name;
   
    try {
      await BrandRepository().updateBrand(brand!);
      setSavedOrUpdatedOrDeleted(true);
    } catch (e, s) {
      log('Store: Erro ao Editar Marca!', error: e.toString(), stackTrace: s);
      setError(e.toString());
    }

    setLoading(false);
  }

  @action
  Future<void> deleteBrand() async {
    setError(null);
    setLoading(true);

    try {
      await BrandRepository().deleteBrand(brand!.id!.toString());
      setSavedOrUpdatedOrDeleted(true);
    } catch (e, s) {
      log('Store: Erro ao Deletar Marca!', error: e.toString(), stackTrace: s);
      setError(e.toString());
    }

    setLoading(false);
  }
}