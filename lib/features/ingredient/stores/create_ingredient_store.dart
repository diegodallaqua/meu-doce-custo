// ignore_for_file: unnecessary_null_comparison, non_constant_identifier_names, library_private_types_in_public_api

import 'dart:developer';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:meu_doce_custo/features/ingredient/models/ingredient.dart';
import 'package:mobx/mobx.dart';

import '../../brand/models/brand.dart';
import '../repositories/ingredient_repository.dart';


/*Comando que precisa executar no terminal:
flutter packages pub run build_runner watch
flutter pub run build_runner watch --delete-conflicting-outputs
dart run build_runner watch -d
*/

part 'create_ingredient_store.g.dart';

class CreateIngredientStore = _CreateIngredientStore with _$CreateIngredientStore;

abstract class _CreateIngredientStore with Store {
  _CreateIngredientStore(this.ingredient) {
    _name = ingredient?.name ?? '';
    _price = UtilBrasilFields.obterReal((ingredient?.price ?? 0.0).toDouble(), moeda: false);
    _size = ingredient?.size.toString() ?? '';
    _is_ml = ingredient?.is_ml ?? false;
    _brand = ingredient?.brand;
  }

  late Ingredient? ingredient;

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
  String _price = '';

  @action
  void setPrice(String value) => _price = value;

  @computed
  bool get priceValid => UtilBrasilFields.converterMoedaParaDouble(_price.isNotEmpty ? _price : '0.0') > 0.0;

  String? get priceError {
    if (!showErrors || priceValid) {
      return null;
    } else {
      return 'Campo Obrigatório';
    }
  }

  @readonly
  String _size = '';

  @action
  void setSize(String value) => _size = value;

  @computed
  bool get sizeValid => int.tryParse(_size) != null && int.tryParse(_size)! >= 0;

  String? get sizeError {
    if (!showErrors || sizeValid) {
      return null;
    } else {
      return 'Campo Obrigatório';
    }
  }

  @readonly
  bool _is_ml = false;

  @action
  void toggleIsMl() => _is_ml = !_is_ml;

  @computed
  bool get isMlValid => _is_ml != null;

  String? get isMlError {
    if (!showErrors || isMlValid) {
      return null;
    } else {
      return 'Campo Obrigatório';
    }
  }

  @readonly
  Brand? _brand;

  @action
  void setBrand(Brand value) => _brand = value;

  @computed
  bool get brandValid => _brand != null;

  String? get brandError {
    if (!showErrors || brandValid) {
      return null;
    } else if (!brandValid) {
      return 'Campo Obrigatório';
    } else {
      return ('Marca inválida');
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
  bool get isFormValid => nameValid && priceValid &&
                          sizeValid && isMlValid &&
                          brandValid && !_loading;

  @computed
  dynamic get createPressed => isFormValid ? _createIngredient : null;

  dynamic get editPressed => isFormValid ? _editIngredient : null;

  Future<void> _createIngredient() async {
    setError(null);
    setLoading(true);

    ingredient = Ingredient(
      name: _name,
      price: UtilBrasilFields.converterMoedaParaDouble(_price),
      size: int.parse(_size),
      is_ml: _is_ml,
      brand: _brand,
    );

    try {
      await IngredientRepository().createIngredient(ingredient!);
      setSavedOrUpdatedOrDeleted(true);
    } catch (e, s) {
      log('Store: Erro ao Criar Ingrediente!', error: e.toString(), stackTrace: s);
      setError(e.toString());
    }

    setLoading(false);
  }

  @action
  Future<void> _editIngredient() async {
    setError(null);
    setLoading(true);

    ingredient!.name = _name;
    ingredient!.price = UtilBrasilFields.converterMoedaParaDouble(_price);
    ingredient!.size = int.parse(_size);
    ingredient!.is_ml = _is_ml;
    ingredient!.brand = _brand!;

    try {
      await IngredientRepository().updateIngredient(ingredient!);
      setSavedOrUpdatedOrDeleted(true);
    } catch (e, s) {
      log('Store: Erro ao Editar Ingrediente!', error: e.toString(), stackTrace: s);
      setError(e.toString());
    }

    setLoading(false);
  }

  @action
  Future<void> deleteIngredient() async {
    setError(null);
    setLoading(true);

    try {
      await IngredientRepository().deleteIngredient(ingredient!.id!.toString());
      setSavedOrUpdatedOrDeleted(true);
    } catch (e, s) {
      log('Store: Erro ao Deletar Ingrediente!', error: e.toString(), stackTrace: s);
      setError(e.toString());
    }

    setLoading(false);
  }
}