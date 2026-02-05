import 'package:flutter/material.dart';
import 'package:smart_quiz/core/models/category_model.dart';
import 'package:smart_quiz/core/models/quiz_model.dart';
import 'package:smart_quiz/core/models/history_model.dart';
import 'package:smart_quiz/core/models/user_model.dart';
import 'package:smart_quiz/core/models/quiz_participant_model.dart';

/// Centralized mock data service
///
/// This class contains all mock data used throughout the app.
/// To add or modify data, simply edit the lists below.
class MockData {
  MockData._(); // Private constructor

  // ============================================
  // CATEGORIES DATA
  // ============================================

  static final Map<String, List<Question>> _dynamicQuestions = {};

  static final List<Category> _categories = [
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
  ];

  /// Get all categories
  static List<Category> getCategories() {
    return _categories;
  }

  /// Add a new category
  static void addCategory(Category category) {
    _categories.add(category);
  }

  // ============================================
  // QUIZZES DATA
  // ============================================
  static final List<Quiz> _quizzes = [
    // --- Present Simple (English) ---
    Quiz(
      id: 'quiz_1',
      title: 'Intro to Present Simple',
      description: 'Master the basics of the most common English tense.',
      category: 'Present Simple',
      categoryId: 'cat_present_simple',
      totalQuestions: 10,
      timeLimit: 600,
      difficulty: 'easy',
      topic: 'Grammar',
      deadline: DateTime.now().add(const Duration(days: 7)),
      isPublished: true,
      averageScore: 75.5,
    ),
    Quiz(
      id: 'quiz_2',
      title: 'Advanced Usage',
      description: 'Complex rules and exceptions in present tenses.',
      category: 'Present Simple',
      categoryId: 'cat_present_simple',
      totalQuestions: 15,
      timeLimit: 900,
      difficulty: 'hard',
      topic: 'Grammar',
      deadline: DateTime.now().add(const Duration(days: 5)),
      isPublished: true,
      averageScore: 68.2,
    ),

    // --- Khmer History ---
    Quiz(
      id: 'quiz_history_1',
      title: 'Angkor Wat Empire',
      description: 'Explore the golden age of the Khmer Empire.',
      category: 'Khmer History',
      categoryId: 'cat_khmer_history',
      totalQuestions: 20,
      timeLimit: 1200,
      difficulty: 'medium',
      topic: 'History',
      deadline: DateTime.now().add(const Duration(days: 10)),
      isPublished: true,
    ),
    Quiz(
      id: 'quiz_history_2',
      title: 'Modern Cambodia',
      description: 'From independence to the present day.',
      category: 'Khmer History',
      categoryId: 'cat_khmer_history',
      totalQuestions: 15,
      timeLimit: 900,
      difficulty: 'medium',
      topic: 'History',
      deadline: DateTime.now().add(const Duration(days: 8)),
      isPublished: true,
    ),

    // --- Function Complex (Math) ---
    Quiz(
      id: 'quiz_math_1',
      title: 'Derivatives & Limits',
      description: 'Foundational concepts of calculus.',
      category: 'Function Complex',
      categoryId: 'cat_math',
      totalQuestions: 12,
      timeLimit: 1800,
      difficulty: 'hard',
      topic: 'Calculus',
      deadline: DateTime.now().add(const Duration(days: 12)),
      isPublished: true,
      averageScore: 62.8,
    ),
    Quiz(
      id: 'quiz_math_2',
      title: 'Integrals',
      description: 'Master the techniques of integration.',
      category: 'Function Complex',
      categoryId: 'cat_math',
      totalQuestions: 10,
      timeLimit: 1500,
      difficulty: 'hard',
      topic: 'Calculus',
      deadline: DateTime.now().add(const Duration(days: 14)),
      isPublished: true,
    ),

    // --- Khmer Culture ---
    Quiz(
      id: 'quiz_culture_1',
      title: 'Traditional Arts',
      description: 'Lakhon Khol, Apsara, and traditional music.',
      category: 'Khmer Culture',
      categoryId: 'cat_culture',
      totalQuestions: 15,
      timeLimit: 900,
      difficulty: 'easy',
      topic: 'Arts',
      deadline: DateTime.now().add(const Duration(days: 6)),
      isPublished: true,
    ),
    Quiz(
      id: 'quiz_culture_2',
      title: 'Khmer New Year',
      description: 'Traditions, games, and significance of Sangkran.',
      category: 'Khmer Culture',
      categoryId: 'cat_culture',
      totalQuestions: 10,
      timeLimit: 600,
      difficulty: 'easy',
      topic: 'Traditions',
      deadline: DateTime.now().add(const Duration(days: 3)),
      isPublished: true,
    ),

    // --- Chemistry Experiment ---
    Quiz(
      id: 'quiz_chem_1',
      title: 'Periodic Table',
      description: 'Elements, groups, and periodicity.',
      category: 'Chemistry Experiment',
      categoryId: 'cat_chemistry',
      totalQuestions: 25,
      timeLimit: 1200,
      difficulty: 'medium',
      topic: 'General Chemistry',
      deadline: DateTime.now().add(const Duration(days: 9)),
      isPublished: true,
      averageScore: 71.3,
    ),
    Quiz(
      id: 'quiz_chem_2',
      title: 'Laboratory Safety',
      description: 'Essential rules for working in a chem lab.',
      category: 'Chemistry Experiment',
      categoryId: 'cat_chemistry',
      totalQuestions: 10,
      timeLimit: 600,
      difficulty: 'easy',
      topic: 'Safety',
      deadline: DateTime.now().add(const Duration(days: 20)),
      isPublished: true,
    ),
  ];

