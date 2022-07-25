part of 'product.cubit.dart';

enum ProductStatus { initial, loading, success, error }

extension ProductStatusX on ProductStatus {
  bool get isInitial => this == ProductStatus.initial;

  bool get isLoading => this == ProductStatus.loading;

  bool get isSuccess => this == ProductStatus.success;

  bool get isError => this == ProductStatus.error;
}

class ProductState extends Equatable {
  final ProductStatus status;
  final List<ProductModel> products;
  final String? errorMessage;

  const ProductState({
    this.status = ProductStatus.initial,
    this.products = const [],
    this.errorMessage,
  });

  ProductState copyWith({
    ProductStatus? status,
    List<ProductModel>? products,
    String? error,
  }) =>
      ProductState(
        status: status ?? this.status,
        products: products ?? this.products,
        errorMessage: error ?? errorMessage,
      );

  factory ProductState.fromJson(Map<String, dynamic> json) =>
      ProductState(
        status: json['status'],
        products: json['products'],
        errorMessage: json['error'],
      );

  Map<String, dynamic>? toJson() =>
      {
        'status': status.toString(),
        'products': products.map((e) => e.toJson()).join(', '),
        'errorMessage': errorMessage,
      };

  @override
  List<Object?> get props => [status, products, errorMessage];
}
