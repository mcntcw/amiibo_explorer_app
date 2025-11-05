part of 'search_bloc.dart';

@immutable
abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => const [];
}

final class SearchInitial extends SearchState {
  const SearchInitial();
}

final class SearchLoading extends SearchState {
  final String query;
  const SearchLoading(this.query);

  @override
  List<Object?> get props => [query];
}

final class SearchSuccess extends SearchState {
  final String query;
  final List<Amiibo> results;
  const SearchSuccess({required this.query, required this.results});

  @override
  List<Object?> get props => [query, results];
}

final class SearchEmpty extends SearchState {
  final String query;
  const SearchEmpty(this.query);

  @override
  List<Object?> get props => [query];
}

final class SearchFailure extends SearchState {
  final String query;
  final String errorMessage;
  const SearchFailure({required this.query, required this.errorMessage});

  @override
  List<Object?> get props => [query, errorMessage];
}
