import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:url_shrtnr/features_modules/url_shortener/models/shortened_url.dart';
import 'package:url_shrtnr/features_modules/url_shortener/widgets/url_list_item.dart';

void main() {
  group('UrlListItem', () {
    late ShortenedUrl testUrl;

    setUp(() {
      testUrl = ShortenedUrl(
        originalUrl: 'https://www.example.com/very/long/url/path',
        shortUrl: 'https://short.url/abc123',
        createdAt: DateTime.now(),
      );
    });

    testWidgets('should display short URL and original URL', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UrlListItem(shortenedUrl: testUrl),
          ),
        ),
      );

      // Assert
      expect(find.text('https://short.url/abc123'), findsOneWidget);
      expect(find.text('https://www.example.com/very/long/url/path'), findsOneWidget);
    });

    testWidgets('should display link icons', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UrlListItem(shortenedUrl: testUrl),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.link), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
    });

    testWidgets('should display copy button', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UrlListItem(shortenedUrl: testUrl),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.copy), findsOneWidget);
      expect(find.byType(IconButton), findsOneWidget);
    });

    testWidgets('should show snackbar when copy button is tapped', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UrlListItem(shortenedUrl: testUrl),
          ),
        ),
      );

      // Act
      await tester.tap(find.byIcon(Icons.copy));
      await tester.pump(); // Start the snackbar animation

      // Assert
      expect(find.text('Copied to clipboard!'), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('should display "Just now" for recent timestamps', (tester) async {
      // Arrange
      final recentUrl = ShortenedUrl(
        originalUrl: 'https://example.com',
        shortUrl: 'https://short.url/xyz',
        createdAt: DateTime.now(),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UrlListItem(shortenedUrl: recentUrl),
          ),
        ),
      );

      // Assert
      expect(find.text('Just now'), findsOneWidget);
    });

    testWidgets('should display "Xm ago" for timestamps under 1 hour', (tester) async {
      // Arrange
      final minutesAgoUrl = ShortenedUrl(
        originalUrl: 'https://example.com',
        shortUrl: 'https://short.url/xyz',
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UrlListItem(shortenedUrl: minutesAgoUrl),
          ),
        ),
      );

      // Assert
      expect(find.textContaining('m ago'), findsOneWidget);
      expect(find.text('30m ago'), findsOneWidget);
    });

    testWidgets('should display "Xh ago" for timestamps under 1 day', (tester) async {
      // Arrange
      final hoursAgoUrl = ShortenedUrl(
        originalUrl: 'https://example.com',
        shortUrl: 'https://short.url/xyz',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UrlListItem(shortenedUrl: hoursAgoUrl),
          ),
        ),
      );

      // Assert
      expect(find.textContaining('h ago'), findsOneWidget);
      expect(find.text('5h ago'), findsOneWidget);
    });

    testWidgets('should display "Xd ago" for older timestamps', (tester) async {
      // Arrange
      final daysAgoUrl = ShortenedUrl(
        originalUrl: 'https://example.com',
        shortUrl: 'https://short.url/xyz',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UrlListItem(shortenedUrl: daysAgoUrl),
          ),
        ),
      );

      // Assert
      expect(find.textContaining('d ago'), findsOneWidget);
      expect(find.text('3d ago'), findsOneWidget);
    });

    testWidgets('should be wrapped in a Card widget', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UrlListItem(shortenedUrl: testUrl),
          ),
        ),
      );

      // Assert
      expect(find.byType(Card), findsOneWidget);
    });
  });
}
