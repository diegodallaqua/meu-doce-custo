// ignore_for_file: non_constant_identifier_names
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class User {
  User({
    this.id,
    this.name,
    this.email,
    this.password,
  });

  String? id;
  String? name;
  String? email;
  String? password;

  @override
  String toString() {
    return 'User{id: $id, name: $name, email: $email, password: $password}';
  }

  factory User.fromParse(ParseObject parseObject) {
    return User(
      id: parseObject.objectId,
      name: parseObject.get<String>('username'),
      email: parseObject.get<String>('email'),
    );
  }
}
