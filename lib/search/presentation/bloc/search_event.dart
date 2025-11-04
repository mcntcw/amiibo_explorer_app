part of 'search_bloc.dart';

@immutable
sealed class SearchEvent {}

final class SearchRequested extends SearchEvent {
  final String query;
  SearchRequested(this.query);
}

final class SearchCleared extends SearchEvent {
  SearchCleared();
}
