import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:url_shrtnr/features_modules/url_shortener/models/shortened_url.dart';
import 'package:url_shrtnr/features_modules/url_shortener/services/concretes/url_shortener_service.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late UrlShortenerService service;
  late MockHttpClient mockHttpClient;

  setUpAll(() {
    registerFallbackValue(Uri.parse('https://example.com'));
  });

  setUp(() {
    mockHttpClient = MockHttpClient();
    service = UrlShortenerService(client: mockHttpClient);
  });

  group('UrlShortenerService.shortenUrl', () {
    const testUrl = 'https://www.example.com/long/url';
    const shortUrl = 'https://url-shortener-server.onrender.com/api/alias/839370780';
    const alias = '839370780';
    final expectedUri = Uri.parse('https://url-shortener-server.onrender.com/api/alias');

    test('should return ShortenedUrl on successful API call (status 200)', () async {
      // Arrange
      final responseBody = jsonEncode({
        'alias': alias,
        '_links': {
          'self': testUrl,
          'short': shortUrl,
        }
      });
      when(() => mockHttpClient.post(
            expectedUri,
            headers: {'Content-Type': 'application/json'},
            body: any(named: 'body'),
          )).thenAnswer(
        (_) async => http.Response(responseBody, 200),
      );

      // Act
      final result = await service.shortenUrl(testUrl);

      // Assert
      expect(result, isA<ShortenedUrl>());
      expect(result.originalUrl, equals(testUrl));
      expect(result.shortUrl, equals(shortUrl));
      expect(result.createdAt, isNull);
      verify(() => mockHttpClient.post(
            expectedUri,
            headers: {'Content-Type': 'application/json'},
            body: any(named: 'body'),
          )).called(1);
    });

    test('should return ShortenedUrl on successful API call (status 201)', () async {
      // Arrange
      final responseBody = jsonEncode({
        'alias': alias,
        '_links': {
          'self': testUrl,
          'short': shortUrl,
        }
      });
      when(() => mockHttpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenAnswer(
        (_) async => http.Response(responseBody, 201),
      );

      // Act
      final result = await service.shortenUrl(testUrl);

      // Assert
      expect(result, isA<ShortenedUrl>());
      expect(result.originalUrl, equals(testUrl));
      expect(result.shortUrl, equals(shortUrl));
      expect(result.createdAt, isNull);
    });

    test('should use _links.self as fallback for shortUrl if _links.short is missing', () async {
      // Arrange
      final responseBody = jsonEncode({
        'alias': alias,
        '_links': {
          'self': testUrl,
        }
      });
      when(() => mockHttpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenAnswer(
        (_) async => http.Response(responseBody, 200),
      );

      // Act
      final result = await service.shortenUrl(testUrl);

      // Assert
      expect(result, isA<ShortenedUrl>());
      expect(result.originalUrl, equals(testUrl));
      expect(result.shortUrl, equals(testUrl)); // Falls back to self
      expect(result.createdAt, isNull);
    });

    test('should throw exception if _links object is missing', () async {
      // Arrange
      final responseBody = jsonEncode({'alias': alias});
      when(() => mockHttpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenAnswer(
        (_) async => http.Response(responseBody, 200),
      );

      // Act & Assert
      expect(
        () => service.shortenUrl(testUrl),
        throwsA(isA<Exception>()),
      );
    });

    test('should throw exception on 4xx status code', () async {
      // Arrange
      when(() => mockHttpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenAnswer(
        (_) async => http.Response('Bad Request', 400),
      );

      // Act & Assert
      expect(
        () => service.shortenUrl(testUrl),
        throwsA(isA<Exception>()),
      );
    });

    test('should throw exception on 5xx status code', () async {
      // Arrange
      when(() => mockHttpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenAnswer(
        (_) async => http.Response('Internal Server Error', 500),
      );

      // Act & Assert
      expect(
        () => service.shortenUrl(testUrl),
        throwsA(isA<Exception>()),
      );
    });

    test('should throw exception on network error', () async {
      // Arrange
      when(() => mockHttpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenThrow(Exception('Network error'));

      // Act & Assert
      expect(
        () => service.shortenUrl(testUrl),
        throwsA(isA<Exception>()),
      );
    });
  });
}
