# NewsFlow

A production-ready Flutter news application built on **NewsAPI.org**, using
**MVVM + Clean Architecture + Riverpod** with a feature-first folder
structure.

## Features

- **Home feed** — breaking news carousel, horizontal category selector, and
  per-category sections (Technology, Business, Sports, Health), each with
  shimmer loading states.
- **Search** — debounced global search against the `/everything` endpoint,
  with pagination, pull-to-refresh, recent search history, and clear/empty/
  error states.
- **Categories** — a full grid of NewsAPI categories, each opening a
  paginated category feed with a featured article at the top.
- **Article details** — hero image, full metadata, bookmark and share
  actions, and a "Read Full Article" button that opens the original URL
  externally when NewsAPI's truncated `content` field isn't enough.
- **Bookmarks** — persisted locally with Hive; bookmarking works from every
  article card in the app and survives app restarts.
- **Settings / More** — theme switcher (System / Light / Dark, persisted),
  About, Privacy Policy, Terms & Conditions, and app version.
- **Bottom navigation** — a `StatefulShellRoute` with four persistent tabs
  (Home, Bookmarks, Categories, More) that preserve each tab's scroll and
  navigation state.
- Centralized error handling (network, timeout, invalid API key, rate
  limit, empty response) with reusable retry/empty/error widgets.
- Light and dark Material 3 themes built from a shared design-token system
  (`AppColors`, `AppTypography`, `AppSpacing`, `AppRadius`, `AppTheme`).

## Architecture

```text
┌─────────────────────────┐
│       Presentation      │
│ Pages / Widgets / State │
└────────────┬────────────┘
             ↓
┌─────────────────────────┐
│         Domain          │
│ Entities / Use Cases    │
│ Repository Contracts    │
└────────────┬────────────┘
             ↓
┌─────────────────────────┐
│          Data           │
│ API / DTO / Repository  │
└────────────┬────────────┘
             ↓
┌─────────────────────────┐
│       NewsAPI.org       │
└─────────────────────────┘
```

Dependencies flow strictly downward: **Presentation → Domain → Data**. The
domain layer has no dependency on Flutter, Dio, or any concrete data
source — it only defines entities, repository contracts, and use cases.

Example call chain for the Home feed:

```text
HomePage
   ↓
HomeViewModel (Notifier)
   ↓
GetTopHeadlinesUseCase
   ↓
NewsRepository (contract)
   ↓
NewsRepositoryImpl
   ↓
NewsRemoteDataSource
   ↓
NewsApiClient (Dio)
   ↓
NewsAPI.org
```

## Folder Structure

```text
lib/
├── core/
│   ├── constants/       # ApiConfig, NewsCategories, StorageKeys, AppDefaults
│   ├── error/           # Failure (domain) + Exception (data) types
│   ├── network/         # DioClient, ErrorInterceptor, NetworkInfo
│   ├── router/          # GoRouter config, not-found page
│   ├── theme/           # AppColors, AppTypography, AppTheme
│   ├── utils/           # DateFormatter, FailureMessageMapper
│   ├── widgets/         # ArticleCard, BookmarkButton, state/skeleton widgets
│   └── providers/       # Shared DI (Dio, repository, network info)
│
├── features/
│   ├── home/
│   │   ├── data/            # ArticleModel, NewsApiClient, NewsRepositoryImpl
│   │   ├── domain/          # Article, Source entities; NewsRepository; use cases
│   │   └── presentation/    # HomePage, HomeViewModel, carousel/section widgets
│   ├── search/               # SearchPage, SearchViewModel, recent searches
│   ├── category/             # CategoriesPage, CategoryPage, per-category pagination
│   ├── article/               # ArticleDetailsPage
│   ├── bookmarks/             # Hive-backed BookmarkRepository, BookmarksPage
│   └── settings/               # Theme persistence, MorePage
│
├── app.dart              # MaterialApp.router + theme wiring
└── main.dart             # Entry point: Hive/SharedPreferences bootstrap
```

## Setup

### 1. Get a NewsAPI key

Sign up for a free key at [newsapi.org](https://newsapi.org/register).

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Run the app

The API key is **never hardcoded** — it's injected at build/run time:

```bash
flutter run --dart-define=NEWS_API_KEY=YOUR_API_KEY
```

### 4. (Optional) Code generation

The project is set up to support `freezed`/`json_serializable` for future
model additions. If you add annotated classes, generate their code with:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Testing

Run all unit and widget tests:

```bash
flutter test
```

Tests cover:

- **Unit** — `ArticleModel`/`NewsResponseModel` JSON parsing,
  `NewsRepositoryImpl` error mapping, `BookmarkRepositoryImpl`,
  `GetTopHeadlinesUseCase`/`SearchNewsUseCase` delegation, and
  `HomeViewModel` state transitions.
- **Widget** — `ArticleCard` rendering/tap behavior, `HomePage` against a
  fake repository, `BookmarksPage` empty state, and `SearchPage` idle/typing
  states.

## Build

```bash
# Android
flutter build apk --dart-define=NEWS_API_KEY=YOUR_API_KEY

# iOS
flutter build ios --dart-define=NEWS_API_KEY=YOUR_API_KEY
```

## Key Design Decisions

- **Riverpod for DI and state**, no service locator — every dependency
  (Dio, API client, data sources, repositories, use cases, ViewModels) is
  wired through `Provider`/`NotifierProvider` graphs in `core/providers`
  and each feature's own `presentation/providers` file.
- **`fpdart`'s `Either<Failure, T>`** as the repository return type, so
  Dio/Hive exceptions never leak past the data layer, and every
  presentation-layer consumer handles success/failure explicitly.
- **`StatefulShellRoute`** (GoRouter) for bottom navigation, so each tab
  keeps its own navigation stack and scroll position when switching tabs.
- **Hive** for bookmark persistence (fast, no native SQL setup) and
  **SharedPreferences** for lightweight key-value settings (theme, recent
  searches).
