import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class Brand {
  Brand({
    this.id,
    this.name,
  });

  String? id;
  String? name;

  @override
  String toString() {
    return 'Brand { id: $id, name: $name}';
  }

  ParseObject toParseObject() {
    final parseObject = ParseObject('Brand')
      ..objectId = id
      ..set('name', name!);
    return parseObject;
  }


  factory Brand.fromParse(ParseObject parseObject) {
    return Brand(
      id: parseObject.objectId,
      name: parseObject.get<String>('name'),
    );
  }
}
