import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/shortened_url.dart';
import '../services/interfaces/i_url_shortener_service.dart';
import 'url_shortener_state.dart';

class UrlShortenerCubit extends Cubit<UrlShortenerState> {
  final IUrlShortenerService _service;

  UrlShortenerCubit(this._service) : super(const UrlShortenerInitial());

  Future<void> shortenUrl(String url) async {
    try {
      emit(UrlShortenerLoading(shortenedUrls: state.shortenedUrls));

      final shortenedUrl = await _service.shortenUrl(url);

      final newShortenedUrl = shortenedUrl.copyWith(
        createdAt: DateTime.now(),
      );

      final updatedList = [newShortenedUrl, ...state.shortenedUrls];

      emit(UrlShortenerSuccess(shortenedUrls: updatedList));
    } catch (e) {
      emit(UrlShortenerError(
        shortenedUrls: state.shortenedUrls,
        message: e.toString(),
      ));
    }
  }
}
