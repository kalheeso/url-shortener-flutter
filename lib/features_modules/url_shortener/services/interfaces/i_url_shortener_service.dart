import '../../models/shortened_url.dart';

abstract class IUrlShortenerService {
  Future<ShortenedUrl> shortenUrl(String url);
}
