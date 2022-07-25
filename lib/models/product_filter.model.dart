enum FilterType { clear, equals, greaterThan, lowerThan, like, exists }

extension FilterTypeX on ProductFilter {
  bool get isClear => type == FilterType.clear;

  bool get isEquals => type == FilterType.equals;

  bool get isGreater => type == FilterType.greaterThan;

  bool get isLower => type == FilterType.lowerThan;

  bool get isLike => type == FilterType.like;

  bool get isExists => type == FilterType.exists;
}

class ProductFilter {
  final String field;
  final FilterType type;
  final dynamic value;

  ProductFilter({
    required this.type,
    this.field = '',
    this.value,
  });
}
