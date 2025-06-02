import 'package:dio/dio.dart';
import 'package:rickandmorty/models/characters_modal.dart';
import 'package:rickandmorty/models/info_model.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: 'https://rickandmortyapi.com/api/'),
  );

  Future<CharactersModel?> getCharacters({
    String? url,
    Map<String, dynamic>? args,
  }) async {
    try {
      final response = await _dio.get(
        url ?? '/character',
        queryParameters: args,
      );
      return CharactersModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        // Arama sonucu bulunamadı
        return CharactersModel(
          info: InfoModel(pages: 0, count: 0),
          characters: [],
        );
      }
      // Diğer hataları fırlat
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected Error: ${e.toString()}');
    }
  }

  Future<List<CharacterModel>> getMultipleCharacters(List<int> idList) async {
    try {
      final response = await _dio.get('/character/${idList.join(',')}');
      final data = response.data;

      if (data is List) {
        return data.map((e) => CharacterModel.fromJson(e)).toList();
      } else if (data is Map<String, dynamic>) {
        return [CharacterModel.fromJson(data)];
      } else {
        throw Exception("Unexpected response format: ${data.runtimeType}");
      }
    } catch (e) {
      rethrow;
    }
  }
}
