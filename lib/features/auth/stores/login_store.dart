// ignore_for_file: library_private_types_in_public_api

import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

import '../models/access_token.dart';
import '../../user/stores/user_manager_store.dart';

/* Comando que precisa executar no terminal:

  flutter packages pub run build_runner watch
  flutter pub run build_runner watch --delete-conflicting-outputs

*/

part 'login_store.g.dart';

class LoginStore = _LoginStore with _$LoginStore;

abstract class _LoginStore with Store {
  final UserManagerStore userManagerStore = GetIt.I<UserManagerStore>();

  //E-mail
  @observable
  String email = '';

  @action
  void setEmail(String value) => email = value;

  @computed
  bool get emailValid => RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);

  @computed
  String? get isEmailError {
    return null;
  }

  //Senha
  @observable
  String password = '';

  @action
  void setPassword(String value) => password = value;

  @computed
  bool get passwordValid => password.length >= 6;

  @computed
  String? get isPasswordError {
    if (!showErrors || passwordValid) {
      return null;
    } else if (password.isEmpty) {
      return 'Informe uma senha';
    }
    return null;
  }

  @observable
  bool isObscure = true;

  @action
  void setIsObscure() => isObscure = !isObscure;

  @observable
  bool loading = false;

  @action
  void setLoading(bool value) => loading = value;

  @observable
  String? error;

  @action
  void setError(String? value) => error = value;

  //Erros
  @observable
  bool showErrors = false;

  @action
  void invalidSendPressed() => showErrors = true;


  @computed
  bool get isFormValid => passwordValid;

  @computed
  dynamic get loginPressed => isFormValid ? _login : null;

  @action
  Future<AccessToken?> _login() async {
    setError(null);
    setLoading(true);
    try {
      final AccessToken? token = await userManagerStore.login(email, password);
      setLoading(false);
      return token;
    } catch (e) {
      if(e.toString() == 'XMLHttpRequest error.'){
        setError('Estamos com problemas técnicos, \nlogo estaremos de volta.');
      }else{
        setError(e.toString());
      }

      setLoading(false);
    }
    setLoading(false);
    return null;
  }
}
