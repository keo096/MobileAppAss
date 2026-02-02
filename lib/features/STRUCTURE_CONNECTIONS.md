# Feature Structure & Repository Connections

This document shows how all features are connected to repositories and the complete data flow.

## 📊 Architecture Flow

```
Pages → Repositories → MockData (currently) → Future: API
```

## ✅ Complete Feature Connections

### 1. Quiz Feature ✅

**Repository**: `features/quiz/repository/quiz_repository.dart`

**Pages Using Repository**:
- ✅ `features/quiz/presentation/pages/quiz_page.dart`
  - Uses: `QuizRepository.getQuizWithQuestions()`
  - Uses: `QuizRepository.submitQuiz()`
  - Features: Loading state, error handling, async data loading

**Connection Flow**:
```dart
QuizPage → QuizRepository → MockData.getQuizWithQuestions()
QuizPage → QuizRepository.submitQuiz() → MockData (calculates score)
```

### 2. Category Feature ✅

**Repository**: `features/category/repository/category_repository.dart`

**Pages Using Repository**:
- ✅ `features/category/presentation/pages/category_page.dart`
  - Uses: `CategoryRepository.getAllCategories()`
  - Features: Loading state, error handling, async data loading

**Connection Flow**:
```dart
CategoryPage → CategoryRepository → MockData.getCategories()
```

### 3. History Feature ✅

**Repository**: `features/history/repository/history_repository.dart`

**Pages Using Repository**:
- ✅ `features/history/presentation/pages/history_page.dart`
  - Uses: `HistoryRepository.getAllHistory()`
  - Features: Loading state, error handling, async data loading

**Connection Flow**:
```dart
HistoryPage → HistoryRepository → MockData.getQuizHistory()
```

### 4. Auth Feature ⚠️

**Repository**: `features/auth/repository/auth_repository.dart`

**Pages**:
- ⚠️ `features/auth/presentation/pages/login_page.dart`
  - Currently uses direct validation (not using repository)
  - **TODO**: Update to use `AuthRepository.login()`

**Repository Methods Available**:
- `login(username, password)` - Ready to use
- `register(...)` - Ready to use
- `requestPasswordReset(email)` - Ready to use
- `getCurrentUser()` - Ready to use
- `logout()` - Ready to use

**Recommended Update**:
```dart
// In login_page.dart
final AuthRepository _repository = AuthRepository();

void _login() async {
  try {
    final user = await _repository.login(
      username: _usernameController.text.trim(),
      password: _passwordController.text.trim(),
    );
    // Navigate to home
  } catch (e) {
    // Show error
  }
}
```

### 5. Profile Feature ⚠️

**Repository**: `features/profile/repository/profile_repository.dart`

**Pages**:
- ⚠️ `features/profile/presentation/pages/profile_page.dart`
  - Currently uses hardcoded data
  - **TODO**: Update to use `ProfileRepository.getUserProfile()`

**Repository Methods Available**:
- `getUserProfile(userId)` - Ready to use
- `updateProfile(...)` - Ready to use
- `getUserStatistics(userId)` - Ready to use
- `deleteAccount(userId)` - Ready to use

**Recommended Update**:
```dart
// In profile_page.dart
final ProfileRepository _repository = ProfileRepository();
User? _user;

@override
void initState() {
  super.initState();
  _loadProfile();
}

Future<void> _loadProfile() async {
  try {
    final user = await _repository.getUserProfile();
    setState(() => _user = user);
  } catch (e) {
    // Handle error
  }
}
```

### 6. Home Feature ⚠️

**Repository**: `features/home/repository/home_repository.dart`

**Pages**:
- ⚠️ `features/home/presentation/pages/home_page.dart`
  - Currently uses static data
  - **TODO**: Update to use `HomeRepository` methods

**Repository Methods Available**:
- `getFeaturedQuizzes(limit)` - Ready to use
- `getDailyQuiz()` - Ready to use
- `getLearningProgress()` - Ready to use
- `getRecentActivity(limit)` - Ready to use
- `getLeaderboardPreview(limit)` - Ready to use

**Recommended Update**:
```dart
// In home_page.dart
final HomeRepository _repository = HomeRepository();
List<Quiz> _featuredQuizzes = [];
Quiz? _dailyQuiz;

@override
void initState() {
  super.initState();
  _loadHomeData();
}

Future<void> _loadHomeData() async {
  try {
    final featured = await _repository.getFeaturedQuizzes(limit: 5);
    final daily = await _repository.getDailyQuiz();
    setState(() {
      _featuredQuizzes = featured;
      _dailyQuiz = daily;
    });
  } catch (e) {
    // Handle error
  }
}
```

## 🔄 Data Flow Pattern

All pages follow this pattern:

```dart
class FeaturePage extends StatefulWidget {
  @override
  State<FeaturePage> createState() => _FeaturePageState();
}

class _FeaturePageState extends State<FeaturePage> {
  // 1. Initialize repository
  final FeatureRepository _repository = FeatureRepository();
  
  // 2. State variables
  List<Data> _data = [];
  bool _isLoading = true;
  String? _errorMessage;
  
  @override
  void initState() {
    super.initState();
    _loadData(); // 3. Load data on init
  }
  
  // 4. Load data method
  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      
      final data = await _repository.getData();
      
      setState(() {
        _data = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    // 5. Handle loading/error states
    if (_isLoading) return LoadingWidget();
    if (_errorMessage != null) return ErrorWidget();
    if (_data.isEmpty) return EmptyState();
    
    // 6. Display data
    return DataList(_data);
  }
}
```

## ✅ Completed Connections

| Feature | Page | Repository | Status |
|---------|------|------------|--------|
| Quiz | `quiz_page.dart` | `QuizRepository` | ✅ Connected |
| Category | `category_page.dart` | `CategoryRepository` | ✅ Connected |
| History | `history_page.dart` | `HistoryRepository` | ✅ Connected |
| Auth | `login_page.dart` | `AuthRepository` | ⚠️ Needs Update |
| Profile | `profile_page.dart` | `ProfileRepository` | ⚠️ Needs Update |
| Home | `home_page.dart` | `HomeRepository` | ⚠️ Needs Update |

## 🎯 Next Steps

1. ✅ Quiz, Category, History - **COMPLETE**
2. ⚠️ Update Auth pages to use `AuthRepository`
3. ⚠️ Update Profile page to use `ProfileRepository`
4. ⚠️ Update Home page to use `HomeRepository`
5. ⚠️ Add providers for state management (optional but recommended)

## 📝 Benefits of Current Structure

1. **Separation of Concerns**: Pages handle UI, repositories handle data
2. **Easy Testing**: Can mock repositories for testing
3. **Easy Migration**: Can swap mock data for real API without changing pages
4. **Error Handling**: Consistent error handling across all features
5. **Loading States**: Proper loading states for better UX
6. **Type Safety**: Using proper models instead of raw maps

## 🔧 Migration to Real API

When ready to connect to real API:

1. Create API client in `core/network/api_client.dart`
2. Update repositories to use API client instead of MockData
3. Add proper error handling (network errors, timeouts, etc.)
4. Add authentication tokens to API requests
5. Test all features with real API

All repositories are already structured with TODO comments showing exactly where to add API calls!

