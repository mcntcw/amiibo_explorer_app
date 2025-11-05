import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:amiibo_explorer_app/search/presentation/bloc/search_bloc.dart';
import 'package:amiibo_explorer_app/core/domain/amiibo_repository.dart';
import 'package:amiibo_explorer_app/core/domain/amiibo.dart';

class _MockRepo extends Mock implements AmiiboRepository {}

void main() {
  late _MockRepo repo;

  setUp(() {
    repo = _MockRepo();
  });

  Amiibo buildAmiibo(String name) => Amiibo(
    amiiboSeries: 'Series',
    character: name,
    gameSeries: 'Game',
    head: 'HEAD',
    image: 'https://example.com/$name.png',
    name: name,
    tail: 'TAIL',
    type: 'Figure',
    releaseDate: '2020-01-01',
  );

  group('SearchBloc', () {
    test('initial state is SearchInitial', () {
      final bloc = SearchBloc(amiiboRepository: repo);
      expect(bloc.state, isA<SearchInitial>());
      bloc.close();
    });

    blocTest<SearchBloc, SearchState>(
      'emits [Initial] when SearchRequested with empty/whitespace query (trim + early return)',
      build: () => SearchBloc(amiiboRepository: repo),
      act: (bloc) => bloc.add(SearchRequested('   ')),
      expect: () => <SearchState>[
        // No loading, immediate reset to initial
        SearchInitial(),
      ],
      // No repo calls expected
      verify: (_) {
        verifyNever(() => repo.search(query: any(named: 'query')));
      },
    );

    blocTest<SearchBloc, SearchState>(
      'emits [Loading, Success] when repository returns non-empty list',
      build: () {
        when(
          () => repo.search(query: 'mario'),
        ).thenAnswer((_) async => [buildAmiibo('Mario')]);
        return SearchBloc(amiiboRepository: repo);
      },
      act: (bloc) => bloc.add(SearchRequested('mario')),
      expect: () => <SearchState>[
        SearchLoading('mario'),
        SearchSuccess(query: 'mario', results: [buildAmiibo('Mario')]),
      ],
      verify: (_) {
        verify(() => repo.search(query: 'mario')).called(1);
      },
    );

    blocTest<SearchBloc, SearchState>(
      'emits [Loading, Empty] when repository returns empty list',
      build: () {
        when(
          () => repo.search(query: 'unknown'),
        ).thenAnswer((_) async => <Amiibo>[]);
        return SearchBloc(amiiboRepository: repo);
      },
      act: (bloc) => bloc.add(SearchRequested('unknown')),
      expect: () => <SearchState>[
        SearchLoading('unknown'),
        SearchEmpty('unknown'),
      ],
      verify: (_) {
        verify(() => repo.search(query: 'unknown')).called(1);
      },
    );

    blocTest<SearchBloc, SearchState>(
      'emits [Loading, Failure] with formatted message when repository throws',
      build: () {
        when(
          () => repo.search(query: 'mario'),
        ).thenThrow(Exception('network down'));
        return SearchBloc(amiiboRepository: repo);
      },
      act: (bloc) => bloc.add(SearchRequested('mario')),
      expect: () => <SearchState>[
        SearchLoading('mario'),
        SearchFailure(query: 'mario', errorMessage: 'network down'),
      ],
      verify: (_) {
        verify(() => repo.search(query: 'mario')).called(1);
      },
    );

    blocTest<SearchBloc, SearchState>(
      'formats known prefixes (StateError/FormatException) to readable message',
      build: () {
        when(
          () => repo.search(query: 'bad'),
        ).thenThrow(FormatException('invalid payload'));
        return SearchBloc(amiiboRepository: repo);
      },
      act: (bloc) => bloc.add(SearchRequested('bad')),
      expect: () => <SearchState>[
        SearchLoading('bad'),
        SearchFailure(query: 'bad', errorMessage: 'invalid payload'),
      ],
      verify: (_) {
        verify(() => repo.search(query: 'bad')).called(1);
      },
    );

    blocTest<SearchBloc, SearchState>(
      'SearchCleared emits Initial regardless of current state',
      build: () {
        when(
          () => repo.search(query: 'mario'),
        ).thenAnswer((_) async => [buildAmiibo('Mario')]);
        return SearchBloc(amiiboRepository: repo);
      },
      act: (bloc) async {
        bloc.add(SearchRequested('mario'));
        await Future<void>.delayed(const Duration(milliseconds: 1));
        bloc.add(SearchCleared());
      },
      expect: () => <SearchState>[
        SearchLoading('mario'),
        SearchSuccess(query: 'mario', results: [buildAmiibo('Mario')]),
        SearchInitial(),
      ],
    );
  });
}
