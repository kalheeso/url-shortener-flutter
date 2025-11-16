import 'package:equatable/equatable.dart';
import '../models/shortened_url.dart';

abstract class UrlShortenerState extends Equatable {
  final List<ShortenedUrl> shortenedUrls;

  const UrlShortenerState({required this.shortenedUrls});

  @override
  List<Object?> get props => [shortenedUrls];
}

class UrlShortenerInitial extends UrlShortenerState {
  const UrlShortenerInitial() : super(shortenedUrls: const []);
}

class UrlShortenerLoading extends UrlShortenerState {
  const UrlShortenerLoading({required super.shortenedUrls});
}

class UrlShortenerSuccess extends UrlShortenerState {
  const UrlShortenerSuccess({required super.shortenedUrls});
}

class UrlShortenerError extends UrlShortenerState {
  final String message;

  const UrlShortenerError({
    required super.shortenedUrls,
    required this.message,
  });

  @override
  List<Object?> get props => [shortenedUrls, message];
}
