import 'package:flutter_test/flutter_test.dart';
import 'package:amiibo_explorer_app/core/data/amiibo_dto.dart';
import 'package:amiibo_explorer_app/core/domain/amiibo.dart';

void main() {
  group('AmiiboDto.fromJson', () {
    test('parses full JSON with release map', () {
      // Arrange
      final json = {
        'amiiboSeries': 'Super Mario',
        'character': 'Mario',
        'gameSeries': 'Super Mario',
        'head': '00000000',
        'image': 'https://example.com/mario.png',
        'name': 'Mario',
        'release': {
          'au': '2014-11-29',
          'eu': '2014-11-28',
          'jp': '2014-12-06',
          'na': '2014-11-21',
        },
        'tail': '00000002',
        'type': 'Figure',
      };

      // Act
      final dto = AmiiboDto.fromJson(json);

      // Assert
      expect(dto.amiiboSeries, 'Super Mario');
      expect(dto.character, 'Mario');
      expect(dto.gameSeries, 'Super Mario');
      expect(dto.head, '00000000');
      expect(dto.image, 'https://example.com/mario.png');
      expect(dto.name, 'Mario');
      expect(dto.release, isA<Map<String, dynamic>>());
      expect(dto.release!['jp'], '2014-12-06');
      expect(dto.tail, '00000002');
      expect(dto.type, 'Figure');
    });

    test('parses JSON with null release', () {
      final json = {
        'amiiboSeries': 'The Legend of Zelda',
        'character': 'Link',
        'gameSeries': 'Zelda',
        'head': '00112233',
        'image': 'https://example.com/link.png',
        'name': 'Link',
        'release': null,
        'tail': '44556677',
        'type': 'Figure',
      };

      final dto = AmiiboDto.fromJson(json);

      expect(dto.release, isNull);
    });
  });

  group('AmiiboDto.toDomain', () {
    test('maps jp release date to domain releaseDate', () {
      // Arrange
      final dto = AmiiboDto(
        amiiboSeries: 'Super Mario',
        character: 'Mario',
        gameSeries: 'Super Mario',
        head: '00000000',
        image: 'https://example.com/mario.png',
        name: 'Mario',
        release: {'jp': '2014-12-06', 'eu': '2014-11-28'},
        tail: '00000002',
        type: 'Figure',
      );

      // Act
      final domain = dto.toDomain();

      // Assert
      expect(domain, isA<Amiibo>());
      expect(domain.releaseDate, '2014-12-06'); // jp preferred
      expect(domain.name, 'Mario');
      expect(domain.type, 'Figure');
    });

    test('handles null release by producing null releaseDate', () {
      final dto = AmiiboDto(
        amiiboSeries: 'Zelda',
        character: 'Link',
        gameSeries: 'Zelda',
        head: '00112233',
        image: 'https://example.com/link.png',
        name: 'Link',
        release: null,
        tail: '44556677',
        type: 'Figure',
      );

      final domain = dto.toDomain();

      expect(domain.releaseDate, isNull);
    });

    test('handles release map without jp key (keeps null releaseDate)', () {
      final dto = AmiiboDto(
        amiiboSeries: 'Metroid',
        character: 'Samus',
        gameSeries: 'Metroid',
        head: 'ABCDEF01',
        image: 'https://example.com/samus.png',
        name: 'Samus',
        release: {'eu': '2014-11-28', 'na': '2014-11-21'},
        tail: 'ABCDEF02',
        type: 'Figure',
      );

      final domain = dto.toDomain();

      expect(domain.releaseDate, isNull); // jp not present
    });
  });

  group('AmiiboListResponseDto.fromJson', () {
    test('parses list of amiibo items', () {
      // Arrange
      final json = {
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

      // Act
      final listDto = AmiiboListResponseDto.fromJson(json);

      // Assert
      expect(listDto.amiibo.length, 2);
      expect(listDto.amiibo.first.name, 'Mario');
      expect(listDto.amiibo.last.name, 'Link');
    });

    test('handles missing amiibo key by producing empty list', () {
      // Arrange
      final json = <String, dynamic>{};

      // Act
      final listDto = AmiiboListResponseDto.fromJson(json);

      // Assert
      expect(listDto.amiibo, isEmpty);
    });
  });

  group('AmiiboListResponseDto.toDomainList', () {
    test('maps DTO list to domain list with releaseDate from jp', () {
      // Arrange
      final listDto = AmiiboListResponseDto(
        amiibo: [
          AmiiboDto(
            amiiboSeries: 'Super Mario',
            character: 'Mario',
            gameSeries: 'Super Mario',
            head: '00000000',
            image: 'https://example.com/mario.png',
            name: 'Mario',
            release: {'jp': '2014-12-06'},
            tail: '00000002',
            type: 'Figure',
          ),
          AmiiboDto(
            amiiboSeries: 'Zelda',
            character: 'Link',
            gameSeries: 'Zelda',
            head: '00112233',
            image: 'https://example.com/link.png',
            name: 'Link',
            release: null,
            tail: '44556677',
            type: 'Figure',
          ),
        ],
      );

      // Act
      final domainList = listDto.toDomainList();

      // Assert
      expect(domainList.length, 2);
      expect(domainList[0].name, 'Mario');
      expect(domainList[0].releaseDate, '2014-12-06');
      expect(domainList[1].name, 'Link');
      expect(domainList[1].releaseDate, isNull);
    });
  });
}