  /// Get all quizzes
  static List<Quiz> getQuizzes() {
    return _quizzes;
  }

  /// Add a new quiz
  static void addQuiz(Quiz quiz) {
    _quizzes.add(quiz);
  }

  /// Update quiz settings
  static void updateQuiz(Quiz updatedQuiz) {
    final index = _quizzes.indexWhere((q) => q.id == updatedQuiz.id);
    if (index != -1) {
      _quizzes[index] = updatedQuiz;
    }
  }

  /// Get quiz status for current user
  static String getQuizStatus(String quizId) {
    final history = getQuizHistory().where((h) => h.quizId == quizId).toList();
    if (history.isEmpty) return 'new';

    // Check for in-progress or completed
    for (var h in history) {
      if (h.status == 'in_progress') return 'in_progress';
      if (h.status == 'completed') return 'completed';
    }

    return 'new';
  }

  // ============================================
  // QUIZ QUESTIONS DATA
  // ============================================
  /// Get questions for a specific quiz
  static List<Question> getQuestionsForQuiz(String quizId) {
    // Check dynamic questions first (for admin entries)
    if (_dynamicQuestions.containsKey(quizId)) {
      return _dynamicQuestions[quizId]!;
    }

    // --- Present Simple (English) ---
    if (quizId == 'quiz_1') {
      return [
        Question(
          id: 'q1_1',
          question: 'She _____ to school every day.',
          options: ['go', 'goes', 'going', 'gone'],
          correctAnswer: 1,
          explanation: 'Third person singular "She" takes "goes".',
          points: 10,
        ),
        Question(
          id: 'q1_2',
          question: 'They _____ like coffee.',
          options: ['dont', 'doesnt', 'not', 'no'],
          correctAnswer: 0,
          explanation: 'Plural "They" takes "don\'t".',
          points: 10,
        ),
      ];
    }
    if (quizId == 'quiz_2') {
      return [
        Question(
          id: 'q2_1',
          question: 'Which is correct for a permanent state?',
          options: [
            'I am living here.',
            'I live here.',
            'I lives here.',
            'I living here.',
          ],
          correctAnswer: 1,
          explanation: 'Present simple is used for permanent states.',
          points: 15,
        ),
      ];
    }

    // --- Khmer History ---
    if (quizId == 'quiz_history_1') {
      return [
        Question(
          id: 'qh1_1',
          question: 'Which King built Angkor Wat?',
          options: ['Jayavarman VII', 'Suryavarman II', 'Ang Duong', 'Norodom'],
          correctAnswer: 1,
          explanation:
              'Suryavarman II built Angkor Wat in the early 12th century.',
          points: 10,
        ),
        Question(
          id: 'qh1_2',
          question: 'What does "Angkor" mean?',
          options: ['Temple', 'City', 'Forest', 'Mountain'],
          correctAnswer: 1,
          explanation:
              'Angkor is derived from the Sanskrit word "Nagara" meaning City.',
          points: 10,
        ),
      ];
    }
    if (quizId == 'quiz_history_2') {
      return [
        Question(
          id: 'qh2_1',
          question: 'In what year did Cambodia gain independence from France?',
          options: ['1945', '1953', '1975', '1993'],
          correctAnswer: 1,
          explanation: 'Cambodia gained independence on November 9, 1953.',
          points: 10,
        ),
      ];
    }

    // --- Math ---
    if (quizId == 'quiz_math_1') {
      return [
        Question(
          id: 'qm1_1',
          question: 'What is the derivative of x^2?',
          options: ['x', '2x', 'x^2', '2'],
          correctAnswer: 1,
          explanation: 'The power rule: d/dx(x^n) = nx^(n-1).',
          points: 10,
        ),
      ];
    }

    // --- Chemistry ---
    if (quizId == 'quiz_chem_1') {
      return [
        Question(
          id: 'qc1_1',
          question: 'What is the chemical symbol for Gold?',
          options: ['Gd', 'Go', 'Ag', 'Au'],
          correctAnswer: 3,
          explanation: 'Au is from the Latin word "Aurum".',
          points: 10,
        ),
      ];
    }
    if (quizId == 'quiz_chem_2') {
      return [
        Question(
          id: 'qc2_1',
          question: 'What should you do if an acid splashes on your skin?',
          options: [
            'Apply oil',
            'Scrub hard',
            'Rinse with plenty of water',
            'Wait for the teacher',
          ],
          correctAnswer: 2,
          explanation:
              'Immediate rinsing with water is the primary safety protocol.',
          points: 10,
        ),
      ];
    }

    // --- Culture ---
    if (quizId == 'quiz_culture_1') {
      return [
        Question(
          id: 'qcu1_1',
          question: 'Which dance features dancers mimicking monkeys?',
          options: ['Apsara', 'Lakhon Khol', 'Robam Nesat', 'Bakyong'],
          correctAnswer: 1,
          explanation:
              'Lakhon Khol is a masked theater specifically featuring monkey and giant characters.',
          points: 10,
        ),
      ];
    }
    if (quizId == 'quiz_culture_2') {
      return [
        Question(
          id: 'qcu2_1',
          question: 'When is Khmer New Year usually celebrated?',
          options: ['January', 'April', 'September', 'November'],
          correctAnswer: 1,
          explanation:
              'Khmer New Year (Choul Chnam Thmey) is in mid-April (usually 13th-16th).',
          points: 10,
        ),
      ];
    }

    // Default for brand new quizzes created by admin
    return [];
  }

