import 'package:amiibo_explorer_app/core/domain/amiibo.dart';

abstract class AmiiboRepository {
  Future<List<Amiibo>> search({String? query});
}
