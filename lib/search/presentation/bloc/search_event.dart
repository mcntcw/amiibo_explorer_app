part of 'search_bloc.dart';

@immutable
abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => const [];
}

final class SearchRequested extends SearchEvent {
  final String query;
  const SearchRequested(this.query);

  @override
  List<Object?> get props => [query];
}

final class SearchCleared extends SearchEvent {
  const SearchCleared();

  @override
  List<Object?> get props => const [];
}
