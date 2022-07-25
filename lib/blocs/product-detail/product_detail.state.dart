part of 'product_detail.cubit.dart';

enum ProductDetailStatus { closed, openned }

extension ProductDetailStatusX on ProductDetailStatus {
  bool get isClosed => this == ProductDetailStatus.closed;

  bool get isOpenned => this == ProductDetailStatus.openned;
}

class ProductDetailState extends Equatable {
  final ProductDetailStatus status;
  final ProductModel? selectedProduct;

  const ProductDetailState({
    this.status = ProductDetailStatus.closed,
    this.selectedProduct,
  });

  ProductDetailState copyWith({
    ProductDetailStatus? status,
    ProductModel? product,
  }) =>
      ProductDetailState(
        status: status ?? this.status,
        selectedProduct: product,
      );

  factory ProductDetailState.fromJson(Map<String, dynamic> json) =>
      ProductDetailState(
        status: json['status'],
        selectedProduct: json['product'],
      );

  Map<String, dynamic>? toJson() =>
      {
        'status': status.toString(),
        'product': selectedProduct?.toJson(),
      };

  @override
  List<Object?> get props => [status];
}
