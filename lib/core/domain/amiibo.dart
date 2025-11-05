import 'package:equatable/equatable.dart';

class Amiibo extends Equatable {
  final String amiiboSeries;
  final String character;
  final String gameSeries;
  final String head;
  final String image;
  final String name;
  final String tail;
  final String type;
  final String? releaseDate;

  const Amiibo({
    required this.amiiboSeries,
    required this.character,
    required this.gameSeries,
    required this.head,
    required this.image,
    required this.name,
    required this.tail,
    required this.type,
    required this.releaseDate,
  });

  @override
  List<Object?> get props => [
    amiiboSeries,
    character,
    gameSeries,
    head,
    image,
    name,
    tail,
    type,
    releaseDate,
  ];
}
