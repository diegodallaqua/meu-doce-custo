import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class AccessToken {
  AccessToken({required this.token});

  final String token;

  factory AccessToken.fromParseUser(ParseUser user) {
    return AccessToken(
      token: user.sessionToken ?? '',
    );
  }
}
