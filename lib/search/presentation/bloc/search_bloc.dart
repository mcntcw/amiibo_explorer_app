import 'package:amiibo_explorer_app/core/domain/amiibo.dart';
import 'package:amiibo_explorer_app/core/domain/amiibo_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final AmiiboRepository _amiiboRepository;

  SearchBloc({required AmiiboRepository amiiboRepository})
    : _amiiboRepository = amiiboRepository,
      super(SearchInitial()) {
    on<SearchRequested>(_onSearchRequested);
    on<SearchCleared>(_onSearchCleared);
  }

  Future<void> _onSearchRequested(
    SearchRequested event,
    Emitter<SearchState> emit,
  ) async {
    final q = event.query.trim();

    if (q.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading(q));

    try {
      final results = await _amiiboRepository.search(query: q);

      if (results.isEmpty) {
        emit(SearchEmpty(q));
      } else {
        emit(SearchSuccess(query: q, results: results));
      }
    } catch (e) {
      emit(SearchFailure(query: q, errorMessage: _formatError(e)));
    }
  }

  void _onSearchCleared(SearchCleared event, Emitter<SearchState> emit) {
    // Reset to initial; useful for "Back to search" action
    emit(SearchInitial());
  }
}

String _formatError(Object error) {
  var msg = error.toString();
  // Strip common prefixes
  for (final prefix in const [
    'Exception: ',
    'StateError: ',
    'FormatException: ',
  ]) {
    if (msg.startsWith(prefix)) {
      msg = msg.substring(prefix.length);
      break;
    }
  }
  msg = msg.trim();
  if (msg.isEmpty) return 'Unexpected error';
  return msg;
}
