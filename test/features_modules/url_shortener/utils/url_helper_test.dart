import 'package:flutter_test/flutter_test.dart';
import 'package:url_shrtnr/features_modules/url_shortener/utils/url_helper.dart';

void main() {
  group('UrlHelper.normalizeUrl', () {
    test('should add https:// to URL without scheme', () {
      expect(
        UrlHelper.normalizeUrl('google.com'),
        equals('https://google.com'),
      );
    });

    test('should add https:// to URL with www but no scheme', () {
      expect(
        UrlHelper.normalizeUrl('www.google.com'),
        equals('https://www.google.com'),
      );
    });

    test('should not modify URL that already has https://', () {
      expect(
        UrlHelper.normalizeUrl('https://google.com'),
        equals('https://google.com'),
      );
    });

    test('should not modify URL that already has http://', () {
      expect(
        UrlHelper.normalizeUrl('http://google.com'),
        equals('http://google.com'),
      );
    });

    test('should handle URLs with paths', () {
      expect(
        UrlHelper.normalizeUrl('google.com/path/to/page'),
        equals('https://google.com/path/to/page'),
      );
    });

    test('should trim whitespace before normalizing', () {
      expect(
        UrlHelper.normalizeUrl('  google.com  '),
        equals('https://google.com'),
      );
    });
  });

  group('UrlHelper.isValidUrl', () {
    test('should return true for valid domain without scheme', () {
      expect(UrlHelper.isValidUrl('google.com'), isTrue);
    });

    test('should return true for valid domain with www', () {
      expect(UrlHelper.isValidUrl('www.google.com'), isTrue);
    });

    test('should return true for valid URL with https://', () {
      expect(UrlHelper.isValidUrl('https://google.com'), isTrue);
    });

    test('should return true for valid URL with http://', () {
      expect(UrlHelper.isValidUrl('http://google.com'), isTrue);
    });

    test('should return true for URL with path', () {
      expect(UrlHelper.isValidUrl('google.com/path'), isTrue);
    });

    test('should return true for URL with query params', () {
      expect(UrlHelper.isValidUrl('google.com/search?q=test'), isTrue);
    });

    test('should return true for localhost', () {
      expect(UrlHelper.isValidUrl('localhost'), isTrue);
    });

    test('should return false for empty string', () {
      expect(UrlHelper.isValidUrl(''), isFalse);
    });

    test('should return false for string without domain extension', () {
      expect(UrlHelper.isValidUrl('justtext'), isFalse);
    });

    test('should return false for invalid format', () {
      expect(UrlHelper.isValidUrl('not a url'), isFalse);
    });

    test('should handle whitespace', () {
      expect(UrlHelper.isValidUrl('  google.com  '), isTrue);
    });
  });

  group('UrlHelper.validateUrl', () {
    test('should return null for valid URL without scheme', () {
      expect(UrlHelper.validateUrl('google.com'), isNull);
    });

    test('should return null for valid URL with https://', () {
      expect(UrlHelper.validateUrl('https://example.com'), isNull);
    });

    test('should return null for valid URL with http://', () {
      expect(UrlHelper.validateUrl('http://example.com'), isNull);
    });

    test('should return null for valid URL with path', () {
      expect(UrlHelper.validateUrl('google.com/path/to/page'), isNull);
    });

    test('should return null for valid URL with www', () {
      expect(UrlHelper.validateUrl('www.example.com'), isNull);
    });

    test('should return null for localhost', () {
      expect(UrlHelper.validateUrl('localhost'), isNull);
    });

    test('should return error message for null value', () {
      expect(
        UrlHelper.validateUrl(null),
        equals('Please enter a URL'),
      );
    });

    test('should return error message for empty string', () {
      expect(
        UrlHelper.validateUrl(''),
        equals('Please enter a URL'),
      );
    });

    test('should return error message for invalid URL format', () {
      expect(
        UrlHelper.validateUrl('not a valid url'),
        equals('Please enter a valid URL (e.g., google.com or https://google.com)'),
      );
    });

    test('should return error message for string without domain extension', () {
      expect(
        UrlHelper.validateUrl('justtext'),
        equals('Please enter a valid URL (e.g., google.com or https://google.com)'),
      );
    });

    test('should trim whitespace before validating', () {
      expect(UrlHelper.validateUrl('  google.com  '), isNull);
    });
  });
}
