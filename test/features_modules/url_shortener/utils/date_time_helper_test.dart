import 'package:flutter_test/flutter_test.dart';
import 'package:url_shrtnr/features_modules/url_shortener/utils/date_time_helper.dart';

void main() {
  group('DateTimeHelper.formatRelativeTime', () {
    test('should return "Unknown" for null DateTime', () {
      // Act
      final result = DateTimeHelper.formatRelativeTime(null);

      // Assert
      expect(result, equals('Unknown'));
    });

    test('should return "Just now" for DateTime less than 1 minute ago', () {
      // Arrange
      final now = DateTime.now();
      final thirtySecondsAgo = now.subtract(const Duration(seconds: 30));

      // Act
      final result = DateTimeHelper.formatRelativeTime(thirtySecondsAgo);

      // Assert
      expect(result, equals('Just now'));
    });

    test('should return "Xm ago" for DateTime less than 1 hour ago', () {
      // Arrange
      final now = DateTime.now();
      final fiveMinutesAgo = now.subtract(const Duration(minutes: 5));

      // Act
      final result = DateTimeHelper.formatRelativeTime(fiveMinutesAgo);

      // Assert
      expect(result, equals('5m ago'));
    });

    test('should return "Xm ago" for DateTime 59 minutes ago', () {
      // Arrange
      final now = DateTime.now();
      final fiftyNineMinutesAgo = now.subtract(const Duration(minutes: 59));

      // Act
      final result = DateTimeHelper.formatRelativeTime(fiftyNineMinutesAgo);

      // Assert
      expect(result, equals('59m ago'));
    });

    test('should return "Xh ago" for DateTime less than 1 day ago', () {
      // Arrange
      final now = DateTime.now();
      final twoHoursAgo = now.subtract(const Duration(hours: 2));

      // Act
      final result = DateTimeHelper.formatRelativeTime(twoHoursAgo);

      // Assert
      expect(result, equals('2h ago'));
    });

    test('should return "Xh ago" for DateTime 23 hours ago', () {
      // Arrange
      final now = DateTime.now();
      final twentyThreeHoursAgo = now.subtract(const Duration(hours: 23));

      // Act
      final result = DateTimeHelper.formatRelativeTime(twentyThreeHoursAgo);

      // Assert
      expect(result, equals('23h ago'));
    });

    test('should return "Xd ago" for DateTime 1 day ago', () {
      // Arrange
      final now = DateTime.now();
      final oneDayAgo = now.subtract(const Duration(days: 1));

      // Act
      final result = DateTimeHelper.formatRelativeTime(oneDayAgo);

      // Assert
      expect(result, equals('1d ago'));
    });

    test('should return "Xd ago" for DateTime multiple days ago', () {
      // Arrange
      final now = DateTime.now();
      final tenDaysAgo = now.subtract(const Duration(days: 10));

      // Act
      final result = DateTimeHelper.formatRelativeTime(tenDaysAgo);

      // Assert
      expect(result, equals('10d ago'));
    });
  });
}
