# NewsFlow

A production-ready Flutter news application built on **NewsAPI.org**, using
**MVVM + Clean Architecture + Riverpod** with a feature-first folder
structure.

## 📱 App UI

### Home Screen

The Home screen contains all major news sections in a vertically scrollable layout.

```text
┌─────────────────────────────────────┐
│  NewsFlow                       🔔  │
│                                     │
│  🔍 Search news, topics...          │
├─────────────────────────────────────┤
│ All  Business  Tech  Sports  Health │
├─────────────────────────────────────┤
│                                     │
│ 🔥 Breaking News             See All │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │                                 │ │
│ │          NEWS IMAGE              │ │
│ │                                 │ │
│ │  Major news headline goes here   │ │
│ │  BBC News • 2 hours ago         │ │
│ └─────────────────────────────────┘ │
│                                     │
│ 💻 Technology                See All │
│                                     │
│ ┌────────┐ ┌────────┐ ┌────────┐  │
│ │ IMAGE  │ │ IMAGE  │ │ IMAGE  │ →│
│ │ Title  │ │ Title  │ │ Title  │  │
│ └────────┘ └────────┘ └────────┘  │
│                                     │
│ 💼 Business                  See All │
│                                     │
│ ┌────────┐ ┌────────┐ ┌────────┐  │
│ │ IMAGE  │ │ IMAGE  │ │ IMAGE  │ →│
│ └────────┘ └────────┘ └────────┘  │
│                                     │
│ ⚽ Sports                     See All│
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ 🖼 Sports headline               │ │
│ └─────────────────────────────────┘ │
│                                     │
│              ↓                      │
│        Vertical Scroll              │
├─────────────────────────────────────┤
│                                     │
│  🏠       🔖        🗂️        ⚙️   │
│ Home   Bookmarks  Categories   Setting │
└─────────────────────────────────────┘
```

---

## ✨ Features

* 🏠 Home news dashboard
* 🔍 Global news search
* 🔥 Breaking news carousel
* 📰 Latest news feed
* 💻 Technology news
* 💼 Business news
* ⚽ Sports news
* 🎬 Entertainment news
* 🔬 Science news
* ❤️ Health news
* 🔖 Bookmark articles
* 🗂️ Browse news categories
* 🌙 Light/Dark theme
* 🔄 Pull to refresh
* ♾️ Pagination
* ⚡ Shimmer loading
* 🚫 Empty and error states
* 📱 Responsive UI

---

# 🏠 Home Screen

The Home screen uses a **vertical scroll** containing multiple independent **horizontal news sections**.

### Home Structure

```text
Home
│
├── App Header
│
├── 🔍 Global Search
│
├── Category Tabs ────────────────→
│
├── 🔥 Breaking News ────────────→
│
├── 💻 Technology ───────────────→
│
├── 💼 Business ────────────────→
│
├── ⚽ Sports ──────────────────→
│
├── 🎬 Entertainment ───────────→
│
├── 🔬 Science ─────────────────→
│
└── 📰 Latest News
        │
        ↓
   Vertical Scroll
```

---

# 🔍 Global Search

Global search is available at the top of the Home screen.

Users can search for:

* News topics
* Keywords
* Companies
* People
* Events
* Technology
* Sports

### Search API

```http
GET /v2/everything?q={query}
```

Example:

```http
GET https://newsapi.org/v2/everything?q=flutter
```

---

# 🗂️ Categories

A horizontal category selector is displayed below the search bar.

```text
All → Business → Technology → Sports → Health → Science → Entertainment
```

Available categories:

* General
* Business
* Entertainment
* Health
* Science
* Sports
* Technology

---

# 🔥 Breaking News

Breaking news is displayed using a horizontal carousel.

```text
┌─────────────────────────────────────┐
│                                     │
│             NEWS IMAGE              │
│                                     │
│  Breaking news headline             │
│                                     │
│  Source • 30 minutes ago            │
│                                     │
└─────────────────────────────────────┘

              ● ○ ○ ○
```

---

# 📰 News Sections

Each major category has a horizontal scrolling section.

Example:

```text
## Technology

┌─────────────┐  ┌─────────────┐  ┌─────────────┐
│    IMAGE    │  │    IMAGE    │  │    IMAGE    │
│             │  │             │  │             │
├─────────────┤  ├─────────────┤  ├─────────────┤
│ News title  │  │ News title  │  │ News title  │
│ Source • 2h │  │ Source • 3h │  │ Source • 5h │
└─────────────┘  └─────────────┘  └─────────────┘
       →                →                →
```

Sections:

* 🔥 Trending
* 💻 Technology
* 💼 Business
* ⚽ Sports
* 🎬 Entertainment
* 🔬 Science
* ❤️ Health

