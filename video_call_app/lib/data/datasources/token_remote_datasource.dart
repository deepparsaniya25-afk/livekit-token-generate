import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/config/app_config.dart';

class TokenRemoteDataSource {
  const TokenRemoteDataSource();

  Future<String> fetchToken({
    required String roomId,
    required String userName,
  }) async {
    final uri = Uri.parse('${AppConfig.tokenServerUrl}/token').replace(
      queryParameters: {
        'room': roomId,
        'identity': userName,
      },
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch token: ${response.body}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final token = data['token'] as String?;

    if (token == null || token.isEmpty) {
      throw Exception('Token server returned an empty token');
    }

    return token;
  }
}
