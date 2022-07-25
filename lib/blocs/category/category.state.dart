part of 'category.cubit.dart';

enum CategoryStatus { initial, loading, success, error }

extension CategoryStatusX on CategoryStatus {
  bool get isInitial => this == CategoryStatus.initial;

  bool get isLoading => this == CategoryStatus.loading;

  bool get isSuccess => this == CategoryStatus.success;

  bool get isError => this == CategoryStatus.error;
}

class CategoryState extends Equatable {
  final CategoryStatus status;
  final int selectedIndex;
  final List<CategoryModel> categories;
  final String? errorMessage;

  const CategoryState({
    this.status = CategoryStatus.initial,
    this.selectedIndex = -1,
    this.categories = const [],
    this.errorMessage,
  });

  CategoryState copyWith({
    CategoryStatus? status,
    int? index,
    List<CategoryModel>? items,
    String? error,
  }) =>
      CategoryState(
        status: status ?? this.status,
        selectedIndex: index ?? selectedIndex,
        categories: items ?? categories,
        errorMessage: error ?? errorMessage,
      );

  factory CategoryState.fromJson(Map<String, dynamic> json) =>
      CategoryState(
        status: json['status'],
        selectedIndex: json['selectedIndex'],
        categories: json['categories'].map((e) => CategoryModel.fromJsonWithId(e, e.uuid)).toList(),
        errorMessage: json['errorMessage'],
      );

  Map<String, dynamic>? toJson() =>
      {
        'status': status.toString(),
        'selectedIndex': selectedIndex.toString(),
        'categories': categories.map((e) => e.toJson()).toList().join(','),
        'errorMessage': errorMessage,
      };

  @override
  List<Object?> get props => [status, selectedIndex, categories, errorMessage];
}
