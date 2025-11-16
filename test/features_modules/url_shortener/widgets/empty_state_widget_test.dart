import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:url_shrtnr/features_modules/url_shortener/widgets/empty_state_widget.dart';

void main() {
  group('EmptyStateWidget', () {
    testWidgets('should display icon, title, and subtitle', (tester) async {
      // Arrange
      const icon = Icons.link_off;
      const title = 'No items found';
      const subtitle = 'Add some items to get started';

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              icon: icon,
              title: title,
              subtitle: subtitle,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(icon), findsOneWidget);
      expect(find.text(title), findsOneWidget);
      expect(find.text(subtitle), findsOneWidget);
    });

    testWidgets('should display icon with correct size and color', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              icon: Icons.error_outline,
              title: 'Error',
              subtitle: 'Something went wrong',
            ),
          ),
        ),
      );

      // Assert
      final iconWidget = tester.widget<Icon>(find.byIcon(Icons.error_outline));
      expect(iconWidget.size, 64);
      expect(iconWidget.color, isA<Color>());
    });

    testWidgets('should center all content', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: EmptyStateWidget(
            icon: Icons.inbox,
            title: 'Empty',
            subtitle: 'Nothing here',
          ),
        ),
      );

      // Assert - Verify Column is centered
      final column = find.byType(Column);
      expect(column, findsOneWidget);

      final columnWidget = tester.widget<Column>(column);
      expect(columnWidget.mainAxisAlignment, MainAxisAlignment.center);
    });

    testWidgets('should display different icons for different states', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              icon: Icons.search,
              title: 'No results',
              subtitle: 'Try a different search',
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.search), findsOneWidget);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              icon: Icons.folder_open,
              title: 'Empty folder',
              subtitle: 'Add files to this folder',
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.folder_open), findsOneWidget);
      expect(find.byIcon(Icons.search), findsNothing);
    });
  });
}
