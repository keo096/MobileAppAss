# Provider Pattern Guide

This document explains the provider pattern used in this app and why we use providers.

## 🎯 Why Providers?

**Providers separate business logic from UI**, making code:
- ✅ **Testable** - Easy to test business logic separately
- ✅ **Reusable** - Same logic can be used in multiple pages
- ✅ **Maintainable** - Clear separation of concerns
- ✅ **Reactive** - UI automatically updates when state changes

## 📊 Architecture Flow

```
Pages (UI) → Providers (State/Business Logic) → Repositories (Data) → MockData/API
```

## 🔄 What Providers Do

Providers handle:
1. **State Management** - Hold data, loading states, errors
2. **Business Logic** - Process data, validate, transform
3. **Repository Calls** - Call repositories to fetch/save data
4. **Notifications** - Notify UI when state changes (using `notifyListeners()`)

## 📝 Provider Structure

All providers extend `ChangeNotifier` and follow this pattern:

```dart
class FeatureProvider extends ChangeNotifier {
  final FeatureRepository _repository = FeatureRepository();
  
  // State variables
  List<Data> _data = [];
  bool _isLoading = false;
  String? _errorMessage;
  
  // Getters (expose state)
  List<Data> get data => List.unmodifiable(_data);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  // Methods (business logic)
  Future<void> loadData() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners(); // Notify UI
      
      final data = await _repository.getData();
      
      _data = data;
      _isLoading = false;
      notifyListeners(); // Notify UI
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners(); // Notify UI
    }
  }
}
```

## ✅ Available Providers

### 1. QuizProvider
**Location**: `features/quiz/presentation/providers/quiz_provider.dart`

**State**:
- `quizData` - Current quiz with questions
- `currentQuestionIndex` - Current question number
- `selectedAnswerIndex` - Selected answer
- `timeRemaining` - Time left
- `isAnswered` - Whether current question is answered
- `userAnswers` - Map of all user answers
- `isLoading` - Loading state
- `errorMessage` - Error message

**Methods**:
- `loadQuiz(quizId)` - Load quiz with questions
- `selectAnswer(index)` - Select answer for current question
- `nextQuestion()` - Move to next question
- `updateTimer(seconds)` - Update timer
- `submitQuiz()` - Submit quiz and get results
- `reset()` - Reset quiz state

### 2. CategoryProvider
**Location**: `features/category/presentation/providers/category_provider.dart`

**State**:
- `categories` - List of categories
- `isExpanded` - Expand/collapse state
- `isLoading` - Loading state
- `errorMessage` - Error message

**Methods**:
- `loadCategories()` - Load all categories
- `toggleExpanded()` - Toggle expand/collapse
- `updateCategoryProgress(...)` - Update category progress
- `refresh()` - Refresh categories

### 3. HistoryProvider
**Location**: `features/history/presentation/providers/history_provider.dart`

**State**:
- `history` - List of quiz history
- `isLoading` - Loading state
- `errorMessage` - Error message

**Methods**:
- `loadHistory()` - Load all history
- `loadRecentHistory(limit)` - Load recent history
- `loadHistoryByQuizId(quizId)` - Load history by quiz
- `saveQuizResult(...)` - Save quiz result
- `deleteHistory(historyId)` - Delete history entry
- `refresh()` - Refresh history

### 4. AuthProvider
**Location**: `features/auth/presentation/providers/auth_provider.dart`

**State**:
- `user` - Current user
- `isAuthenticated` - Authentication status
- `isLoading` - Loading state
- `errorMessage` - Error message

**Methods**:
- `login(username, password)` - Login user
- `register(...)` - Register new user
- `requestPasswordReset(email)` - Request password reset
- `getCurrentUser()` - Get current user
- `logout()` - Logout user
- `checkAuthentication()` - Check auth status
- `clearError()` - Clear error message

### 5. ProfileProvider
**Location**: `features/profile/presentation/providers/profile_provider.dart`

**State**:
- `user` - User profile
- `statistics` - User statistics
- `isLoading` - Loading state
- `errorMessage` - Error message

**Methods**:
- `loadProfile(userId)` - Load user profile
- `loadStatistics(userId)` - Load user statistics
- `updateProfile(...)` - Update profile
- `deleteAccount(userId)` - Delete account
- `refresh()` - Refresh profile data
- `clearError()` - Clear error message

