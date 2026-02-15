// ignore_for_file: non_constant_identifier_names
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../../brand/models/brand.dart';

class Ingredient {
  Ingredient({
    this.id,
    this.name,
    this.price,
    this.size,
    this.is_ml,
    this.brand,
  });

  String? id;
  String? name;
  num? price;
  num? size;
  bool? is_ml;
  Brand? brand;

  @override
  String toString() {
    return 'Ingredient{id: $id, name: $name, price: $price, size: $size, is_ml: $is_ml, brand: $brand}';
  }

  ParseObject toParseObject() {
    final parseObject = ParseObject('Ingredient')
      ..objectId = id
      ..set('name', name!)
      ..set('price', price!)
      ..set('size', size!)
      ..set('is_ml', is_ml!)
      ..set('brand', brand!.toParseObject());
    return parseObject;
  }

  factory Ingredient.fromParse(ParseObject parseObject) {
    return Ingredient(
      id: parseObject.objectId,
      name: parseObject.get<String>('name'),
      price: parseObject.get<num>('price'),
      size: parseObject.get<num>('size'),
      is_ml: parseObject.get<bool>('is_ml'),
      brand: parseObject.containsKey('brand') && parseObject.get<ParseObject>('brand') != null
          ? Brand.fromParse(parseObject.get<ParseObject>('brand')!)
          : null,
    );
  }
}
