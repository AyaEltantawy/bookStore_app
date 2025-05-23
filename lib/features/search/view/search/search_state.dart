

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final List<dynamic> searchResults; // أو نموذج معين حسب البيانات المسترجعة

  SearchSuccess(this.searchResults);
}

class SearchError extends SearchState {
  final String message;

  SearchError(this.message);
}
