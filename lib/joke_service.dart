import 'package:dio/dio.dart';

class JokeService {
  final String _baseUrl = 'https://v2.jokeapi.dev/joke';
  final Dio _dio = Dio();

  Future<List<String>> fetchJokesRaw() async {
    try {
      final response = await _dio.get(
        '$_baseUrl/Programming',
        queryParameters: {
          'amount': 3,
          'type': 'single',
          'blacklistFlags': 'nsfw,religious,political,racist,sexist,explicit',
        },
      );

      print(response.toString());

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch jokes');
      }

      final List<dynamic> jokesJson = response.data['jokes'];
      return jokesJson.map((joke) => joke['joke'] as String).toList();
    } catch (e) {
      throw Exception('Failed to load jokes');
    }
  }
}