  /// Get full quiz with questions
  static QuizWithQuestions? getQuizWithQuestions(String quizId) {
    final quizList = getQuizzes();
    try {
      final quiz = quizList.firstWhere((q) => q.id == quizId);
      final questions = getQuestionsForQuiz(quizId);
      if (questions.isEmpty) return null;
      return QuizWithQuestions(quiz: quiz, questions: questions);
    } catch (e) {
      return null;
    }
  }

  // ============================================
  // QUIZ HISTORY DATA
  // ============================================
  static List<QuizHistory> getQuizHistory() {
    final now = DateTime.now();
    return [
      QuizHistory(
        id: 'history_1',
        quizId: 'quiz_1',
        quizTitle: 'Tense',
        category: 'present simple',
        totalQuestions: 10,
        correctAnswers: 10,
        score: 100.0,
        timeTaken: 720,
        completedAt: now.subtract(const Duration(days: 2)),
        difficulty: 'easy',
        status: 'completed',
      ),
      QuizHistory(
        id: 'history_2',
        quizId: 'quiz_1',
        quizTitle: 'Tense',
        category: 'past simple',
        totalQuestions: 10,
        correctAnswers: 10,
        score: 100.0,
        timeTaken: 720,
        completedAt: now.subtract(const Duration(days: 3)),
        difficulty: 'easy',
        status: 'completed',
      ),
      QuizHistory(
        id: 'history_3',
        quizId: 'quiz_2',
        quizTitle: 'Preposition',
        category: 'time, place, movement',
        totalQuestions: 20,
        correctAnswers: 15,
        score: 75.0,
        timeTaken: 720,
        completedAt: now.subtract(const Duration(days: 5)),
        difficulty: 'medium',
        status: 'in_progress',
        resumeData: {'currentQuestion': 15, 'answers': []},
      ),
      QuizHistory(
        id: 'history_4',
        quizId: 'quiz_3',
        quizTitle: 'Passive Voice',
        category: 'present, past',
        totalQuestions: 20,
        correctAnswers: 15,
        score: 75.0,
        timeTaken: 720,
        completedAt: now.subtract(const Duration(days: 6)),
        difficulty: 'medium',
        status: 'in_progress',
        resumeData: {'currentQuestion': 10, 'answers': []},
      ),
      QuizHistory(
        id: 'history_5',
        quizId: 'quiz_4',
        quizTitle: 'Modal Verbs',
        category: 'can, could, may',
        totalQuestions: 15,
        correctAnswers: 15,
        score: 100.0,
        timeTaken: 720,
        completedAt: now.subtract(const Duration(days: 8)),
        difficulty: 'easy',
        status: 'completed',
      ),
    ];
  }