### 6. HomeProvider
**Location**: `features/home/presentation/providers/home_provider.dart`

**State**:
- `featuredQuizzes` - Featured quizzes
- `dailyQuiz` - Daily quiz
- `learningProgress` - Learning progress data
- `recentActivity` - Recent activity
- `leaderboardPreview` - Leaderboard preview
- `isLoading` - Loading state
- `errorMessage` - Error message

**Methods**:
- `loadHomeData()` - Load all home data
- `loadFeaturedQuizzes(limit)` - Load featured quizzes
- `loadDailyQuiz()` - Load daily quiz
- `loadLearningProgress()` - Load learning progress
- `loadRecentActivity(limit)` - Load recent activity
- `loadLeaderboardPreview(limit)` - Load leaderboard
- `refresh()` - Refresh all data
- `clearError()` - Clear error message

## 🔧 How to Use Providers in Pages

### Option 1: Using Provider Package (Recommended)

First, add provider package to `pubspec.yaml`:
```yaml
dependencies:
  provider: ^6.1.1
```

Then wrap your app with providers:
```dart
// main.dart
import 'package:provider/provider.dart';
import 'package:smart_quiz/features/quiz/presentation/providers/quiz_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => QuizProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
      ],
      child: MyApp(),
    ),
  );
}
```

Use in pages:
```dart
class QuizPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QuizProvider>(context);
    
    if (provider.isLoading) {
      return CircularProgressIndicator();
    }
    
    if (provider.errorMessage != null) {
      return Text('Error: ${provider.errorMessage}');
    }
    
    return QuizContent(provider: provider);
  }
}
```

### Option 2: Direct Instantiation (Current Approach)

```dart
class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final QuizProvider _provider = QuizProvider();
  
  @override
  void initState() {
    super.initState();
    _provider.addListener(_onProviderChange);
    _provider.loadQuiz(widget.quizId);
  }
  
  void _onProviderChange() {
    setState(() {}); // Rebuild when provider state changes
  }
  
  @override
  void dispose() {
    _provider.removeListener(_onProviderChange);
    _provider.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    if (_provider.isLoading) {
      return CircularProgressIndicator();
    }
    
    return QuizContent(provider: _provider);
  }
}
```

## 📋 Benefits of Using Providers

1. **Separation of Concerns**
   - Pages: UI only
   - Providers: Business logic
   - Repositories: Data access

2. **Reusability**
   - Same provider can be used in multiple pages
   - Share state across pages

3. **Testability**
   - Easy to test providers independently
   - Mock repositories for testing

4. **Reactive UI**
   - UI automatically updates when state changes
   - No manual setState needed

5. **State Management**
   - Centralized state management
   - Easy to debug state changes

## 🚀 Next Steps

1. ✅ All providers created
2. ⚠️ Update pages to use providers instead of direct repository calls
3. ⚠️ Add Provider package for better state management (optional)
4. ⚠️ Test providers with unit tests

## 💡 Example: Updating Quiz Page to Use Provider

**Before** (Direct repository):
```dart
class _QuizPageState extends State<QuizPage> {
  final QuizRepository _repository = QuizRepository();
  QuizWithQuestions? quizData;
  bool isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadQuiz();
  }
  
  Future<void> _loadQuiz() async {
    setState(() => isLoading = true);
    quizData = await _repository.getQuizWithQuestions(widget.quizId);
    setState(() => isLoading = false);
  }
}
```

**After** (Using provider):
```dart
class _QuizPageState extends State<QuizPage> {
  final QuizProvider _provider = QuizProvider();
  
  @override
  void initState() {
    super.initState();
    _provider.addListener(() => setState(() {}));
    _provider.loadQuiz(widget.quizId);
  }
  
  @override
  Widget build(BuildContext context) {
    if (_provider.isLoading) return LoadingWidget();
    if (_provider.errorMessage != null) return ErrorWidget();
    
    return QuizContent(provider: _provider);
  }
}
```

**Benefits**:
- ✅ Cleaner code
- ✅ Reusable logic
- ✅ Better state management
- ✅ Easier to test

