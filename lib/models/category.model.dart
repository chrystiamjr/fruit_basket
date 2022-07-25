class CategoryModel {
  final String? uuid;
  final String name;
  final String nameBr;
  final String icon;
  final String color;

  CategoryModel({
    this.uuid,
    required this.name,
    required this.nameBr,
    required this.icon,
    required this.color,
  });

  CategoryModel.fromJsonWithId(Map<String, dynamic>? json, String uuid)
      : this(
    uuid: uuid,
    name: json?['name'],
    nameBr: json?['nameBr'],
    icon: json?['icon'],
    color: json?['color'],
  );

  CategoryModel.fromJson(Map<String, dynamic> json)
      : this(
    name: json['name'],
    nameBr: json['nameBr'],
    icon: json['icon'],
    color: json['color'],
  );

  Map<String, dynamic> toJson() =>
      {
        'uuid': uuid,
        'name': name,
        'nameBr': nameBr,
        'icon': icon,
        'color': color,
      };
}