  // ============================================
  // USER DATA
  // ============================================
  static final Map<String, Map<String, dynamic>> _predefinedUsers = {
    'admin': {
      'password': '112233',
      'user': User(
        id: 'admin_1',
        username: 'admin',
        email: 'admin@smartquiz.com',
        fullName: 'Admin User',
        totalQuizzes: 15,
        totalScore: 1200,
        averageScore: 78.5,
        rank: 5,
        role: 'admin',
        joinedAt: DateTime(2025, 1, 1),
      ),
    },
    'leap': {
      'password': '112233',
      'user': User(
        id: 'admin_leap',
        username: 'leap',
        email: 'leap@smartquiz.com',
        fullName: 'Leap',
        totalQuizzes: 0,
        totalScore: 0,
        averageScore: 0.0,
        rank: 0,
        role: 'admin',
        joinedAt: DateTime(2025, 2, 1),
      ),
    },
    'mara': {
      'password': '112233',
      'user': User(
        id: 'admin_mara',
        username: 'mara',
        email: 'mara@smartquiz.com',
        fullName: 'Mara',
        totalQuizzes: 0,
        totalScore: 0,
        averageScore: 0.0,
        rank: 0,
        role: 'admin',
        joinedAt: DateTime(2025, 2, 1),
      ),
    },
    'sokea': {
      'password': '112233',
      'user': User(
        id: 'admin_sokea',
        username: 'sokea',
        email: 'sokea@smartquiz.com',
        fullName: 'Sokea',
        totalQuizzes: 0,
        totalScore: 0,
        averageScore: 0.0,
        rank: 0,
        role: 'admin',
        joinedAt: DateTime(2025, 2, 1),
      ),
    },
    'sreykeo': {
      'password': '112233',
      'user': User(
        id: 'admin_sreykeo',
        username: 'sreykeo',
        email: 'sreykeo@smartquiz.com',
        fullName: 'Sreykeo',
        totalQuizzes: 0,
        totalScore: 0,
        averageScore: 0.0,
        rank: 0,
        role: 'admin',
        joinedAt: DateTime(2025, 2, 1),
      ),
    },
    'chheangly': {
      'password': '112233',
      'user': User(
        id: 'admin_chheangly',
        username: 'chheangly',
        email: 'chheangly@smartquiz.com',
        fullName: 'Chheangly',
        totalQuizzes: 0,
        totalScore: 0,
        averageScore: 0.0,
        rank: 0,
        role: 'admin',
        joinedAt: DateTime(2025, 2, 1),
      ),
    },

    'user': {
      'password': '123456',
      'user': User(
        id: 'user_1',
        username: 'user',
        email: 'user@smartquiz.com',
        fullName: 'Standard User',
        totalQuizzes: 5,
        totalScore: 350,
        averageScore: 65.0,
        rank: 120,
        role: 'user',
        joinedAt: DateTime(2025, 1, 15),
      ),
    },
  };

  static User? _currentUser;

