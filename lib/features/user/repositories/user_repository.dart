// ignore_for_file: depend_on_referenced_packages
import 'dart:developer';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../models/user.dart';

class UserRepository {
  Future<void> createUser(User user) async {
    try {
      final parseUser = ParseUser(user.name, user.password, user.email);

      final response = await parseUser.signUp();

      if (!response.success) {
        throw Exception('Erro ao criar Usuário: ${response.error?.message}');
      }
    } catch (e, s) {
      log('Repository: Erro ao Criar Usuário!', error: e.toString(), stackTrace: s);
      throw Exception('Erro ao Criar Usuário: $e');
    }
  }
}
