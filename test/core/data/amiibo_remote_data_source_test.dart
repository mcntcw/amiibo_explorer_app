import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:amiibo_explorer_app/core/domain/amiibo.dart';
import 'package:amiibo_explorer_app/core/data/network/amiibo_remote_data_source.dart';

class _MockDio extends Mock implements Dio {}

class _MockResponse extends Mock implements Response {}

void main() {
  late _MockDio dio;
  late AmiiboRemoteDataSource dataSource;

  setUp(() {
    dio = _MockDio();
    dataSource = AmiiboRemoteDataSource(
      dio: dio,
      baseUrl: 'https://www.amiiboapi.com',
    );
  });

  group('AmiiboRemoteDataSource.search', () {
    test(
      'calls /api/amiibo/ with name param and parses Map response',
      () async {
        // Arrange
        final response = _MockResponse();
        final payload = {
          'amiibo': [
            {
              'amiiboSeries': 'Super Mario',
              'character': 'Mario',
              'gameSeries': 'Super Mario',
              'head': '00000000',
              'image': 'https://example.com/mario.png',
              'name': 'Mario',
              'release': {'jp': '2014-12-06'},
              'tail': '00000002',
              'type': 'Figure',
            },
          ],
        };

        when(
          () => dio.get(any(), queryParameters: any(named: 'queryParameters')),
        ).thenAnswer((_) async {
          when(() => response.data).thenReturn(payload);
          return response;
        });

        // Act
        final result = await dataSource.search(query: 'mario');

        // Assert
        verify(
          () => dio.get('/api/amiibo/', queryParameters: {'name': 'mario'}),
        ).called(1);
        expect(result, isA<List<Amiibo>>());
        expect(result.length, 1);
        expect(result.first.name, 'Mario');
        expect(result.first.releaseDate, '2014-12-06');
      },
    );

    test('calls without name when query is null/empty', () async {
      // Arrange
      final response = _MockResponse();
      final payload = {'amiibo': []};

      when(
        () => dio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenAnswer((_) async {
        when(() => response.data).thenReturn(payload);
        return response;
      });

      // Act
      final resultNull = await dataSource.search(query: null);
      final resultEmpty = await dataSource.search(query: '');

      // Assert
      verify(() => dio.get('/api/amiibo/', queryParameters: {})).called(2);
      expect(resultNull, isEmpty);
      expect(resultEmpty, isEmpty);
    });

    test('parses when res.data is a JSON string', () async {
      // Arrange
      final response = _MockResponse();
      final payload = {
        'amiibo': [
          {
            'amiiboSeries': 'Zelda',
            'character': 'Link',
            'gameSeries': 'Zelda',
            'head': '00112233',
            'image': 'https://example.com/link.png',
            'name': 'Link',
            'release': null,
            'tail': '44556677',
            'type': 'Figure',
          },
        ],
      };
      final jsonString = jsonEncode(payload);

      when(
        () => dio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenAnswer((_) async {
        when(() => response.data).thenReturn(jsonString);
        return response;
      });

      // Act
      final result = await dataSource.search(query: 'link');

      // Assert
      expect(result.length, 1);
      expect(result.first.name, 'Link');
      expect(result.first.releaseDate, isNull);
    });

    test('returns empty list when "amiibo" key missing or empty', () async {
      // Arrange
      final response = _MockResponse();
      final payload = <String, dynamic>{}; // no "amiibo" key

      when(
        () => dio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenAnswer((_) async {
        when(() => response.data).thenReturn(payload);
        return response;
      });

      // Act
      final result = await dataSource.search(query: 'anything');

      // Assert
      expect(result, isEmpty);
    });

    test(
      'throws on DioException (e.g., 500) to surface error upstream',
      () async {
        // Arrange
        when(
          () => dio.get(any(), queryParameters: any(named: 'queryParameters')),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/api/amiibo/'),
            response: Response(
              requestOptions: RequestOptions(path: '/api/amiibo/'),
              statusCode: 500,
              statusMessage: 'Internal Server Error',
            ),
            type: DioExceptionType.badResponse,
          ),
        );

        // Act & Assert
        await expectLater(
          () => dataSource.search(query: 'mario'),
          throwsA(isA<DioException>()),
        );
      },
    );
  });
}
