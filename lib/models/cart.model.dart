import 'cart_item.model.dart';

class CartModel {
  late String? uuid;
  final String? userUuid;
  final DateTime? timestamp;
  final int finalQuantity;
  final double finalPrice;
  late List<CartItemModel> items;

  CartModel({
    this.uuid,
    required this.userUuid,
    this.timestamp,
    this.finalQuantity = 0,
    this.finalPrice = 0,
    this.items = const [],
  });

  CartModel copyWith({
    String? uuid,
    DateTime? timestamp,
    int? quantity,
    double? total,
    List<CartItemModel>? items,
  }) =>
      CartModel(
        uuid: uuid ?? this.uuid,
        userUuid: userUuid,
        timestamp: timestamp ?? this.timestamp,
        finalQuantity: quantity ?? finalQuantity,
        finalPrice: total ?? finalPrice,
        items: items ?? this.items,
      );

  CartModel addItem(CartItemModel item) {
    List<CartItemModel> items = this.items.toList();
    items.add(item);
    return copyWith(items: items);
  }

  CartModel updateItem(CartItemModel item, int index) {
    List<CartItemModel> items = this.items.toList();
    items[index] = item;
    return copyWith(items: items);
  }

  CartModel removeItem(int index) {
    List<CartItemModel> items = this.items.toList();
    items.removeAt(index);
    return copyWith(items: items);
  }

  Map<String, dynamic> remap() {
    List<CartItemModel> items = this.items.toList();
    items = items.map((e) => e.copyWith(total: e.quantity * e.price)).toList();
    return copyWith(items: items).toJson();
  }

  CartModel.fromJson(Map<String, dynamic>? json)
      : this(
      uuid: json?['uuid'],
      userUuid: json?['userUuid'],
      timestamp: DateTime.fromMicrosecondsSinceEpoch(int.parse(json?['timestamp'] ?? '0')),
      finalQuantity: double.parse(json?['finalQuantity'].toString() ?? '0').ceil(),
      finalPrice: double.parse(json?['finalPrice'].toString() ?? '0'),
      items: (json?['items'] as List<dynamic>).map((e) => CartItemModel.fromJson(e)).toList());

  factory CartModel.fromJsonWithId(Map<String, dynamic>? json, String uuid) {
    return CartModel(
        uuid: uuid,
        userUuid: json?['userUuid'],
        timestamp: DateTime.fromMicrosecondsSinceEpoch(int.parse(json?['timestamp'] ?? '0')),
        finalQuantity: json?['finalQuantity'],
        finalPrice: double.parse(json?['finalPrice'].toString() ?? '0'),
        items: (json?['items'] as List<dynamic>).map((e) => CartItemModel.fromJson(e)).toList());
  }

  Map<String, dynamic> toJson() =>
      {
        'uuid': uuid,
        'userUuid': userUuid,
        'timestamp': timestamp?.microsecondsSinceEpoch.toString(),
        'finalQuantity': finalQuantity,
        'finalPrice': finalPrice,
        'items': items.map((e) => e.toJson()).toList(),
      };
}