---

# 📰 Latest News

Latest news is displayed as a vertical feed.

```text
┌─────────────────────────────────────┐
│ 🖼 │ Major news headline goes here  │
│    │ BBC News • 1 hour ago          │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│ 🖼 │ Another important headline     │
│    │ Reuters • 2 hours ago          │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│ 🖼 │ Latest update from around world│
│    │ CNN • 3 hours ago              │
└─────────────────────────────────────┘
```

---

# 🔖 Bookmarks

Users can save articles for later.

```text
┌─────────────────────────────────────┐
│ 🔖 Bookmarks                        │
├─────────────────────────────────────┤
│                                     │
│ 🖼  Article headline...         🔖  │
│     BBC News • 2 hours ago          │
│                                     │
│ 🖼  Another saved article...    🔖  │
│     Reuters • Yesterday             │
│                                     │
└─────────────────────────────────────┘
```

---

# 🗂️ Categories Screen

The Categories screen allows users to browse all available categories.

```text
┌──────────────────┐  ┌──────────────────┐
│ 💼               │  │ 💻               │
│ Business         │  │ Technology       │
└──────────────────┘  └──────────────────┘

┌──────────────────┐  ┌──────────────────┐
│ ⚽               │  │ 🎬               │
│ Sports           │  │ Entertainment    │
└──────────────────┘  └──────────────────┘

┌──────────────────┐  ┌──────────────────┐
│ 🔬               │  │ ❤️               │
│ Science          │  │ Health           │
└──────────────────┘  └──────────────────┘
```

---

# ⚙️ More

The More screen contains application settings.

```text
More

🌙  Dark Mode
🌐  Language
🔔  Notifications
ℹ️  About
⭐  Rate App
```

---

# 🧭 Bottom Navigation

The application uses a persistent bottom navigation bar.

```text
┌─────────────────────────────────────┐
│                                     │
│            PAGE CONTENT             │
│                                     │
├─────────────────────────────────────┤
│                                     │
│   🏠       🔖        🗂️       ⚙️   │
│  Home   Bookmarks  Categories  More │
└─────────────────────────────────────┘
```

### Navigation

| Icon | Screen     | Description                  |
| ---- | ---------- | ---------------------------- |
| 🏠   | Home       | News dashboard               |
| 🔖   | Bookmarks  | Saved articles               |
| 🗂️  | Categories | Browse categories            |
| ⚙️   | More       | Settings and app information |

---

# 🌐 NewsAPI

NewsFlow uses **NewsAPI** to retrieve news articles.

### Endpoints

| Endpoint                    | Purpose                    |
| --------------------------- | -------------------------- |
| `/v2/top-headlines`         | Get top headlines          |
| `/v2/everything`            | Search news articles       |
| `/v2/top-headlines/sources` | Get available news sources |

### Top Headlines

```http
GET https://newsapi.org/v2/top-headlines
```

### Category News

```http
GET https://newsapi.org/v2/top-headlines?category=technology
```

### Search

```http
GET https://newsapi.org/v2/everything?q=flutter
```

---

# 🏗️ Project Architecture

```text
lib/
│
├── core/
│   ├── constants/
│   ├── network/
│   ├── error/
│   └── utils/
│
├── data/
│   ├── models/
│   ├── datasource/
│   └── repository/
│
├── domain/
│   ├── entities/
│   ├── repository/
│   └── usecases/
│
├── presentation/
│   ├── home/
│   ├── search/
│   ├── bookmarks/
│   ├── categories/
│   └── more/
│
└── main.dart
```

---

# 🛠️ Tech Stack

* **Flutter**
* **Dart**
* **Dio**
* **Retrofit**
* **NewsAPI**
* **JSON Serialization**
* **Material 3**
* **Clean Architecture**
* **Repository Pattern**

---

# 🚀 Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/your-username/newsflow.git
```

### 2. Navigate to the project

```bash
cd newsflow
```

### 3. Install dependencies

```bash
flutter pub get
```

### 4. Add NewsAPI Key

Configure your NewsAPI key:

```text
NEWS_API_KEY=YOUR_API_KEY
```

### 5. Run the application

```bash
flutter run
```

---

# 📌 Future Improvements

* 🤖 AI-powered news summaries
* 🧠 Personalized news feed
* 🎙️ Text-to-speech
* 🌍 Multi-language support
* 📡 Offline reading
* 🔔 Breaking-news notifications
* 👤 User accounts
* 📊 Trending topics
* 📰 Multiple news providers

---


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


## ⭐ Support

If you like this project, please consider giving it a ⭐ on GitHub.

# 📄 License

This project is for learning and demonstration purposes.