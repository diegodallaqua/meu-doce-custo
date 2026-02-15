// ignore_for_file: library_private_types_in_public_api, non_constant_identifier_names

import 'dart:developer';

import 'package:meu_doce_custo/core/global/formatters.dart';
import 'package:meu_doce_custo/features/user/models/user.dart';
import 'package:mobx/mobx.dart';

import '../repositories/user_repository.dart';

/*Comando que precisa executar no terminal:
flutter packages pub run build_runner watch
flutter pub run build_runner watch --delete-conflicting-outputs
dart run build_runner watch -d
*/

part 'create_user_store.g.dart';

class CreateUserStore = _CreateUserStore with _$CreateUserStore;

abstract class _CreateUserStore with Store {
  late User? user;

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
  String _email = '';

  @action
  void setEmail(String value) => _email = value;

  @computed
  bool get emailValid => _email.isEmailValid();

  String? get emailError {
    if (!showErrors || emailValid) {
      return null;
    } else if (_email.isEmpty) {
      return 'Campo obrigatório';
    } else {
      return 'E-mail inválido';
    }
  }

  @readonly
  bool _visiblePassword = true;

  @action
  void setObscurePassword() => _visiblePassword = !_visiblePassword;

  @readonly
  String _password = '';

  @action
  void setPassword(String value) => _password = value;

  @computed
  bool get passwordValid => _password.length >= 6;

  String? get passwordError {
    if (!showErrors || passwordValid) {
      return null;
    } else if (_password.isEmpty) {
      return 'Campo obrigatório';
    } else if (_password.length < 6) {
      return "senha muito curta";
    } else {
      return ('Senha inválida');
    }
  }

  @readonly
  bool _visiblePasswordConfirmation = true;

  @action
  void setObscurePasswordConfirmation() => _visiblePasswordConfirmation = !_visiblePasswordConfirmation;

  @readonly
  String _password_confirmation = '';

  @action
  void setPasswordConfirmation(String value) => _password_confirmation = value;

  @computed
  bool get passwordConfirmationValid => _password_confirmation.length >= 6 && _password_confirmation == _password;

  String? get passwordConfirmationError {
    if (!showErrors || passwordConfirmationValid) {
      return null;
    } else if (_password_confirmation.isEmpty) {
      return 'Campo obrigatório';
    } else if (_password_confirmation != _password) {
      return 'As Senhas não Correspondem';
    } else {
      return ('Senha inválida');
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
  bool get isFormValid => nameValid && emailValid && (passwordValid && passwordConfirmationValid) && !_loading;

  @computed
  dynamic get createPressed => isFormValid ? _createUser : null;

  Future<void> _createUser() async {
    setError(null);
    setLoading(true);

    user = User(
      name: _name,
      email: _email,
      password: _password
    );

    try {
      await UserRepository().createUser(user!);
      setSavedOrUpdatedOrDeleted(true);
    } catch (e, s) {
      log('Store: Erro ao Criar Usuário!', error: e.toString(), stackTrace: s);
      setError(e.toString());
    }

    setLoading(false);
  }
}