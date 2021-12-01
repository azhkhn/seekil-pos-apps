import 'dart:convert';

void prettyPrintJson(Map<String, dynamic> object) {
  JsonEncoder encoder = JsonEncoder.withIndent('\t');

  String prettyString = encoder.convert(object);
  prettyString.split('\n').forEach((element) => print(element));
}
