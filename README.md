# URL Shortener

A modern, single-page Flutter application for shortening URLs with a clean architecture and comprehensive test coverage.

![Flutter](https://img.shields.io/badge/Flutter-3.6.2-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.6.2-0175C2?logo=dart)
![Tests](https://img.shields.io/badge/Tests-112%20passing-success)
![Coverage](https://img.shields.io/badge/Coverage-High-brightgreen)

## 🎯 What It Does

This app allows users to:
- Enter any URL (with or without `http://`, `https://`, or `www`)
- Shorten it using a real URL shortening API
- View all shortened URLs from the current session
- Copy shortened URLs to clipboard with a single tap
- See relative timestamps for each shortened URL (e.g., "2m ago", "5h ago")

## 🏗️ Architecture

### Clean Architecture with Feature-Based Structure

```
lib/
├── features_modules/
│   └── url_shortener/
│       ├── cubits/           # State management (BLoC pattern)
│       ├── models/           # Data models
│       ├── pages/            # UI screens
│       ├── services/         # Business logic & API calls
│       ├── utils/            # Helper functions
│       └── widgets/          # Reusable UI components
└── main.dart                 # App entry point
```

### Key Architectural Patterns

#### 1. **Feature-Based Modularity**
Each feature is self-contained with its own:
- State management (Cubit)
- UI components (Pages & Widgets)
- Business logic (Services)
- Data models
- Utilities

#### 2. **BLoC/Cubit Pattern**
State management using the BLoC pattern with Cubit for simplicity:
- **UrlShortenerCubit**: Manages URL shortening state
- **States**: Initial, Loading, Success, Error
- Preserves URL history across operations

#### 3. **Dependency Injection**
Services are injected into Cubits and can be mocked for testing:
```dart
UrlShortenerService(client: http.Client())
UrlShortenerCubit(service)
```

#### 4. **Repository Pattern**
Service layer abstracts API calls from business logic:
- **UrlShortenerService**: Handles HTTP requests
- Type-safe request/response models
- Centralized error handling

## 🛠️ Technologies & Libraries

### Core Dependencies
| Library | Purpose | Version |
|---------|---------|---------|
| **flutter_bloc** | State management using BLoC/Cubit pattern | ^9.1.1 |
| **equatable** | Value equality for state objects | ^2.0.5 |
| **http** | HTTP client for API requests | ^1.2.0 |
| **cupertino_icons** | iOS-style icons for Flutter | ^1.0.8 |

### Dev Dependencies
| Library | Purpose | Version |
|---------|---------|---------|
| **flutter_test** | Flutter testing framework | SDK |
| **bloc_test** | Testing utilities for BLoC/Cubit | ^10.0.0 |
| **mocktail** | Mocking framework for tests | ^1.0.4 |
| **flutter_lints** | Linting rules for Dart/Flutter | ^5.0.0 |

## 🎨 Features

### Smart URL Handling
- **Flexible Input**: Accepts URLs with or without schemes
  - `google.com` → `https://google.com`
  - `www.example.com` → `https://www.example.com`
  - `https://site.com` → Used as-is
- **Automatic Normalization**: Adds `https://` to URLs without a scheme
- **Validation**: Client-side URL format validation

### User Experience
- **Real-time Validation**: Instant feedback on invalid URLs
- **Loading States**: Visual feedback during API calls
- **Success/Error Notifications**: SnackBar messages for user actions
- **Copy to Clipboard**: One-tap copy of shortened URLs
- **Relative Timestamps**: Human-readable timestamps (Just now, 5m ago, 2h ago, 3d ago)

### Session Management
- **In-Memory History**: All shortened URLs persist during the app session
- **Newest First**: Latest URLs appear at the top of the list
- **Empty State**: Helpful message when no URLs have been shortened

## 📁 Project Structure

### Models
```dart
ShortenedUrl          # Domain model for shortened URLs
- originalUrl: String
- shortUrl: String  
- createdAt: DateTime?
- fromJson(Map) factory constructor
```

### State Management
```dart
UrlShortenerState     # Base state class
UrlShortenerInitial   # Initial state
UrlShortenerLoading   # Loading state (preserves existing URLs)
UrlShortenerSuccess   # Success state with updated URL list
UrlShortenerError     # Error state with error message
```

### Services
```dart
IUrlShortenerService      # Service interface (abstraction)
UrlShortenerService       # Concrete API integration service
- shortenUrl(String) → Future<ShortenedUrl>
- Uses: https://url-shortener-server.onrender.com/api/alias
```

### Utilities
```dart
UrlHelper
- normalizeUrl(String) → String       # Adds https:// if needed
- isValidUrl(String) → bool           # Validates URL format

ClipboardHelper
- copy(String) → void                 # Copies text to clipboard

DateTimeHelper  
- formatRelativeTime(DateTime?) → String  # Formats timestamps (Just now, 5m ago, etc.)
```

### Reusable Widgets
```dart
CustomTextField       # Styled text input with validation
PrimaryButton         # Loading-aware button component
EmptyStateWidget      # Generic empty state component
UrlListItem          # URL display with copy functionality
UrlInputSection      # Form section with input & submit
```

## 🧪 Testing

Comprehensive test coverage across all layers:

### Test Statistics
- **Total Tests**: 112
- **Test Files**: 11
- **Success Rate**: 100%

### Test Categories

#### Unit Tests
**UrlShortenerCubit Tests** (14 tests)
- Initial state verification
- State transitions (Initial → Loading → Success/Error)
- URL list management (order, preservation)
- Error state handling
- Timestamp verification

**UrlHelper Tests** (29 tests)
- URL normalization (adding https://)
- URL validation (with/without schemes)
- Form validation with error messages
- Edge cases (whitespace, empty strings, invalid formats)

**DateTimeHelper Tests** (2 tests)
- Relative time formatting (Just now, Xm ago, Xh ago, Xd ago)
- Null handling

**ClipboardHelper Tests** (2 tests)
- Copy text to clipboard functionality
- Multiple copy operations

**UrlShortenerService Tests** (7 tests)
- Successful API calls (200, 201 status codes)
- Response parsing with fromJson
- Error handling (4xx, 5xx, network errors)

#### Widget Tests
**EmptyStateWidget Tests** (5 tests)
- Icon, title, subtitle rendering
- Layout and styling

**PrimaryButton Tests** (7 tests)
- Button text display
- Loading state handling
- onPressed callback functionality
- Disabled state when loading

**CustomTextField Tests** (10 tests)
- Hint text display
- Input handling
- Validation display
- TextEditingController integration
- Focus management

**UrlListItem Tests** (17 tests)
- URL display (short and original)
- Copy to clipboard functionality
- Timestamp formatting (Just now, Xm ago, Xh ago, Xd ago)
- SnackBar display on copy
- Card widget styling
- Icon display (link, arrow, copy)

**UrlInputSection Tests** (11 tests)
- CustomTextField rendering
- PrimaryButton rendering
- onSubmit callback
- Loading state propagation
- Form layout

#### Integration Tests
**UrlShortenerPage Tests** (8 tests)
- Initial state verification
- URL validation (empty, invalid, with/without schemes)
- User interactions (submit, enter key, focus)
- Empty state display
- Success state with URL list

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/features_modules/url_shortener/cubits/url_shortener_cubit_test.dart

# Run with coverage
flutter test --coverage

# Run tests in a specific directory
flutter test test/features_modules/url_shortener/widgets/
```

### Test Structure
```
test/
├── features_modules/
│   └── url_shortener/
│       ├── cubits/          # Cubit unit tests
│       ├── models/          # Model tests
│       ├── pages/           # Integration tests
│       ├── services/        # Service unit tests
│       ├── utils/           # Utility tests
│       └── widgets/         # Widget tests
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.6.2 or higher
- Dart SDK 3.6.2 or higher

### Installation

1. **Clone the repository**
```bash
git clone <repository-url>
cd url_shrtnr
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the app**
```bash
flutter run
```

### Available Platforms
This project supports the following platforms:
- ✅ **Android** - Mobile app for Android devices
- ✅ **iOS** - Mobile app for iOS devices (iPhone/iPad)
- ✅ **Web** - Browser-based application

## 🎯 API Integration

### Endpoint
```
POST https://url-shortener-server.onrender.com/api/alias
```

### Request
```json
{
  "url": "https://example.com/long/url"
}
```

### Response
```json
{
  "shortUrl": "https://short.url/abc123"
}
```

The service supports multiple response field names (`shortUrl`, `alias`, `url`) for flexibility.

## 🏛️ Design Decisions

### State Management: Why BLoC/Cubit?
- **Separation of Concerns**: Business logic separate from UI
- **Testability**: Easy to unit test state transitions
- **Predictable State**: Clear state flow (Initial → Loading → Success/Error)
- **Reactive UI**: Automatic UI updates on state changes

### Why Feature-Based Architecture?
- **Scalability**: Easy to add new features without affecting existing ones
- **Maintainability**: Related code is co-located
- **Reusability**: Widgets can be reused across features
- **Team Collaboration**: Developers can work on different features independently

### Why Dependency Injection?
- **Testability**: Services can be mocked for unit tests
- **Flexibility**: Easy to swap implementations
- **Loose Coupling**: Components don't depend on concrete implementations

### Type Safety
- All models use strongly-typed Dart classes
- Request/Response models with `toJson()`/`fromJson()`
- No dynamic JSON parsing in business logic

## 📝 Code Quality

### Linting
```bash
# Analyze code
flutter analyze

# Fix auto-fixable issues
dart fix --apply
```

### Formatting
```bash
# Format with 120 character line length
dart format . -l 120

# Check formatting without modifying
dart format --output=none --set-exit-if-changed . -l 120
```

### Code Standards
- ✅ Flutter lints enabled
- ✅ 120 character line length
- ✅ Consistent naming conventions
- ✅ Comprehensive documentation

## 🔮 Future Enhancements

Potential features for future iterations:
- [ ] Persistent storage (local database)
- [ ] URL analytics (click tracking)
- [ ] Custom short URL aliases
- [ ] QR code generation for shortened URLs
- [ ] Share shortened URLs to other apps
- [ ] Dark mode support
- [ ] URL expiration settings
- [ ] Batch URL shortening

## 📄 License

This project is licensed under the MIT License.

## 👤 Author

Built with ❤️ using Flutter

---

**Note**: This is a demonstration project showcasing clean architecture, state management, and comprehensive testing in Flutter.
