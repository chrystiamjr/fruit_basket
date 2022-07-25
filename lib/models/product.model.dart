class ProductModel {
  final String? uuid;
  final String name;
  final String nameBr;
  final double price;
  final int quantity;
  final String size;
  final String description;
  final String descriptionBr;
  final String photo;
  final double promoPercentage;
  final List<String> tags;
  final bool active;

  ProductModel({
    this.uuid,
    this.name = '',
    this.nameBr = '',
    this.price = 0,
    this.quantity = 0,
    this.size = '',
    this.description = '',
    this.descriptionBr = '',
    this.photo = '',
    this.promoPercentage = 0,
    this.tags = const [],
    this.active = false,
  });

  factory ProductModel.fromJsonWithId(Map<String, dynamic>? json, String uuid) {
    return ProductModel(
      uuid: uuid,
      name: json?['name'],
      nameBr: json?['nameBr'],
      quantity: double.parse(json?['quantity'].toString() ?? '0').ceil(),
      price: double.parse(json?['price'].toString() ?? '0'),
      size: json?['size'],
      description: json?['description'],
      descriptionBr: json?['descriptionBr'],
      photo: json?['photo'],
      promoPercentage: double.parse(json?['promoPercentage'].toString() ?? '0'),
      tags: List<String>.from(json?['tags']),
      active: json?['active'],
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'nameBr': nameBr,
        'price': price,
        'quantity': quantity,
        'size': size,
        'description': description,
        'descriptionBr': descriptionBr,
        'photo': photo,
        'promoPercentage': promoPercentage,
        'tags': tags.join(', '),
        'active': active,
      };
}
