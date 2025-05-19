import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/character.dart';
import '../models/pagination_info.dart';

class CharacterRepository {
  final http.Client httpClient;
  final String _baseUrl = 'https://rickandmortyapi.com/api';

  CharacterRepository({required this.httpClient});

  Future<Map<String, dynamic>> fetchCharacters({int page = 1}) async {
    final response = await httpClient.get(
      Uri.parse('$_baseUrl/character/?page=$page'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final PaginationInfo info = PaginationInfo.fromJson(data['info']);
      final List<Character> characters = (data['results'] as List)
          .map((item) => Character.fromJson(item))
          .toList();

      return {
        'info': info,
        'characters': characters,
      };
    } else {
      throw Exception('Failed to load characters');
    }
  }
}
