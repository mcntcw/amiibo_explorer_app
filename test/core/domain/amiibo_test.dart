import 'package:amiibo_explorer_app/core/domain/amiibo.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Amiibo', () {
    test('should construct with required fields', () {
      // Arrange
      final amiibo = Amiibo(
        amiiboSeries: 'Super Mario',
        character: 'Mario',
        gameSeries: 'Super Mario',
        head: '00000000',
        image: 'https://example.com/mario.png',
        name: 'Mario',
        tail: '00000002',
        type: 'Figure',
        releaseDate: '2014-11-21', // nullable OK
      );

      // Assert
      expect(amiibo.amiiboSeries, 'Super Mario');
      expect(amiibo.character, 'Mario');
      expect(amiibo.gameSeries, 'Super Mario');
      expect(amiibo.head, '00000000');
      expect(amiibo.image, 'https://example.com/mario.png');
      expect(amiibo.name, 'Mario');
      expect(amiibo.tail, '00000002');
      expect(amiibo.type, 'Figure');
      expect(amiibo.releaseDate, '2014-11-21');
    });

    test('should allow null releaseDate', () {
      final amiibo = Amiibo(
        amiiboSeries: 'Legend of Zelda',
        character: 'Link',
        gameSeries: 'Zelda',
        head: '00112233',
        image: 'https://example.com/link.png',
        name: 'Link',
        tail: '44556677',
        type: 'Figure',
        releaseDate: null, // explicitly null
      );

      expect(amiibo.releaseDate, isNull);
    });
  });
}
