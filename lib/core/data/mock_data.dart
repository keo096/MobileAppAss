import 'package:flutter/material.dart';
import 'package:smart_quiz/core/models/category_model.dart';
import 'package:smart_quiz/core/models/quiz_model.dart';
import 'package:smart_quiz/core/models/history_model.dart';
import 'package:smart_quiz/core/models/user_model.dart';

/// Centralized mock data service
/// 
/// This class contains all mock data used throughout the app.
/// To add or modify data, simply edit the lists below.
class MockData {
  MockData._(); // Private constructor

  // ============================================
  // CATEGORIES DATA
  // ============================================
  /// Add or modify categories here
  static List<Category> getCategories() {
    return [
      Category(
        title: "Present Simple",
        subtitle: "English Tense",
        progress: 0.65,
        icon: Icons.menu_book,
        color: Colors.deepPurple,
      ),
      Category(
        title: "Khmer History",
        subtitle: "History",
        progress: 0.50,
        icon: Icons.history_edu,
        color: Colors.brown,
      ),
      Category(
        title: "Function Complex",
        subtitle: "Math",
        progress: 0.30,
        icon: Icons.calculate,
        color: Colors.blue,
      ),
      Category(
        title: "Khmer Culture",
        subtitle: "General Knowledge",
        progress: 0.80,
        icon: Icons.account_balance,
        color: Colors.purple,
      ),
      Category(
        title: "Chemistry Experiment",
        subtitle: "Chemistry",
        progress: 0.95,
        icon: Icons.science,
        color: Colors.teal,
      ),
      // Add more categories here...
    ];
  }

  // ============================================
  // QUIZZES DATA
  // ============================================
  /// Add or modify quizzes here
  static List<Quiz> getQuizzes() {
    return [
      Quiz(
        id: 'quiz_1',
        title: 'English Grammar Basics',
        description: 'Test your knowledge of basic English grammar',
        category: 'English',
        categoryId: 'cat_english',
        totalQuestions: 10,
        timeLimit: 600, // 10 minutes
        difficulty: 'easy',
        totalAttempts: 1250,
        averageScore: 75.5,
      ),
      Quiz(
        id: 'quiz_2',
        title: 'World History',
        description: 'Explore major events in world history',
        category: 'History',
        categoryId: 'cat_history',
        totalQuestions: 15,
        timeLimit: 900, // 15 minutes
        difficulty: 'medium',
        totalAttempts: 890,
        averageScore: 68.2,
      ),
      Quiz(
        id: 'quiz_3',
        title: 'Mathematics Fundamentals',
        description: 'Basic math concepts and problem solving',
        category: 'Math',
        categoryId: 'cat_math',
        totalQuestions: 20,
        timeLimit: 1200, // 20 minutes
        difficulty: 'hard',
        totalAttempts: 650,
        averageScore: 62.8,
      ),
      Quiz(
        id: 'quiz_4',
        title: 'Science & Nature',
        description: 'Questions about science and the natural world',
        category: 'Science',
        categoryId: 'cat_science',
        totalQuestions: 12,
        timeLimit: 720, // 12 minutes
        difficulty: 'medium',
        totalAttempts: 1100,
        averageScore: 71.3,
      ),
      // Add more quizzes here...
    ];
  }

  // ============================================
  // QUIZ QUESTIONS DATA
  // ============================================
  /// Get questions for a specific quiz
  /// Add or modify questions here
  static List<Question> getQuestionsForQuiz(String quizId) {
    // Quiz 1: English Grammar Basics
    if (quizId == 'quiz_1') {
      return [
        Question(
          id: 'q1_1',
          question: 'What is the capital of France?',
          options: ['London', 'Berlin', 'Paris', 'Madrid'],
          correctAnswer: 2,
          explanation: 'Paris is the capital and largest city of France.',
          points: 10,
        ),
        Question(
          id: 'q1_2',
          question: 'Which planet is known as the Red Planet?',
          options: ['Venus', 'Mars', 'Jupiter', 'Saturn'],
          correctAnswer: 1,
          explanation: 'Mars is called the Red Planet due to iron oxide on its surface.',
          points: 10,
        ),
        Question(
          id: 'q1_3',
          question: 'What is 2 + 2?',
          options: ['3', '4', '5', '6'],
          correctAnswer: 1,
          explanation: 'Basic addition: 2 + 2 = 4',
          points: 10,
        ),
        // Add more questions here...
      ];
    }

    // Quiz 2: World History
    if (quizId == 'quiz_2') {
      return [
        Question(
          id: 'q2_1',
          question: 'In which year did World War II end?',
          options: ['1943', '1944', '1945', '1946'],
          correctAnswer: 2,
          explanation: 'World War II ended in 1945.',
          points: 10,
        ),
        Question(
          id: 'q2_2',
          question: 'Who painted the Mona Lisa?',
          options: ['Van Gogh', 'Picasso', 'Leonardo da Vinci', 'Michelangelo'],
          correctAnswer: 2,
          explanation: 'Leonardo da Vinci painted the Mona Lisa.',
          points: 10,
        ),
        // Add more questions here...
      ];
    }

    // Default: return empty list if quiz not found
    return [];
  }

