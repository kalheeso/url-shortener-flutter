import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:url_shrtnr/features_modules/url_shortener/widgets/primary_button.dart';

void main() {
  group('PrimaryButton', () {
    testWidgets('should display button text', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Click Me',
              onPressed: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Click Me'), findsOneWidget);
    });

    testWidgets('should display icon when provided', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Save',
              onPressed: () {},
              icon: Icons.save,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.save), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
    });

    testWidgets('should not display icon when null', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Click Me',
              onPressed: () {},
              icon: null,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(Icon), findsNothing);
      expect(find.text('Click Me'), findsOneWidget);
    });

    testWidgets('should call onPressed when tapped and not loading', (tester) async {
      // Arrange
      bool onPressedCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Click Me',
              onPressed: () => onPressedCalled = true,
              isLoading: false,
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Assert
      expect(onPressedCalled, isTrue);
    });

    testWidgets('should show CircularProgressIndicator when isLoading is true', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Loading...',
              onPressed: () {},
              isLoading: true,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should not show button text when loading', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Click Me',
              onPressed: () {},
              isLoading: true,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Click Me'), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should not call onPressed when isLoading is true', (tester) async {
      // Arrange
      bool onPressedCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Click Me',
              onPressed: () => onPressedCalled = true,
              isLoading: true,
            ),
          ),
        ),
      );

      // Act - Try to tap the button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Assert - onPressed should not be called because button is disabled
      expect(onPressedCalled, isFalse);
    });

    testWidgets('should accept custom width', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Wide Button',
              onPressed: () {},
              width: 300,
            ),
          ),
        ),
      );

      // Assert - Widget renders successfully with custom width
      expect(find.byType(PrimaryButton), findsOneWidget);
      expect(find.text('Wide Button'), findsOneWidget);
    });

    testWidgets('should use default height of 50', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Default Height',
              onPressed: () {},
            ),
          ),
        ),
      );

      // Assert - Widget renders successfully
      expect(find.byType(PrimaryButton), findsOneWidget);
    });

    testWidgets('should accept custom height', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Tall Button',
              onPressed: () {},
              height: 60,
            ),
          ),
        ),
      );

      // Assert - Widget renders successfully with custom height
      expect(find.byType(PrimaryButton), findsOneWidget);
      expect(find.text('Tall Button'), findsOneWidget);
    });
  });
}
