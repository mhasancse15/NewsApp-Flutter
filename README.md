# 📰 NewsFlow

A modern **Flutter News App** powered by **NewsAPI**, featuring breaking news, categories, global search, bookmarks, and a clean horizontal + vertical scrolling experience.

---

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
│ Home   Bookmarks  Categories   More │
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

# 📄 License

This project is for learning and demonstration purposes.

---

## ⭐ Support

If you like this project, please consider giving it a ⭐ on GitHub.
