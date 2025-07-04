class AppState {
  final bool isExpanded;

  const AppState({required this.isExpanded});

  factory AppState.initial() => const AppState(isExpanded: false);

  AppState copyWith({bool? isExpanded}) {
    return AppState(isExpanded: isExpanded ?? this.isExpanded);
  }
}
