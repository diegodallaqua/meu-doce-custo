import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/access_token.dart';

class TokenRepository {
  Future<AccessToken?> loginParse(String email, String password) async {
    final now = DateTime.now();
    SharedPreferences shared = await SharedPreferences.getInstance();

    final user = ParseUser(email, password, null);
    final response = await user.login();

    if (response.success && response.result != null) {
      final sessionToken = (response.result as ParseUser).sessionToken!;
      await shared.setString('token', sessionToken);
      await shared.setString('token_timestamp', now.toIso8601String());

      final tokenData = AccessToken(token: sessionToken);
      return tokenData;
    } else {
      return null;
    }
  }

  Future<bool> verifyToken() async {
    SharedPreferences shared = await SharedPreferences.getInstance();

    if (shared.getString('token') != null) {
      final tokenTimestamp = shared.getString('token_timestamp')!;
      final timestamp = DateTime.parse(tokenTimestamp);
      final currentTime = DateTime.now();
      final tokenDuration = currentTime.difference(timestamp);

      const Duration tokenExpirationDuration = Duration(hours: 1);

      // Verifica se o token ainda é válido
      if (tokenDuration <= tokenExpirationDuration) {
        return true;
      } else {
        await exit();
        return false;
      }
    } else {
      return false;
    }
  }

  Future<String> tokenString() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    return shared.getString('token') ?? '';
  }

  Future<bool> exit() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    await shared.clear();

    // Fazendo logout no Parse
    final currentUser = await ParseUser.currentUser() as ParseUser?;
    if (currentUser != null) {
      await currentUser.logout();
    }

    return true;
  }
}