  /// Get full quiz with questions
  static QuizWithQuestions? getQuizWithQuestions(String quizId) {
    final quiz = getQuizzes().firstWhere(
      (q) => q.id == quizId,
      orElse: () => getQuizzes().first,
    );

    final questions = getQuestionsForQuiz(quizId);
    if (questions.isEmpty) return null;

    return QuizWithQuestions(quiz: quiz, questions: questions);
  }

  // ============================================
  // QUIZ HISTORY DATA
  // ============================================
  /// Add or modify quiz history here
  static List<QuizHistory> getQuizHistory() {
    final now = DateTime.now();
    return [
      QuizHistory(
        id: 'history_1',
        quizId: 'quiz_1',
        quizTitle: 'English Grammar Basics',
        category: 'English',
        totalQuestions: 10,
        correctAnswers: 8,
        score: 80.0,
        timeTaken: 450, // 7 minutes 30 seconds
        completedAt: now.subtract(const Duration(days: 2)),
        difficulty: 'easy',
      ),
      QuizHistory(
        id: 'history_2',
        quizId: 'quiz_2',
        quizTitle: 'World History',
        category: 'History',
        totalQuestions: 15,
        correctAnswers: 12,
        score: 80.0,
        timeTaken: 720, // 12 minutes
        completedAt: now.subtract(const Duration(days: 5)),
        difficulty: 'medium',
      ),
      QuizHistory(
        id: 'history_3',
        quizId: 'quiz_3',
        quizTitle: 'Mathematics Fundamentals',
        category: 'Math',
        totalQuestions: 20,
        correctAnswers: 15,
        score: 75.0,
        timeTaken: 1100, // 18 minutes 20 seconds
        completedAt: now.subtract(const Duration(days: 7)),
        difficulty: 'hard',
      ),
      QuizHistory(
        id: 'history_4',
        quizId: 'quiz_4',
        quizTitle: 'Science & Nature',
        category: 'Science',
        totalQuestions: 12,
        correctAnswers: 10,
        score: 83.3,
        timeTaken: 600, // 10 minutes
        completedAt: now.subtract(const Duration(days: 10)),
        difficulty: 'medium',
      ),
      // Add more history entries here...
    ];
  }

  // ============================================
  // USER DATA
  // ============================================
  /// Get current user data
  /// Modify user information here
  static User getCurrentUser() {
    return User(
      id: 'user_1',
      username: 'admin',
      email: 'admin@smartquiz.com',
      fullName: 'Admin User',
      totalQuizzes: 15,
      totalScore: 1200,
      averageScore: 78.5,
      rank: 5,
      joinedAt: DateTime.now().subtract(const Duration(days: 30)),
    );
  }

  // ============================================
  // LEADERBOARD DATA
  // ============================================
  /// Add or modify leaderboard entries here
  static List<LeaderboardEntry> getLeaderboard() {
    return [
      LeaderboardEntry(
        userId: 'user_1',
        username: 'QuizMaster',
        totalScore: 2500,
        totalQuizzes: 50,
        averageScore: 85.2,
        rank: 1,
      ),
      LeaderboardEntry(
        userId: 'user_2',
        username: 'BrainBox',
        totalScore: 2300,
        totalQuizzes: 45,
        averageScore: 82.1,
        rank: 2,
      ),
      LeaderboardEntry(
        userId: 'user_3',
        username: 'SmartLearner',
        totalScore: 2100,
        totalQuizzes: 40,
        averageScore: 79.5,
        rank: 3,
      ),
      LeaderboardEntry(
        userId: 'user_4',
        username: 'KnowledgeSeeker',
        totalScore: 1950,
        totalQuizzes: 38,
        averageScore: 77.8,
        rank: 4,
      ),
      LeaderboardEntry(
        userId: 'user_5',
        username: 'admin', // Current user
        totalScore: 1800,
        totalQuizzes: 35,
        averageScore: 75.3,
        rank: 5,
      ),
      // Add more leaderboard entries here...
    ];
  }

  // ============================================
  // HELPER METHODS
  // ============================================
  /// Get quizzes by category
  static List<Quiz> getQuizzesByCategory(String categoryId) {
    return getQuizzes()
        .where((quiz) => quiz.categoryId == categoryId)
        .toList();
  }

  /// Get quiz by ID
  static Quiz? getQuizById(String quizId) {
    try {
      return getQuizzes().firstWhere((quiz) => quiz.id == quizId);
    } catch (e) {
      return null;
    }
  }

  /// Get history by quiz ID
  static List<QuizHistory> getHistoryByQuizId(String quizId) {
    return getQuizHistory()
        .where((history) => history.quizId == quizId)
        .toList();
  }

  /// Get recent history (last N entries)
  static List<QuizHistory> getRecentHistory({int limit = 10}) {
    final history = getQuizHistory();
    history.sort((a, b) => b.completedAt.compareTo(a.completedAt));
    return history.take(limit).toList();
  }
}

