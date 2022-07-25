part of 'keyboard.cubit.dart';

enum KeyboardStatus { visible, hidden }

extension KeyboardStatusX on KeyboardStatus {
  bool get isVisible => this == KeyboardStatus.visible;

  bool get isHidden => this == KeyboardStatus.hidden;
}

class KeyboardState extends Equatable {
  final KeyboardStatus status;

  const KeyboardState({
    this.status = KeyboardStatus.hidden,
  });

  KeyboardState copyWith({KeyboardStatus? status}) =>
      KeyboardState(
        status: status ?? this.status,
      );

  factory KeyboardState.fromJson(Map<String, dynamic> json) =>
      KeyboardState(
        status: json['status'],
      );

  Map<String, dynamic>? toJson() =>
      {
        'status': status.toString(),
      };

  @override
  List<Object?> get props => [status];
}
