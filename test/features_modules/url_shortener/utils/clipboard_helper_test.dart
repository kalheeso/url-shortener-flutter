import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:url_shrtnr/features_modules/url_shortener/utils/clipboard_helper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ClipboardHelper.copy', () {
    test('should copy text to clipboard', () {
      // Arrange
      const testText = 'https://short.url/abc123';
      final clipboardData = <String>[];

      // Mock clipboard
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (MethodCall methodCall) async {
          if (methodCall.method == 'Clipboard.setData') {
            clipboardData.add(methodCall.arguments['text'] as String);
          }
          return null;
        },
      );

      // Act
      ClipboardHelper.copy(testText);

      // Assert
      expect(clipboardData, contains(testText));
      expect(clipboardData.length, equals(1));

      // Cleanup
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      );
    });

    test('should copy multiple different texts to clipboard', () {
      // Arrange
      const firstText = 'https://short.url/abc123';
      const secondText = 'https://short.url/xyz789';
      final clipboardData = <String>[];

      // Mock clipboard
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (MethodCall methodCall) async {
          if (methodCall.method == 'Clipboard.setData') {
            clipboardData.add(methodCall.arguments['text'] as String);
          }
          return null;
        },
      );

      // Act
      ClipboardHelper.copy(firstText);
      ClipboardHelper.copy(secondText);

      // Assert
      expect(clipboardData, containsAll([firstText, secondText]));
      expect(clipboardData.length, equals(2));

      // Cleanup
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      );
    });
  });
}
