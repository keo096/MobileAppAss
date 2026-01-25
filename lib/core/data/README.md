# Mock Data System

This directory contains all mock data used throughout the app. All data is centralized in `mock_data.dart` for easy management.

## 📁 File Structure

- `mock_data.dart` - Centralized mock data service with all data

## 🎯 How to Use

### Accessing Mock Data

```dart
import 'package:smart_quiz/core/data/mock_data.dart';

// Get all categories
final categories = MockData.getCategories();

// Get all quizzes
final quizzes = MockData.getQuizzes();

// Get quiz with questions
final quizWithQuestions = MockData.getQuizWithQuestions('quiz_1');

// Get quiz history
final history = MockData.getQuizHistory();

// Get current user
final user = MockData.getCurrentUser();

// Get leaderboard
final leaderboard = MockData.getLeaderboard();
```

## ✏️ How to Add or Modify Data

### Adding a New Category

1. Open `lib/core/data/mock_data.dart`
2. Find the `getCategories()` method
3. Add a new `Category` object to the list:

```dart
Category(
  title: "New Category",
  subtitle: "Category Description",
  progress: 0.75,
  icon: Icons.new_icon,
  color: Colors.blue,
),
```

### Adding a New Quiz

1. Open `lib/core/data/mock_data.dart`
2. Find the `getQuizzes()` method
3. Add a new `Quiz` object:

```dart
Quiz(
  id: 'quiz_5', // Unique ID
  title: 'New Quiz Title',
  description: 'Quiz description',
  category: 'Category Name',
  categoryId: 'cat_category',
  totalQuestions: 15,
  timeLimit: 900, // seconds
  difficulty: 'medium', // 'easy', 'medium', 'hard'
  totalAttempts: 0,
  averageScore: 0.0,
),
```

### Adding Questions to a Quiz

1. Open `lib/core/data/mock_data.dart`
2. Find the `getQuestionsForQuiz()` method
3. Add questions for your quiz ID:

```dart
if (quizId == 'quiz_5') {
  return [
    Question(
      id: 'q5_1',
      question: 'Your question here?',
      options: ['Option 1', 'Option 2', 'Option 3', 'Option 4'],
      correctAnswer: 2, // Index of correct answer (0-based)
      explanation: 'Explanation of the answer',
      points: 10,
    ),
    // Add more questions...
  ];
}
```

### Adding Quiz History

1. Open `lib/core/data/mock_data.dart`
2. Find the `getQuizHistory()` method
3. Add a new `QuizHistory` object:

```dart
QuizHistory(
  id: 'history_5',
  quizId: 'quiz_1',
  quizTitle: 'Quiz Title',
  category: 'Category',
  totalQuestions: 10,
  correctAnswers: 8,
  score: 80.0,
  timeTaken: 450, // seconds
  completedAt: DateTime.now().subtract(const Duration(days: 1)),
  difficulty: 'easy',
),
```

### Modifying User Data

1. Open `lib/core/data/mock_data.dart`
2. Find the `getCurrentUser()` method
3. Modify the `User` object properties:

```dart
User(
  id: 'user_1',
  username: 'new_username',
  email: 'new_email@example.com',
  fullName: 'Full Name',
  totalQuizzes: 20,
  totalScore: 1500,
  averageScore: 82.5,
  rank: 3,
  joinedAt: DateTime.now().subtract(const Duration(days: 60)),
),
```

## 📊 Data Models

All data models are located in `lib/core/models/`:

- `category_model.dart` - Category model
- `quiz_model.dart` - Quiz, Question, QuizWithQuestions models
- `history_model.dart` - QuizHistory model
- `user_model.dart` - User, LeaderboardEntry models

## 🔄 Helper Methods

The `MockData` class provides helper methods:

```dart
// Get quizzes by category
final quizzes = MockData.getQuizzesByCategory('cat_english');

// Get quiz by ID
final quiz = MockData.getQuizById('quiz_1');

// Get history by quiz ID
final history = MockData.getHistoryByQuizId('quiz_1');

// Get recent history (last N entries)
final recent = MockData.getRecentHistory(limit: 5);
```

## 💡 Tips

1. **Keep IDs unique**: Make sure all IDs (quiz IDs, question IDs, etc.) are unique
2. **Match category IDs**: When creating quizzes, use existing category IDs from categories
3. **Use realistic data**: Use realistic dates, scores, and progress values
4. **Test thoroughly**: After adding new data, test the features that use it

## 🚀 Future Migration

When you're ready to connect to a real API:

1. Create repository classes in `features/[feature]/repository/`
2. Replace `MockData.getX()` calls with repository methods
3. Keep `MockData` for development/testing purposes

