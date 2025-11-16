import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:url_shrtnr/features_modules/url_shortener/models/shortened_url.dart';
import 'package:url_shrtnr/features_modules/url_shortener/pages/url_shortener_page.dart';
import 'package:url_shrtnr/features_modules/url_shortener/services/concretes/url_shortener_service.dart';
import 'package:url_shrtnr/features_modules/url_shortener/widgets/empty_state_widget.dart';
import 'package:url_shrtnr/features_modules/url_shortener/widgets/url_list_item.dart';

class MockUrlShortenerService extends Mock implements UrlShortenerService {}

void main() {
  late MockUrlShortenerService mockService;

  setUp(() {
    mockService = MockUrlShortenerService();
  });

  Widget createTestWidget() {
    return const MaterialApp(
      home: UrlShortenerPage(),
    );
  }

  group('UrlShortenerPage - Initial State', () {
    testWidgets('should display app bar with title', (tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text('URL Shortener'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should display input field with hint text', (tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.byType(TextFormField), findsOneWidget);
      expect(
        find.text('e.g., google.com or https://example.com/page'),
        findsOneWidget,
      );
    });

    testWidgets('should display send icon button', (tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.byIcon(Icons.send), findsOneWidget);
      expect(find.byType(IconButton), findsOneWidget);
    });

    testWidgets('should display empty state initially', (tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.byType(EmptyStateWidget), findsOneWidget);
      expect(find.text('No shortened URLs yet'), findsOneWidget);
      expect(find.text('Enter a URL above to get started'), findsOneWidget);
      expect(find.byIcon(Icons.link_off), findsOneWidget);
    });

    testWidgets('should not display any URL list items initially', (tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.byType(UrlListItem), findsNothing);
      expect(find.byType(ListView), findsNothing);
    });
  });

  group('UrlShortenerPage - URL Validation', () {
    testWidgets('should show error when submitting empty URL', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());

      // Act
      await tester.tap(find.byType(TextFormField));
      await tester.pump();
      await tester.tap(find.byIcon(Icons.send));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Please enter a URL'), findsOneWidget);
    });

    testWidgets('should show error for invalid URL format', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());

      // Act
      await tester.enterText(find.byType(TextFormField), 'not a valid url');
      await tester.tap(find.byIcon(Icons.send));
      await tester.pumpAndSettle();

      // Assert
      expect(
        find.text('Please enter a valid URL (e.g., google.com or https://google.com)'),
        findsOneWidget,
      );
    });

    testWidgets('should accept URL without scheme', (tester) async {
      // Arrange
      when(() => mockService.shortenUrl(any())).thenAnswer(
        (_) async => ShortenedUrl(
          originalUrl: 'https://google.com',
          shortUrl: 'https://short.url/abc123',
        ),
      );

      await tester.pumpWidget(createTestWidget());

      // Act
      await tester.enterText(find.byType(TextFormField), 'google.com');
      await tester.tap(find.byIcon(Icons.send));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Please enter a valid URL (e.g., google.com or https://google.com)'), findsNothing);
    });

    testWidgets('should accept URL with https://', (tester) async {
      // Arrange
      when(() => mockService.shortenUrl(any())).thenAnswer(
        (_) async => ShortenedUrl(
          originalUrl: 'https://example.com',
          shortUrl: 'https://short.url/abc123',
        ),
      );

      await tester.pumpWidget(createTestWidget());

      // Act
      await tester.enterText(find.byType(TextFormField), 'https://example.com');
      await tester.tap(find.byIcon(Icons.send));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Please enter a valid URL (e.g., google.com or https://google.com)'), findsNothing);
    });
  });

  group('UrlShortenerPage - URL Shortening Flow', () {
    testWidgets(
      'CRITICAL: should show loading state and empty state correctly on initial load',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.byType(EmptyStateWidget), findsOneWidget);
        expect(find.text('No shortened URLs yet'), findsOneWidget);
        expect(find.byType(UrlListItem), findsNothing);
        expect(find.byIcon(Icons.send), findsOneWidget);
        expect(find.byType(TextFormField), findsOneWidget);
      },
    );

    testWidgets('should clear input field after successful submission', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());

      // Act
      await tester.enterText(find.byType(TextFormField), 'google.com');
      await tester.tap(find.byIcon(Icons.send));
      await tester.pump();

      // Assert
      final textField = tester.widget<TextFormField>(find.byType(TextFormField));
      expect(textField.controller?.text, isEmpty);
    });
  });

  group('UrlShortenerPage - User Interactions', () {
    testWidgets('should submit when pressing enter in text field', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());

      // Act
      await tester.enterText(find.byType(TextFormField), 'google.com');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      // Assert
      final textField = tester.widget<TextFormField>(find.byType(TextFormField));
      expect(textField.controller?.text, isEmpty);
    });

    testWidgets('should focus text field when tapped', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());

      // Act
      await tester.tap(find.byType(TextFormField));
      await tester.pump();

      // Assert
      expect(tester.testTextInput.isVisible, isTrue);
    });
  });

  group('UrlShortenerPage - Edge Cases', () {
    testWidgets('should accept very long URLs in validation', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());
      final veryLongUrl = 'https://example.com/${'a' * 500}';

      // Act
      await tester.enterText(find.byType(TextFormField), veryLongUrl);
      await tester.tap(find.byIcon(Icons.send));
      await tester.pump();

      // Assert
      expect(find.text('Please enter a valid URL (e.g., google.com or https://google.com)'), findsNothing);
    });

    testWidgets('should trim whitespace from URLs during validation', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());

      // Act
      await tester.enterText(find.byType(TextFormField), '  google.com  ');
      await tester.tap(find.byIcon(Icons.send));
      await tester.pump();

      // Assert
      expect(find.text('Please enter a valid URL (e.g., google.com or https://google.com)'), findsNothing);
    });
  });
}
