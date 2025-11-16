import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:url_shrtnr/features_modules/url_shortener/widgets/url_input_section.dart';
import 'package:url_shrtnr/features_modules/url_shortener/widgets/custom_text_field.dart';

void main() {
  group('UrlInputSection', () {
    late TextEditingController controller;
    late GlobalKey<FormState> formKey;
    late bool onSubmitCalled;

    setUp(() {
      controller = TextEditingController();
      formKey = GlobalKey<FormState>();
      onSubmitCalled = false;
    });

    tearDown(() {
      controller.dispose();
    });

    testWidgets('should render CustomTextField with correct props', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UrlInputSection(
              controller: controller,
              formKey: formKey,
              onSubmit: () {},
              isLoading: false,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(CustomTextField), findsOneWidget);
      expect(find.text('e.g., google.com or https://example.com/page'), findsOneWidget);
      expect(find.text('URL to shorten'), findsOneWidget);
      expect(find.byIcon(Icons.link), findsOneWidget);
    });

    testWidgets('should disable input when isLoading is true', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UrlInputSection(
              controller: controller,
              formKey: formKey,
              onSubmit: () {},
              isLoading: true,
            ),
          ),
        ),
      );

      // Assert
      final textField = tester.widget<TextFormField>(find.byType(TextFormField));
      expect(textField.enabled, isFalse);
    });

    testWidgets('should enable input when isLoading is false', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UrlInputSection(
              controller: controller,
              formKey: formKey,
              onSubmit: () {},
              isLoading: false,
            ),
          ),
        ),
      );

      // Assert
      final textField = tester.widget<TextFormField>(find.byType(TextFormField));
      expect(textField.enabled, isTrue);
    });

    testWidgets('should show CircularProgressIndicator in suffixIcon when loading', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UrlInputSection(
              controller: controller,
              formKey: formKey,
              onSubmit: () {},
              isLoading: true,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(IconButton), findsNothing);
    });

    testWidgets('should show IconButton in suffixIcon when not loading', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UrlInputSection(
              controller: controller,
              formKey: formKey,
              onSubmit: () {},
              isLoading: false,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(IconButton), findsOneWidget);
      expect(find.byIcon(Icons.send), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('should call onSubmit when IconButton is pressed', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UrlInputSection(
              controller: controller,
              formKey: formKey,
              onSubmit: () => onSubmitCalled = true,
              isLoading: false,
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byIcon(Icons.send));
      await tester.pump();

      // Assert
      expect(onSubmitCalled, isTrue);
    });

    testWidgets('should call onSubmit when pressing Enter in text field', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UrlInputSection(
              controller: controller,
              formKey: formKey,
              onSubmit: () => onSubmitCalled = true,
              isLoading: false,
            ),
          ),
        ),
      );

      // Act
      await tester.enterText(find.byType(TextFormField), 'google.com');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      // Assert
      expect(onSubmitCalled, isTrue);
    });

    testWidgets('should display validation error for empty URL', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UrlInputSection(
              controller: controller,
              formKey: formKey,
              onSubmit: () {},
              isLoading: false,
            ),
          ),
        ),
      );

      // Act - Trigger validation by entering and removing text
      await tester.enterText(find.byType(TextFormField), '');
      formKey.currentState!.validate();
      await tester.pump();

      // Assert
      expect(find.text('Please enter a URL'), findsOneWidget);
    });

    testWidgets('should display validation error for invalid URL format', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UrlInputSection(
              controller: controller,
              formKey: formKey,
              onSubmit: () {},
              isLoading: false,
            ),
          ),
        ),
      );

      // Act - Enter invalid URL and validate
      await tester.enterText(find.byType(TextFormField), 'not a valid url');
      formKey.currentState!.validate();
      await tester.pump();

      // Assert
      expect(find.text('Please enter a valid URL (e.g., google.com or https://google.com)'), findsOneWidget);
    });

    testWidgets('should not display validation error for valid URL', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UrlInputSection(
              controller: controller,
              formKey: formKey,
              onSubmit: () {},
              isLoading: false,
            ),
          ),
        ),
      );

      // Act - Enter valid URL and validate
      await tester.enterText(find.byType(TextFormField), 'google.com');
      final isValid = formKey.currentState!.validate();
      await tester.pump();

      // Assert
      expect(isValid, isTrue);
      expect(find.text('Please enter a URL'), findsNothing);
      expect(find.text('Please enter a valid URL (e.g., google.com or https://google.com)'), findsNothing);
    });
  });
}
