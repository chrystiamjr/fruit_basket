part of 'cart.cubit.dart';

enum CartStatus { empty, loading, success, error }

extension CartStatusX on CartStatus {
  bool get isEmpty => this == CartStatus.empty;

  bool get isLoading => this == CartStatus.loading;

  bool get isSuccess => this == CartStatus.success;

  bool get isError => this == CartStatus.error;
}

class CartState extends Equatable {
  final CartStatus status;
  final CartModel? currentCart;
  final String? errorMessage;

  const CartState({
    this.status = CartStatus.empty,
    this.currentCart,
    this.errorMessage,
  });

  CartState copyWith({CartStatus? status, CartModel? cart, String? error}) =>
      CartState(
        status: status ?? this.status,
        currentCart: cart ?? currentCart,
        errorMessage: error ?? errorMessage,
      );

  factory CartState.fromJson(Map<String, dynamic> json) =>
      CartState(
        status: json['status'],
        currentCart: CartModel.fromJson(json['currentCart'] as Map<String, dynamic>),
        errorMessage: json['errorMessage'],
      );

  Map<String, dynamic>? toJson() =>
      {
        'status': status.toString(),
        'currentCart': currentCart?.toJson(),
        'errorMessage': errorMessage,
      };

  @override
  List<Object?> get props => [status, currentCart];
}
