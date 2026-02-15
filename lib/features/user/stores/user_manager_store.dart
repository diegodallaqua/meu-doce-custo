// ignore_for_file: non_constant_identifier_names, library_private_types_in_public_api

import 'dart:convert';
import 'dart:developer';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../auth/models/access_token.dart';
import '../../auth/repositories/token_repository.dart';

part 'user_manager_store.g.dart';

class UserManagerStore = _UserManagerStore with _$UserManagerStore;

abstract class _UserManagerStore with Store {
  @readonly
  AccessToken? _tokenData;

  @action
  void setTokenData(AccessToken? value) => _tokenData = value;

  @readonly
  bool? _user;

  @action
  void setUser(bool? value) => _user = value;

  @readonly
  bool _loading = false;

  @computed
  bool get isLogedIn => _user ?? false;

  @action
  void setLoading(bool value) => _loading = value;

  Future<bool> LoggedTrue() async {
    setLoading(true);

    final bool aux = await TokenRepository().verifyToken();

    if (aux) {
      final tokenString = await TokenRepository().tokenString();

      if (tokenString.isNotEmpty) {
        final tokenData = AccessToken(token: tokenString);

        setTokenData(tokenData);
        setUser(true);
        setLoading(false);
        return true;
      } else {
        setUser(false);
        setLoading(false);
        return false;
      }
    } else {
      setUser(false);
      setLoading(false);
      return false;
    }
  }

  @action
  Future<void> loadToken() async {
    setLoading(true);
    try {
      SharedPreferences shared = await SharedPreferences.getInstance();
      String? tokenString = shared.getString('token');

      if (tokenString != null && tokenString.isNotEmpty) {
        final tokenData = AccessToken.fromParseUser(json.decode(tokenString));
        setTokenData(tokenData);
        setUser(true);
      }
    } catch (e) {
      log('Erro ao carregar token!');
    } finally {
      setLoading(false);
    }
  }

  final _tokenRepository = TokenRepository();

  // LOGIN API
  @action
  Future<AccessToken?> login(String email, String password) async {
    setLoading(true);

    final login = await _tokenRepository.loginParse(email, password);
    setTokenData(login);

    if (login != null) {
      setUser(true);
    } else {
      setUser(false);
    }

    setLoading(false);

    return login;
  }

  // Usuário logado conseguir fazer logout
  Future<void> logout() async {
    setLoading(true);
    await TokenRepository().exit();
    setUser(false);
    setLoading(false);
  }
}
