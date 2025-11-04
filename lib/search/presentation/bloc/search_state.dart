part of 'search_bloc.dart';

@immutable
sealed class SearchState {}

final class SearchInitial extends SearchState {}

final class SearchLoading extends SearchState {
  final String query;
  SearchLoading(this.query);
}

final class SearchSuccess extends SearchState {
  final String query;
  final List<Amiibo> results;
  SearchSuccess({required this.query, required this.results});
}

final class SearchEmpty extends SearchState {
  final String query;
  SearchEmpty(this.query);
}

final class SearchFailure extends SearchState {
  final String query;
  final String errorMessage;
  SearchFailure({required this.query, required this.errorMessage});
}
