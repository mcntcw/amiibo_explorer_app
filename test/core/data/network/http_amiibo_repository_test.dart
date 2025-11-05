import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:amiibo_explorer_app/core/domain/amiibo.dart';
import 'package:amiibo_explorer_app/core/data/network/amiibo_remote_data_source.dart';
import 'package:amiibo_explorer_app/core/data/http_amiibo_repository.dart';

class _MockRemote extends Mock implements AmiiboRemoteDataSource {}

void main() {
  late _MockRemote remote;
  late HttpAmiiboRepository repo;

  setUp(() {
    remote = _MockRemote();
    repo = HttpAmiiboRepository(remote);
  });

  group('HttpAmiiboRepository.search', () {
    test(
      'delegates to remote.search with query and returns its result',
      () async {
        // Arrange
        final items = <Amiibo>[
          Amiibo(
            amiiboSeries: 'Super Mario',
            character: 'Mario',
            gameSeries: 'Super Mario',
            head: '00000000',
            image: 'https://example.com/mario.png',
            name: 'Mario',
            tail: '00000002',
            type: 'Figure',
            releaseDate: '2014-12-06',
          ),
        ];

        when(
          () => remote.search(query: 'mario'),
        ).thenAnswer((_) async => items);

        // Act
        final result = await repo.search(query: 'mario');

        // Assert
        verify(() => remote.search(query: 'mario')).called(1);
        expect(result, items);
      },
    );

    test(
      'passes null/empty query through and returns empty list from remote',
      () async {
        when(
          () => remote.search(query: null),
        ).thenAnswer((_) async => <Amiibo>[]);
        when(
          () => remote.search(query: ''),
        ).thenAnswer((_) async => <Amiibo>[]);

        final r1 = await repo.search(query: null);
        final r2 = await repo.search(query: '');

        verify(() => remote.search(query: null)).called(1);
        verify(() => remote.search(query: '')).called(1);
        expect(r1, isEmpty);
        expect(r2, isEmpty);
      },
    );

    test(
      'rethrows exceptions from remote to surface errors upstream',
      () async {
        when(
          () => remote.search(query: 'mario'),
        ).thenThrow(Exception('network'));

        expect(() => repo.search(query: 'mario'), throwsA(isA<Exception>()));
        verify(() => remote.search(query: 'mario')).called(1);
      },
    );
  });
}