  static bool authenticate(String username, String password) {
    final userEntry = _predefinedUsers[username.toLowerCase()];
    if (userEntry != null && userEntry['password'] == password) {
      _currentUser = userEntry['user'] as User;
      return true;
    }
    return false;
  }

  static void login(String username) {
    final userEntry = _predefinedUsers[username.toLowerCase()];
    if (userEntry != null) {
      _currentUser = userEntry['user'] as User;
      return;
    }
    if (username.toLowerCase().contains('admin')) {
      _currentUser = User(
        id: 'admin_dynamic',
        username: username,
        email: '$username@smartquiz.com',
        fullName: 'Admin User',
        totalQuizzes: 15,
        totalScore: 1200,
        averageScore: 78.5,
        rank: 5,
        role: 'admin',
        joinedAt: DateTime.now(),
      );
    } else {
      _currentUser = User(
        id: 'user_dynamic',
        username: username,
        email: '$username@smartquiz.com',
        fullName: 'Standard User',
        totalQuizzes: 5,
        totalScore: 350,
        averageScore: 65.0,
        rank: 120,
        role: 'user',
        joinedAt: DateTime.now(),
      );
    }
  }

  static User getCurrentUser() {
    return _currentUser ??
        User(
          id: 'guest',
          username: 'Guest',
          email: 'guest@smartquiz.com',
          fullName: 'Guest User',
          totalQuizzes: 0,
          totalScore: 0,
          averageScore: 0.0,
          rank: 999,
          role: 'user',
          joinedAt: DateTime.now(),
        );
  }

  static bool isLoggedIn() {
    return _currentUser != null;
  }

  static void logout() {
    _currentUser = null;
  }

  static bool isAdmin() {
    return getCurrentUser().role == 'admin';
  }

