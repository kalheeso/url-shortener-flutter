/// Utility class for URL operations.
///
/// This class provides static methods for URL validation, normalization,
/// and form validation throughout the URL Shortener feature.
class UrlHelper {
  // Private constructor to prevent instantiation
  UrlHelper._();

  /// Normalizes the URL by adding https:// if user did not write it
  static String normalizeUrl(String url) {
    String trimmedUrl = url.trim();

    if (trimmedUrl.startsWith('http://') || trimmedUrl.startsWith('https://')) {
      return trimmedUrl;
    }

    return 'https://$trimmedUrl';
  }

  /// Checks if a URL is valid.
  ///
  /// Returns `true` if the URL has a valid format, `false` otherwise.
  /// URLs can be provided with or without scheme (http/https).
  static bool isValidUrl(String url) {
    if (url.isEmpty) {
      return false;
    }

    String urlToValidate = normalizeUrl(url);

    try {
      final uri = Uri.parse(urlToValidate);

      // Must have a valid scheme and host
      if (!uri.hasScheme || uri.host.isEmpty) {
        return false;
      }

      // Host should have at least one dot (domain.tld) or be localhost
      if (!uri.host.contains('.') && uri.host != 'localhost') {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Validates a URL for use in Flutter forms.
  ///
  /// This method returns an error message string if validation fails,
  /// or `null` if the URL is valid. It matches the Flutter
  /// `FormFieldValidator<String>` signature.
  ///
  /// Returns:
  /// - `null` if the URL is valid
  /// - 'Please enter a URL' if the value is null or empty
  /// - 'Please enter a valid URL (e.g., google.com or https://google.com)' if format is invalid
  ///
  /// Example:
  /// ```dart
  /// TextFormField(
  ///   validator: UrlHelper.validateUrl,
  /// )
  /// ```
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a URL';
    }

    if (!isValidUrl(value.trim())) {
      return 'Please enter a valid URL (e.g., google.com or https://google.com)';
    }

    return null;
  }
}
