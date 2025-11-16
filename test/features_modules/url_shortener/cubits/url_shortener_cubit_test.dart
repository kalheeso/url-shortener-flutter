import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:url_shrtnr/features_modules/url_shortener/cubits/url_shortener_cubit.dart';
import 'package:url_shrtnr/features_modules/url_shortener/cubits/url_shortener_state.dart';
import 'package:url_shrtnr/features_modules/url_shortener/models/shortened_url.dart';
import 'package:url_shrtnr/features_modules/url_shortener/services/interfaces/i_url_shortener_service.dart';

class MockUrlShortenerService extends Mock implements IUrlShortenerService {}

void main() {
  late IUrlShortenerService mockService;

  setUp(() {
    mockService = MockUrlShortenerService();
  });

  group('UrlShortenerCubit', () {
    test('initial state is UrlShortenerInitial', () {
      // Arrange & Act
      final cubit = UrlShortenerCubit(mockService);

      // Assert
      expect(cubit.state, const UrlShortenerInitial());
    });

    blocTest<UrlShortenerCubit, UrlShortenerState>(
      'emits [Loading, Success] when shortenUrl succeeds',
      build: () {
        when(() => mockService.shortenUrl(any())).thenAnswer(
          (_) async => ShortenedUrl(
            originalUrl: 'https://example.com',
            shortUrl: 'https://short.url/abc123',
          ),
        );
        return UrlShortenerCubit(mockService);
      },
      act: (cubit) => cubit.shortenUrl('https://example.com'),
      expect: () => [
        const UrlShortenerLoading(shortenedUrls: []),
        isA<UrlShortenerSuccess>()
            .having((s) => s.shortenedUrls.length, 'urls count', 1)
            .having(
              (s) => s.shortenedUrls.first.originalUrl,
              'original url',
              'https://example.com',
            )
            .having(
              (s) => s.shortenedUrls.first.shortUrl,
              'short url',
              'https://short.url/abc123',
            ),
      ],
      verify: (_) {
        verify(() => mockService.shortenUrl('https://example.com')).called(1);
      },
    );

    blocTest<UrlShortenerCubit, UrlShortenerState>(
      'emits [Loading, Error] when shortenUrl fails',
      build: () {
        when(() => mockService.shortenUrl(any())).thenThrow(Exception('Network error'));
        return UrlShortenerCubit(mockService);
      },
      act: (cubit) => cubit.shortenUrl('https://example.com'),
      expect: () => [
        const UrlShortenerLoading(shortenedUrls: []),
        isA<UrlShortenerError>()
            .having((s) => s.message, 'error message', contains('Exception'))
            .having((s) => s.shortenedUrls, 'urls', isEmpty),
      ],
    );

    blocTest<UrlShortenerCubit, UrlShortenerState>(
      'adds new shortened URL to the beginning of the list',
      build: () {
        when(() => mockService.shortenUrl(any())).thenAnswer(
          (invocation) async {
            final url = invocation.positionalArguments[0] as String;
            return ShortenedUrl(
              originalUrl: url,
              shortUrl: 'https://short.url/${url.hashCode}',
            );
          },
        );
        return UrlShortenerCubit(mockService);
      },
      act: (cubit) async {
        await cubit.shortenUrl('https://first.com');
        await cubit.shortenUrl('https://second.com');
        await cubit.shortenUrl('https://third.com');
      },
      expect: () => [
        // First URL
        const UrlShortenerLoading(shortenedUrls: []),
        isA<UrlShortenerSuccess>().having((s) => s.shortenedUrls.length, 'count', 1),
        // Second URL
        isA<UrlShortenerLoading>().having((s) => s.shortenedUrls.length, 'count', 1),
        isA<UrlShortenerSuccess>().having((s) => s.shortenedUrls.length, 'count', 2).having(
              (s) => s.shortenedUrls.first.originalUrl,
              'latest url is first',
              'https://second.com',
            ),
        // Third URL
        isA<UrlShortenerLoading>().having((s) => s.shortenedUrls.length, 'count', 2),
        isA<UrlShortenerSuccess>().having((s) => s.shortenedUrls.length, 'count', 3).having(
              (s) => s.shortenedUrls.first.originalUrl,
              'latest url is first',
              'https://third.com',
            ),
      ],
    );

    blocTest<UrlShortenerCubit, UrlShortenerState>(
      'preserves existing URLs when an error occurs',
      build: () {
        int callCount = 0;
        when(() => mockService.shortenUrl(any())).thenAnswer((invocation) async {
          callCount++;
          if (callCount == 1) {
            return ShortenedUrl(
              originalUrl: 'https://first.com',
              shortUrl: 'https://short.url/success',
            );
          } else {
            throw Exception('Network error');
          }
        });
        return UrlShortenerCubit(mockService);
      },
      act: (cubit) async {
        await cubit.shortenUrl('https://first.com');
        await cubit.shortenUrl('https://second.com');
      },
      expect: () => [
        // First URL succeeds
        const UrlShortenerLoading(shortenedUrls: []),
        isA<UrlShortenerSuccess>().having((s) => s.shortenedUrls.length, 'count', 1),
        // Second URL fails but preserves first
        isA<UrlShortenerLoading>().having((s) => s.shortenedUrls.length, 'count', 1),
        isA<UrlShortenerError>().having((s) => s.shortenedUrls.length, 'count', 1).having(
              (s) => s.shortenedUrls.first.originalUrl,
              'preserves first url',
              'https://first.com',
            ),
      ],
    );

    blocTest<UrlShortenerCubit, UrlShortenerState>(
      'shortened URL has correct timestamp',
      build: () {
        when(() => mockService.shortenUrl(any())).thenAnswer(
          (_) async => ShortenedUrl(
            originalUrl: 'https://example.com',
            shortUrl: 'https://short.url/abc123',
          ),
        );
        return UrlShortenerCubit(mockService);
      },
      act: (cubit) => cubit.shortenUrl('https://example.com'),
      verify: (cubit) {
        final state = cubit.state as UrlShortenerSuccess;
        final shortenedUrl = state.shortenedUrls.first;
        final now = DateTime.now();
        final createdAt = shortenedUrl.createdAt;

        // createdAt should be set by the cubit
        expect(createdAt, isNotNull);
        final difference = now.difference(createdAt!);

        // Timestamp should be within the last second
        expect(difference.inSeconds, lessThan(2));
      },
    );
  });
}