  // ============================================
  // LEADERBOARD DATA
  // ============================================
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
        username: 'admin',
        totalScore: 1800,
        totalQuizzes: 35,
        averageScore: 75.3,
        rank: 5,
      ),
    ];
  }

  // ============================================
  // HELPER METHODS
  // ============================================
  static List<Quiz> getQuizzesByCategory(String categoryTitle) {
    return getQuizzes()
        .where(
          (quiz) => quiz.category.toLowerCase() == categoryTitle.toLowerCase(),
        )
        .toList();
  }

  static Quiz? getQuizById(String quizId) {
    try {
      return getQuizzes().firstWhere((quiz) => quiz.id == quizId);
    } catch (e) {
      return null;
    }
  }

  static List<QuizHistory> getHistoryByQuizId(String quizId) {
    return getQuizHistory()
        .where((history) => history.quizId == quizId)
        .toList();
  }

  static List<QuizHistory> getRecentHistory({int limit = 10}) {
    final history = getQuizHistory();
    history.sort((a, b) => b.completedAt.compareTo(a.completedAt));
    return history.take(limit).toList();
  }

  static List<QuizHistory> getQuizHistoryByStatus(String status) {
    return getQuizHistory().where((h) => h.status == status).toList();
  }

  static List<Category> getCreatedCategories() {
    return getCategories();
  }

  static Map<String, dynamic> getHistoryStatistics() {
    final history = getQuizHistory();
    if (history.isEmpty) {
      return {'totalQuizzes': 0, 'averageScore': 0.0, 'totalTime': 0};
    }
    final totalQuizzes = history.length;
    final averageScore =
        history.map((h) => h.score).reduce((a, b) => a + b) / totalQuizzes;
    final totalTime = history.map((h) => h.timeTaken).reduce((a, b) => a + b);
    return {
      'totalQuizzes': totalQuizzes,
      'averageScore': averageScore,
      'totalTime': totalTime,
    };
  }

  static Map<String, dynamic> getAdminSummaryStatistics() {
    final quizzes = getCreatedQuizzes();
    int totalParticipants = 0;
    double totalScoreSum = 0;
    int quizCountWithParticipants = 0;
    for (var quiz in quizzes) {
      final participants = getQuizParticipants(quiz.id);
      totalParticipants += participants.length;
      if (participants.isNotEmpty) {
        final avg =
            participants.map((p) => p.score).reduce((a, b) => a + b) /
            participants.length;
        totalScoreSum += avg;
        quizCountWithParticipants++;
      }
    }
    final overallAverageScore = quizCountWithParticipants > 0
        ? totalScoreSum / quizCountWithParticipants
        : 0.0;
    return {
      'totalQuizzes': quizzes.length,
      'totalParticipants': totalParticipants,
      'averageScore': overallAverageScore,
    };
  }

  static List<Question> getQuizQuestions(String quizId) {
    return getQuestionsForQuiz(quizId);
  }

  static void addQuestionToQuiz(String quizId, Question question) {
    if (!_dynamicQuestions.containsKey(quizId)) {
      _dynamicQuestions[quizId] = [];
    }
    _dynamicQuestions[quizId]!.add(question);
  }

  static bool hasRealQuestions(String quizId) {
    if (_dynamicQuestions.containsKey(quizId) &&
        _dynamicQuestions[quizId]!.isNotEmpty) {
      return true;
    }
    return quizId.startsWith('quiz_') && !quizId.contains('custom_');
  }

  static Map<int, int> getUserAnswers(String historyId) {
    return {
      0: 0,
      1: 1,
      2: 2,
      3: 1,
      4: 0,
      5: 2,
      6: 1,
      7: 2,
      8: 1,
      9: 1,
      10: 1,
      11: 2,
      12: 2,
      13: 1,
      14: 2,
      15: 3,
      16: 2,
      17: 3,
      18: 1,
      19: 1,
    };
  }

  static void saveQuizProgress(String quizId, Map<String, dynamic> progress) {
    print('Saving progress for quiz $quizId: $progress');
  }

  static List<Quiz> getCreatedQuizzes() {
    return getQuizzes();
  }

  static List<QuizParticipant> getQuizParticipants(String quizId) {
    final quiz = getQuizById(quizId);
    if (quiz != null && !quiz.isPublished) return [];
    if (!hasRealQuestions(quizId)) return [];
    final now = DateTime.now();
    return [
      QuizParticipant(
        userId: 'user_1',
        userName: 'John Doe',
        userEmail: 'john@example.com',
        score: 95.0,
        timeTaken: 720,
        completedAt: now.subtract(const Duration(days: 1)),
        correctAnswers: 19,
        totalQuestions: 20,
      ),
      QuizParticipant(
        userId: 'user_2',
        userName: 'Jane Smith',
        userEmail: 'jane@example.com',
        score: 85.0,
        timeTaken: 840,
        completedAt: now.subtract(const Duration(days: 2)),
        correctAnswers: 17,
        totalQuestions: 20,
      ),
      QuizParticipant(
        userId: 'user_3',
        userName: 'Bob Johnson',
        userEmail: 'bob@example.com',
        score: 75.0,
        timeTaken: 900,
        completedAt: now.subtract(const Duration(days: 3)),
        correctAnswers: 15,
        totalQuestions: 20,
      ),
      QuizParticipant(
        userId: 'user_4',
        userName: 'Alice Williams',
        userEmail: 'alice@example.com',
        score: 90.0,
        timeTaken: 780,
        completedAt: now.subtract(const Duration(days: 4)),
        correctAnswers: 18,
        totalQuestions: 20,
      ),
      QuizParticipant(
        userId: 'user_5',
        userName: 'Charlie Brown',
        userEmail: 'charlie@example.com',
        score: 70.0,
        timeTaken: 960,
        completedAt: now.subtract(const Duration(days: 5)),
        correctAnswers: 14,
        totalQuestions: 20,
      ),
    ];
  }

  static Map<String, dynamic> getQuizStatistics(String quizId) {
    final participants = getQuizParticipants(quizId);
    if (participants.isEmpty) {
      return {
        'totalParticipants': 0,
        'averageScore': 0.0,
        'completionRate': 0.0,
        'highestScore': 0.0,
        'lowestScore': 0.0,
      };
    }
    final scores = participants.map((p) => p.score).toList();
    final averageScore = scores.reduce((a, b) => a + b) / scores.length;
    final highestScore = scores.reduce((a, b) => a > b ? a : b);
    final lowestScore = scores.reduce((a, b) => a < b ? a : b);
    return {
      'totalParticipants': participants.length,
      'averageScore': averageScore,
      'completionRate': 0.85,
      'highestScore': highestScore,
      'lowestScore': lowestScore,
    };
  }
}
