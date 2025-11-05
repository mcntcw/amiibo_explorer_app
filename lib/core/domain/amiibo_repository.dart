import 'package:amiibo_explorer_app/core/domain/amiibo.dart';

abstract class AmiiboRepository {
  // Search supports the main filters provided by the API; pass null to ignore
  Future<List<Amiibo>> search({String? query});
}
