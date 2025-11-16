import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/shortened_url.dart';
import '../interfaces/i_url_shortener_service.dart';

class UrlShortenerService implements IUrlShortenerService {
  static const String _baseUrl = 'https://url-shortener-server.onrender.com';
  static const String _apiEndpoint = '/api/alias';

  final http.Client _client;

  UrlShortenerService({http.Client? client}) : _client = client ?? http.Client();

  @override
  Future<ShortenedUrl> shortenUrl(String url) async {
    try {
      final response = await _makeApiRequest(url);
      _validateStatusCode(response);
      return _parseShortenedUrl(response);
    } catch (e) {
      throw Exception('Error shortening URL: $e');
    }
  }

  Future<http.Response> _makeApiRequest(String url) async {
    return await _client.post(
      Uri.parse('$_baseUrl$_apiEndpoint'),
      headers: {'Content-Type': 'application/json'},
      body: _buildRequestBody(url),
    );
  }

  String _buildRequestBody(String url) {
    return jsonEncode({'url': url});
  }

  void _validateStatusCode(http.Response response) {
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error shortening URL: ${response.statusCode}');
    }
  }

  ShortenedUrl _parseShortenedUrl(http.Response response) {
    final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
    return ShortenedUrl.fromJson(jsonData);
  }
}
