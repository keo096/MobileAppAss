# Repository Structure Guide

This document explains the repository pattern used in this app and how to work with repositories.

## 📁 Repository Structure

Each feature has its own repository in `features/[feature]/repository/[feature]_repository.dart`

### Current Repositories:
- ✅ `auth/repository/auth_repository.dart`
- ✅ `quiz/repository/quiz_repository.dart`
- ✅ `category/repository/category_repository.dart`
- ✅ `history/repository/history_repository.dart`
- ✅ `profile/repository/profile_repository.dart`
- ✅ `home/repository/home_repository.dart`

## 🎯 Repository Pattern

Repositories are the **data layer** of the app. They:
- Handle all data fetching operations
- Abstract away data sources (API, database, mock data)
- Provide a clean interface for providers/pages to access data
- Can be easily swapped between mock data and real API calls

## 📝 Repository Structure

Each repository follows this structure:

```dart
class FeatureRepository {
  /// Method description
  /// 
  /// [parameter] - Parameter description
  /// Returns description
  /// Throws [Exception] if operation fails
  Future<ReturnType> methodName({
    required String parameter,
  }) async {
    try {
      // Simulate network delay (for mock data)
      await Future.delayed(const Duration(milliseconds: 500));
      
      // TODO: Replace with actual API call
      // final response = await apiClient.get('/endpoint');
      // return Model.fromJson(response.data);
      
      // Current: Use mock data
      return MockData.getData();
    } catch (e) {
      throw Exception('Error message: $e');
    }
  }
}
```

## 🔧 How to Use Repositories

### In Providers

```dart
class QuizProvider extends ChangeNotifier {
  final QuizRepository _repository = QuizRepository();
  
  List<Quiz> _quizzes = [];
  bool _isLoading = false;
  
  Future<void> loadQuizzes() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _quizzes = await _repository.getAllQuizzes();
    } catch (e) {
      // Handle error
      print('Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

### In Pages (Direct Usage - Not Recommended)

```dart
class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final QuizRepository _repository = QuizRepository();
  List<Quiz> _quizzes = [];
  
  @override
  void initState() {
    super.initState();
    _loadQuizzes();
  }
  
  Future<void> _loadQuizzes() async {
    try {
      final quizzes = await _repository.getAllQuizzes();
      setState(() {
        _quizzes = quizzes;
      });
    } catch (e) {
      // Handle error
    }
  }
}
```

**Note**: It's better to use providers for state management instead of calling repositories directly from pages.

## 🔄 Migrating from Mock Data to Real API

When you're ready to connect to a real API:

### Step 1: Create API Client

```dart
// lib/core/network/api_client.dart
class ApiClient {
  final String baseUrl = 'https://api.example.com';
  
  Future<Response> get(String endpoint) async {
    // Implement GET request
  }
  
  Future<Response> post(String endpoint, Map<String, dynamic> data) async {
    // Implement POST request
  }
  
  // ... other methods
}
```

### Step 2: Update Repository

Replace mock data calls with API calls:

```dart
class QuizRepository {
  final ApiClient _apiClient = ApiClient();
  
  Future<List<Quiz>> getAllQuizzes() async {
    try {
      // Remove mock delay
      // await Future.delayed(const Duration(milliseconds: 500));
      
      // Add real API call
      final response = await _apiClient.get('/quizzes');
      return (response.data as List)
          .map((json) => Quiz.fromJson(json))
          .toList();
      
      // Remove mock data call
      // return MockData.getQuizzes();
    } catch (e) {
      throw Exception('Failed to fetch quizzes: $e');
    }
  }
}
```

### Step 3: Handle Errors

Add proper error handling:

```dart
Future<List<Quiz>> getAllQuizzes() async {
  try {
    final response = await _apiClient.get('/quizzes');
    
    if (response.statusCode == 200) {
      return (response.data as List)
          .map((json) => Quiz.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load quizzes: ${response.statusCode}');
    }
  } on SocketException {
    throw Exception('No internet connection');
  } on TimeoutException {
    throw Exception('Request timeout');
  } catch (e) {
    throw Exception('Failed to fetch quizzes: $e');
  }
}
```

## 📋 Repository Methods

### AuthRepository
- `login(username, password)` - Authenticate user
- `register(username, email, password, fullName)` - Register new user
- `requestPasswordReset(email)` - Request password reset
- `getCurrentUser()` - Get current authenticated user
- `logout()` - Logout current user
- `isAuthenticated()` - Check if user is authenticated

### QuizRepository
- `getAllQuizzes()` - Get all available quizzes
- `getQuizById(quizId)` - Get quiz by ID
- `getQuizzesByCategory(categoryId)` - Get quizzes by category
- `getQuizWithQuestions(quizId)` - Get quiz with all questions
- `submitQuiz(quizId, answers, timeTaken)` - Submit quiz answers

### CategoryRepository
- `getAllCategories()` - Get all categories
- `getCategoryById(categoryId)` - Get category by ID
- `updateCategoryProgress(categoryId, progress)` - Update category progress

### HistoryRepository
- `getAllHistory()` - Get all quiz history
- `getRecentHistory(limit)` - Get recent history entries
- `getHistoryByQuizId(quizId)` - Get history by quiz ID
- `getHistoryById(historyId)` - Get history entry by ID
- `saveQuizResult(...)` - Save quiz result to history
- `deleteHistory(historyId)` - Delete history entry

### ProfileRepository
- `getUserProfile(userId)` - Get user profile
- `updateProfile(userId, ...)` - Update user profile
- `getUserStatistics(userId)` - Get user statistics
- `deleteAccount(userId)` - Delete user account

### HomeRepository
- `getFeaturedQuizzes(limit)` - Get featured quizzes
- `getDailyQuiz()` - Get daily quiz
- `getLearningProgress()` - Get learning progress
- `getRecentActivity(limit)` - Get recent activity
- `getLeaderboardPreview(limit)` - Get leaderboard preview

## ✅ Best Practices

1. **Always use try-catch**: Wrap repository methods in try-catch blocks
2. **Throw meaningful errors**: Provide clear error messages
3. **Use async/await**: All repository methods should be async
4. **Return proper types**: Use model classes, not raw maps
5. **Document methods**: Add clear documentation for each method
6. **Simulate delays**: Add delays when using mock data to simulate real API behavior
7. **Keep it simple**: Repositories should only handle data operations, not business logic

## 🚀 Next Steps

1. ✅ All repositories created with mock data
2. ⚠️ Implement providers to use repositories
3. ⚠️ Update pages to use providers instead of direct repository calls
4. ⚠️ When ready, replace mock data with real API calls

