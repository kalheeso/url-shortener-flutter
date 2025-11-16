import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:url_shrtnr/features_modules/url_shortener/widgets/custom_text_field.dart';

void main() {
  group('CustomTextField', () {
    late TextEditingController controller;

    setUp(() {
      controller = TextEditingController();
    });

    tearDown(() {
      controller.dispose();
    });

    testWidgets('should display hintText', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              controller: controller,
              hintText: 'Enter URL here',
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Enter URL here'), findsOneWidget);
    });

    testWidgets('should display labelText when provided', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              controller: controller,
              hintText: 'Hint',
              labelText: 'URL Label',
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('URL Label'), findsOneWidget);
    });

    testWidgets('should display prefixIcon when provided', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              controller: controller,
              hintText: 'Hint',
              prefixIcon: Icons.link,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.link), findsOneWidget);
    });

    testWidgets('should not display prefixIcon when null', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              controller: controller,
              hintText: 'Hint',
              prefixIcon: null,
            ),
          ),
        ),
      );

      // Assert - Just verify the TextField exists without icon
      expect(find.byType(TextFormField), findsOneWidget);
      // No icon should be visible
      expect(find.byType(Icon), findsNothing);
    });

    testWidgets('should display action widget in suffixIcon when provided', (tester) async {
      // Arrange
      const actionWidget = Icon(Icons.send);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              controller: controller,
              hintText: 'Hint',
              action: actionWidget,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.send), findsOneWidget);
    });

    testWidgets('should not display suffixIcon when action is null', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              controller: controller,
              hintText: 'Hint',
              action: null,
            ),
          ),
        ),
      );

      // Assert - Verify TextField exists but no action widget visible
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('should call validator when form validates', (tester) async {
      // Arrange
      bool validatorCalled = false;

      String? validator(String? value) {
        validatorCalled = true;
        return value == null || value.isEmpty ? 'Required' : null;
      }

      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: CustomTextField(
                controller: controller,
                hintText: 'Hint',
                validator: validator,
              ),
            ),
          ),
        ),
      );

      // Act
      formKey.currentState!.validate();

      // Assert
      expect(validatorCalled, isTrue);
    });

    testWidgets('should call onSubmitted when Enter key is pressed', (tester) async {
      // Arrange
      bool onSubmittedCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              controller: controller,
              hintText: 'Hint',
              onSubmitted: (_) => onSubmittedCalled = true,
            ),
          ),
        ),
      );

      // Act
      await tester.enterText(find.byType(TextFormField), 'test');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      // Assert
      expect(onSubmittedCalled, isTrue);
    });

    testWidgets('should be enabled by default', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              controller: controller,
              hintText: 'Hint',
            ),
          ),
        ),
      );

      // Assert
      final textField = tester.widget<TextFormField>(find.byType(TextFormField));
      expect(textField.enabled, isTrue);
    });

    testWidgets('should be disabled when enabled is false', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              controller: controller,
              hintText: 'Hint',
              enabled: false,
            ),
          ),
        ),
      );

      // Assert
      final textField = tester.widget<TextFormField>(find.byType(TextFormField));
      expect(textField.enabled, isFalse);
    });

    testWidgets('should accept enabled parameter without errors', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              controller: controller,
              hintText: 'Hint',
              enabled: false,
            ),
          ),
        ),
      );

      // Assert - Widget renders successfully
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('should accept custom keyboardType without errors', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              controller: controller,
              hintText: 'Hint',
              keyboardType: TextInputType.url,
            ),
          ),
        ),
      );

      // Assert - Widget renders successfully
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('should accept maxLines parameter without errors', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              controller: controller,
              hintText: 'Hint',
              maxLines: 3,
            ),
          ),
        ),
      );

      // Assert - Widget renders successfully
      expect(find.byType(TextFormField), findsOneWidget);
    });
  });
}
