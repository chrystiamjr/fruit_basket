part of 'language.cubit.dart';

enum LanguageStatus { initial, loading, accepted, rejected }

extension LanguageStatusX on LanguageStatus {
  bool get isInitial => this == LanguageStatus.initial;

  bool get isLoading => this == LanguageStatus.loading;

  bool get isAccepted => this == LanguageStatus.accepted;

  bool get isRejected => this == LanguageStatus.rejected;
}

class LanguageState extends Equatable {
  final LanguageStatus status;
  final List<LanguageModel> languages;
  final LanguageModel? currentLang;
  final int attempt;

  static const List<LanguageModel> _languages = [
    LanguageModel('pt_BR', Locale("pt", "BR")),
    LanguageModel('en_US', Locale("en", "US")),
  ];

  const LanguageState({
    this.status = LanguageStatus.initial,
    this.languages = _languages,
    this.attempt = 0,
    this.currentLang,
  });

  LanguageState copyWith({
    LanguageStatus? status,
    int? attempt,
    LanguageModel? currentLang,
  }) {
    return LanguageState(
      status: status ?? this.status,
      attempt: attempt ?? this.attempt,
      currentLang: currentLang ?? this.currentLang,
    );
  }

  factory LanguageState.fromJson(Map<String, dynamic> json) {
    return LanguageState(
      status: json['status'],
      attempt: json['attempt'],
      currentLang: json['currentLang'],
    );
  }

  Map<String, dynamic>? toJson() {
    Map<String, dynamic> data = {
      'status': status.toString(),
      'attempt': attempt,
      'currentLang': currentLang?.name,
      'languages': languages.map((el) => el.name).join(', '),
    };
    return data;
  }

  @override
  List<Object?> get props => [status, attempt, languages, currentLang];
}
