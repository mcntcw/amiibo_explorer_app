import 'package:amiibo_explorer_app/core/domain/amiibo.dart';

class AmiiboDto {
  final String amiiboSeries;
  final String character;
  final String gameSeries;
  final String head;
  final String image;
  final String name;
  final Map<String, dynamic>? release; // {au, eu, jp, na} or null
  final String tail;
  final String type;

  AmiiboDto({
    required this.amiiboSeries,
    required this.character,
    required this.gameSeries,
    required this.head,
    required this.image,
    required this.name,
    required this.release,
    required this.tail,
    required this.type,
  });

  factory AmiiboDto.fromJson(Map<String, dynamic> json) {
    return AmiiboDto(
      amiiboSeries: json['amiiboSeries'] as String,
      character: json['character'] as String,
      gameSeries: json['gameSeries'] as String,
      head: json['head'] as String,
      image: json['image'] as String,
      name: json['name'] as String,
      release: json['release'] as Map<String, dynamic>?, // may be null
      tail: json['tail'] as String,
      type: json['type'] as String,
    );
  }

  Amiibo toDomain() {
    // Extract only Japanese release date; keep null if absent
    final String? jp = release != null ? release!['jp'] as String? : null;
    return Amiibo(
      amiiboSeries: amiiboSeries,
      character: character,
      gameSeries: gameSeries,
      head: head,
      image: image,
      name: name,
      tail: tail,
      type: type,
      releaseDate: jp,
    );
  }
}

/// Wrapper for list responses: { "amiibo": [ ... ] }
class AmiiboListResponseDto {
  final List<AmiiboDto> amiibo;

  AmiiboListResponseDto({required this.amiibo});

  factory AmiiboListResponseDto.fromJson(Map<String, dynamic> json) {
    final list = (json['amiibo'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();
    return AmiiboListResponseDto(
      amiibo: list.map((e) => AmiiboDto.fromJson(e)).toList(),
    );
  }

  List<Amiibo> toDomainList() => amiibo.map((e) => e.toDomain()).toList();
}
