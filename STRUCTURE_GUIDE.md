# Flutter App Structure Guide

## 📁 Core Folder Structure

### `core/constants/`
**Purpose**: App-wide constants that don't change

#### `app_colors.dart`
- All color definitions (primary, secondary, gradients, text colors, etc.)
- ✅ Contains: `AppColors` class with static color constants

#### `app_strings.dart`
- All text strings used throughout the app
- ✅ Contains: `AppStrings` class with static string constants
- Benefits: Easy localization, consistent text, single source of truth

#### `app_assets.dart`
- All asset paths (images, fonts, etc.)
- ✅ Contains: `AppAssets` class with static asset path constants
- Benefits: Easy refactoring, typo prevention

---

### `core/theme/`
**Purpose**: App-wide styling and theming

#### `app_theme.dart`
- Text styles (headings, body, captions)
- Theme data configuration
- Gradients
- ✅ Contains: `AppTheme` class with static text styles and theme data

---

### `core/utils/`
**Purpose**: Reusable utility functions

#### `formatters.dart`
- Date/time formatters
- Number formatters
- String formatters
- ✅ Contains: `Formatters` class with static formatting methods

**Other utils you might add:**
- `validators.dart` - Form validation functions
- `extensions.dart` - Dart extensions
- `helpers.dart` - General helper functions

---

### `core/widgets/`
**Purpose**: Reusable widgets used across multiple features

#### Current widgets:
- ✅ `loading_widget.dart` - Loading screen widget
- `app_button.dart` - Custom button widget (to be implemented)
- `app_app_bar.dart` - Custom app bar widget (to be implemented)
- `empty_state.dart` - Empty state widget (to be implemented)

**Rule**: If a widget is used in 2+ features → put it in `core/widgets/`

---

### `core/models/`
**Purpose**: Shared data models used across features

#### Current models:
- ✅ `category_model.dart` - Category data model

**Rule**: If a model is used in 2+ features → put it in `core/models/`

---

### `core/pages/`
**Purpose**: App-level pages (not feature-specific)

#### Current pages:
- ✅ `splash_page.dart` - App splash screen
- ✅ `onboarding_page.dart` - Onboarding flow

---

## 📁 Feature Folder Structure

Each feature follows this structure:

```
features/
└── [feature_name]/
    ├── presentation/
    │   ├── pages/          ← Feature-specific screens
    │   ├── providers/      ← State management (ChangeNotifier, Provider, etc.)
    │   └── widgets/         ← Feature-specific reusable widgets
    └── repository/          ← Data layer (API calls, local storage)
```

### `features/[feature]/presentation/pages/`
**Purpose**: Feature-specific screens/pages

**What goes here:**
- ✅ Main feature screens (e.g., `login_page.dart`, `home_page.dart`)
- ✅ Feature-specific navigation pages
- ❌ NOT: Reusable widgets (those go in `widgets/`)
- ❌ NOT: Shared pages (those go in `core/pages/`)

**Example:**
- `auth/presentation/pages/login_page.dart`
- `auth/presentation/pages/register_page.dart`
- `home/presentation/pages/home_page.dart`

---

### `features/[feature]/presentation/providers/`
**Purpose**: State management for the feature

**What goes here:**
- ✅ ChangeNotifier classes
- ✅ Provider classes
- ✅ State management logic
- ✅ Business logic related to UI state

**Example:**
```dart
// auth_provider.dart
class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  User? _user;
  
  Future<void> login(String username, String password) async {
    // Login logic
  }
}
```

**Current status:**
- All provider files are placeholders (TODO comments)
- Need to implement actual state management

---

### `features/[feature]/presentation/widgets/`
**Purpose**: Feature-specific reusable widgets

**What goes here:**
- ✅ Widgets used only within this feature
- ✅ Feature-specific UI components
- ❌ NOT: Widgets used in multiple features (those go in `core/widgets/`)

**Example:**
- `auth/presentation/widgets/auth_text_field.dart` - Text field for auth forms
- `home/presentation/widgets/quiz_card.dart` - Quiz card widget
- `category/presentation/widgets/category_card.dart` - Category card widget

**Rule**: If widget is used in 2+ features → move to `core/widgets/`

---

### `features/[feature]/repository/`
**Purpose**: Data layer - API calls, database operations

**What goes here:**
- ✅ API service calls
- ✅ Local storage operations
- ✅ Data fetching logic
- ✅ Data transformation
- ❌ NOT: Business logic (that goes in providers)
- ❌ NOT: UI logic (that goes in pages/widgets)

**Example:**
```dart
// auth_repository.dart
class AuthRepository {
  Future<User> login(String username, String password) async {
    // API call to login
    final response = await apiClient.post('/login', {
      'username': username,
      'password': password,
    });
    return User.fromJson(response.data);
  }
}
```

**Current status:**
- All repository files are placeholders (TODO comments)
- Need to implement actual data layer

---

## 📋 Current Feature Status

### ✅ Auth Feature
- **Pages**: `login_page.dart` ✅, `register_page.dart` (empty), `forgot_password_page.dart` (empty)
- **Widgets**: `auth_text_field.dart` (empty)
- **Providers**: `auth_provider.dart` (TODO)
- **Repository**: `auth_repository.dart` (TODO)

### ✅ Home Feature
- **Pages**: `home_page.dart` ✅
- **Widgets**: `quiz_card.dart` ✅
- **Providers**: `home_provider.dart` (TODO)
- **Repository**: `home_repository.dart` (TODO)

### ✅ Category Feature
- **Pages**: `category_page.dart` ✅
- **Widgets**: `category_card.dart` ✅
- **Providers**: `category_provider.dart` (TODO)
- **Repository**: `category_repository.dart` (TODO)

### ✅ Profile Feature
- **Pages**: `profile_page.dart` ✅
- **Widgets**: None
- **Providers**: None (might not need)
- **Repository**: `profile_repository.dart` (TODO)

### ⚠️ Quiz Feature
- **Pages**: `quiz_page.dart` (empty)
- **Widgets**: `answer_option.dart` (empty)
- **Providers**: `quiz_provider.dart` (TODO)
- **Repository**: `quiz_repository.dart` (TODO)

### ⚠️ Result Feature
- **Pages**: `result_page.dart` (empty)
- **Widgets**: None
- **Providers**: None
- **Repository**: None

### ⚠️ History Feature
- **Pages**: `history_page.dart` (empty)
- **Widgets**: `history_tile.dart` (empty)
- **Providers**: `history_provider.dart` (TODO)
- **Repository**: `history_repository.dart` (TODO)

---

## 🎯 Best Practices

1. **Colors**: Always use `AppColors` from `core/constants/app_colors.dart`
2. **Strings**: Always use `AppStrings` from `core/constants/app_strings.dart`
3. **Assets**: Always use `AppAssets` from `core/constants/app_assets.dart`
4. **Text Styles**: Use `AppTheme` text styles from `core/theme/app_theme.dart`
5. **Widgets**: If used in 2+ features → move to `core/widgets/`
6. **Models**: If used in 2+ features → move to `core/models/`

---

## 🔄 Next Steps

1. ✅ Core constants and theme created
2. ⚠️ Update feature pages to use `AppColors`, `AppStrings`, `AppTheme`
3. ⚠️ Implement providers (state management)
4. ⚠️ Implement repositories (data layer)
5. ⚠️ Implement empty feature pages/widgets

