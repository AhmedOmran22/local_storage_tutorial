# Flutter Local Storage Tutorial

A comprehensive Flutter project demonstrating **four different local storage solutions** with full CRUD (Create, Read, Update, Delete) operations and clean UI implementations.

> Learn how to use Hive, SharedPreferences, Secure Storage, and SQLite in your Flutter apps through practical, hands-on examples.

## Overview

This project provides a clean, educational reference for implementing various local storage solutions in Flutter. Each storage type has its own dedicated screen with complete CRUD functionality.

| Storage Type | Use Case | Screen Color |
|-------------|----------|---------------|
| **Hive** | User Settings (name, email, dark mode, language) | Deep Purple |
| **SharedPreferences** | App Settings (theme, notifications, volume, language) | Blue |
| **Secure Storage** | Auth Tokens (encrypted storage for sensitive data) | Teal |
| **SQLite (sqflite)** | Posts CRUD (structured relational data) | Orange |

---

## Project Structure

```
local_storage_tutorial/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── databases/
│   │   ├── hive_service.dart        # Hive CRUD operations
│   │   ├── prefs_service.dart       # SharedPreferences wrapper
│   │   ├── secure_storage_service.dart # Encrypted storage
│   │   └── sqflite_service.dart     # SQLite CRUD operations
│   ├── models/
│   │   ├── post_model.dart          # Post model for SQLite
│   │   ├── user_settings_model.dart # Hive model
│   │   └── user_settings_model.g.dart # Generated Hive adapter
│   ├── screens/
│   │   ├── home_screen.dart         # Navigation hub
│   │   ├── hive_screen.dart         # Hive CRUD UI
│   │   ├── shared_prefs_screen.dart # SharedPreferences UI
│   │   ├── secure_storage_screen.dart # Secure Storage UI
│   │   └── sqflite_screen.dart      # SQLite CRUD UI
│   └── data/
│       └── fake_data.dart           # Sample data
├── pubspec.yaml                     # Dependencies
└── README.md                        # This file
```

---

## Features

### Hive 🗃️

**Use Case:** User Settings (profile, preferences)

- Store user profile information (name, email)
- Save UI preferences (dark mode, language selection)
- Full CRUD with key-value approach
- Uses Hive type adapters for custom objects

**Methods Used:**
- `saveItem<T>(box, key, data)` - Create/Update
- `getItem<T>(box, key)` - Read
- `deleteItem(box, key)` - Delete

---

### SharedPreferences ⚙️

**Use Case:** App Settings (theme, notifications, volume)

- Toggle dark mode / light mode
- Enable/disable push notifications
- Set volume level with slider
- Choose language preference
- Fast key-value storage for simple data types

**Methods Used:**
- `setBool(key, value)` / `getBool(key)`
- `setString(key, value)` / `getString(key)`
- `remove(key)` - Delete

---

### Secure Storage 🔐

**Use Case:** Auth Tokens (encrypted sensitive data)

- Store authentication tokens securely
- Save refresh tokens
- Keep user IDs encrypted
- AES encryption on Android, Keychain on iOS

**Methods Used:**
- `write(key, value)` - Save encrypted
- `read(key)` - Read decrypted
- `delete(key)` - Remove

---

### SQLite (sqflite) 🗃️

**Use Case:** Posts Data (structured relational data)

- Full SQL database with schema
- Create new posts with images and captions
- Read all posts or by ID
- Update post details (caption, likes)
- Delete individual posts or all posts

**Schema:**
```sql
CREATE TABLE posts(
  id TEXT PRIMARY KEY,
  username TEXT NOT NULL,
  userImage TEXT NOT NULL,
  imageUrl TEXT NOT NULL,
  caption TEXT NOT NULL,
  likes INTEGER NOT NULL
)
```

---

## UI Screens

Each screen features:

- **Input Fields** - TextFields for data entry
- **Action Buttons** - Save / Read / Update / Delete
- **Display Area** - Shows stored data in cards
- **Color Coding** - Visual distinction per storage type

### Home Screen 🏠

- Navigation hub with cards for each storage type
- Description of what each storage is best for
- Clean, tappable card interface

---

## Getting Started

### Prerequisites

- Flutter SDK (v3.x or higher)
- Dart SDK
- Android Studio / VS Code

### Installation

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd local_storage_tutorial
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

### Build APK (Optional)

```bash
flutter build apk --debug
```

---

## Dependencies

Add these to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  shared_preferences: ^2.5.5
  flutter_secure_storage: ^10.0.0
  sqflite: ^2.4.2
  path: ^1.9.1
```

---

## Storage Comparison Guide

| Feature | Hive | SharedPreferences | Secure Storage | SQLite |
|---------|------|-------------------|----------------|--------|
| **Type** | NoSQL Key-Value | Key-Value | Encrypted Key-Value | Relational SQL |
| **Data Size** | Large | Small | Small-Medium | Large |
| **Encryption** | Optional | No | Built-in | No |
| **Query Support** | Basic | No | No | Full SQL |
| **Best For** | Objects, Settings | Simple flags, preferences | Tokens, API keys | Structured data, lists |
| **Performance** | Fast | Very Fast | Fast | Good |

### When to Use What?

- **Hive**: When you need to store complex objects or large datasets locally with fast read/write
- **SharedPreferences**: For simple flags, user preferences, or small configuration data
- **Secure Storage**: For sensitive data like auth tokens, API keys, or personal info
- **SQLite**: When you need structured data, relationships, or complex queries

---

## Best Practices

1. **Initialize early**: Initialize all storage services in `main()` before `runApp()`

2. **Use appropriate storage**:
   - Sensitive data → Secure Storage
   - Settings → SharedPreferences
   - Complex objects → Hive
   - Structured data → SQLite

3. **Close connections**: Close Hive boxes and SQLite databases when not needed

4. **Handle errors**: Always wrap storage operations in try-catch blocks

5. **Encrypt sensitive data**: Never store passwords or tokens in plain SharedPreferences

---

