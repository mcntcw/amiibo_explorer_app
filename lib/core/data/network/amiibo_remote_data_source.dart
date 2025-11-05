import 'dart:convert';
import 'package:amiibo_explorer_app/core/data/amiibo_dto.dart';
import 'package:amiibo_explorer_app/core/domain/amiibo_repository.dart';
import 'package:dio/dio.dart';
import 'package:amiibo_explorer_app/core/domain/amiibo.dart';

/// Remote data source backed by AmiiboAPI
/// Search uses /api/amiibo/?name={query}
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
    final params = <String, dynamic>{};
    if (query != null && query.isNotEmpty) {
      params['name'] = query;
    }

    final res = await _dio.get('/api/amiibo/', queryParameters: params);

    final data = res.data is String ? jsonDecode(res.data as String) : res.data;
    final map = data as Map<String, dynamic>;

    final listDto = AmiiboListResponseDto.fromJson(map);
    return listDto.toDomainList();
  }
}
