part of 'loader.cubit.dart';

enum LoaderStatus { idle, loading, stopping }

extension LoaderStateX on LoaderStatus {
  bool get isIdle => this == LoaderStatus.idle;

  bool get isLoading => this == LoaderStatus.loading;

  bool get isStopping => this == LoaderStatus.stopping;
}

class LoaderState extends Equatable {
  final LoaderStatus status;

  const LoaderState({
    this.status = LoaderStatus.idle,
  });

  LoaderState copyWith({LoaderStatus? status}) =>
      LoaderState(
        status: status ?? this.status,
      );

  factory LoaderState.fromJson(Map<String, dynamic> json) =>
      LoaderState(
        status: json['status'],
      );

  Map<String, dynamic>? toJson() =>
      {
        'status': status.toString(),
      };

  @override
  List<Object?> get props => [status];
}
