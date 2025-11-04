import 'package:amiibo_explorer_app/core/data/network/amiibo_remote_data_source.dart';
import 'package:amiibo_explorer_app/core/domain/amiibo.dart';
import 'package:amiibo_explorer_app/core/domain/amiibo_repository.dart';

class AmiiboRepositoryImpl implements AmiiboRepository {
  final AmiiboRemoteDataSource _remote;

  AmiiboRepositoryImpl(this._remote);

  @override
  Future<List<Amiibo>> search({String? query}) {
    return _remote.search(query: query);
  }

  @override
  Future<Amiibo?> getById(String id) {
    return _remote.getById(id);
  }
}
