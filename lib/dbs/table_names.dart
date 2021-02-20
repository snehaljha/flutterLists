// ignore: camel_case_types
class table_names {
  // final int id;
  final String name;

  table_names(this.name);

  factory table_names.fromMap(Map<String, dynamic> data) {
    return table_names(data['name']);
  }

  Map<String, dynamic> toMap() => {"name": name};
}
