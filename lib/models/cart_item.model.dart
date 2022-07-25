class CartItemModel {
  final String? productUuid;
  final int quantity;
  final double price;
  final double total;

  CartItemModel({
    required this.productUuid,
    this.quantity = 0,
    this.price = 0,
    this.total = 0,
  });

  CartItemModel copyWith({
    int? quantity,
    double? price,
    double? total,
  }) =>
      CartItemModel(
        productUuid: productUuid,
        quantity: quantity ?? this.quantity,
        price: price ?? this.price,
        total: total ?? this.total,
      );

  CartItemModel.fromJson(Map<String, dynamic>? json)
      : this(
    productUuid: json?['productUuid'],
    quantity: double.parse(json?['quantity'].toString() ?? '0').ceil(),
    price: double.parse(json?['price'].toString() ?? '0'),
    total: double.parse(json?['total'].toString() ?? '0'),
  );

  Map<String, dynamic> toJson() =>
      {
        'productUuid': productUuid,
        'quantity': quantity,
        'total': total,
        'price': price,
      };
}
