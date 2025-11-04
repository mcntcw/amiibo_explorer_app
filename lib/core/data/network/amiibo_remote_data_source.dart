import 'dart:convert';
import 'package:amiibo_explorer_app/core/data/amiibo_dto.dart';
import 'package:amiibo_explorer_app/core/domain/amiibo_repository.dart';
import 'package:dio/dio.dart';
import 'package:amiibo_explorer_app/core/domain/amiibo.dart';

/// Remote data source backed by AmiiboAPI.
/// - Search uses /api/amiibo/?name={query}
/// - Get-by-id uses /api/amiibo/?id={head}{tail}
class AmiiboRemoteDataSource implements AmiiboRepository {
  final Dio _dio;
  // ignore: unused_field
  final String _baseUrl;

  AmiiboRemoteDataSource({
    Dio? dio,
    String baseUrl = 'https://www.amiiboapi.com',
  }) : _dio = dio ?? Dio(BaseOptions(baseUrl: baseUrl)),
       _baseUrl = baseUrl;

  @override
  Future<List<Amiibo>> search({String? query}) async {
    // Build query parameters; AmiiboAPI supports filtering by 'name'
    final params = <String, dynamic>{};
    if (query != null && query.isNotEmpty) {
      // AmiiboAPI performs a contains-like filter on 'name'
      params['name'] = query;
    }

    final res = await _dio.get('/api/amiibo/', queryParameters: params);

    final data = res.data is String ? jsonDecode(res.data as String) : res.data;
    final map = data as Map<String, dynamic>;

    final listDto = AmiiboListResponseDto.fromJson(map);
    return listDto.toDomainList();
  }

  @override
  Future<Amiibo?> getById(String id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  // @override
  // Future<Amiibo?> getById(String id) async {
  //   // Fetch a single record using id=head+tail as per docs
  //   final res = await _dio.get('/api/amiibo/', queryParameters: {'id': id});

  //   final data = res.data is String ? jsonDecode(res.data as String) : res.data;
  //   final map = data as Map<String, dynamic>;
  //   final amiiboNode = map['amiibo'];

  //   if (amiiboNode == null) return null;

  //   if (amiiboNode is Map<String, dynamic>) {
  //     // Single object shape
  //     return AmiiboDto.fromJson(amiiboNode).toDomain();
  //   }
  //   return null;
  // }
}
