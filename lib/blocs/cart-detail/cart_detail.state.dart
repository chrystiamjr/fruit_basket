part of 'cart_detail.cubit.dart';

enum CartDetailStatus { initial, shown, hidden }

extension CartDetailStatusX on CartDetailStatus {
  bool get isShown => this == CartDetailStatus.shown;

  bool get isHidden => this == CartDetailStatus.hidden;
}

class CartDetailState extends Equatable {
  final CartDetailStatus status;

  const CartDetailState({
    this.status = CartDetailStatus.hidden,
  });

  CartDetailState copyWith({CartDetailStatus? status}) =>
      CartDetailState(
        status: status ?? this.status,
      );

  factory CartDetailState.fromJson(Map<String, dynamic> json) =>
      CartDetailState(
        status: json['status'],
      );

  Map<String, dynamic>? toJson() =>
      {
        'status': status.toString(),
      };

  @override
  List<Object?> get props => [status];
}
