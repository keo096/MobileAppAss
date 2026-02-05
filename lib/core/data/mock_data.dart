import 'package:flutter/material.dart';
import 'package:smart_quiz/core/models/category_model.dart';
import 'package:smart_quiz/core/models/quiz_model.dart';
import 'package:smart_quiz/core/models/history_model.dart';
import 'package:smart_quiz/core/models/user_model.dart';
import 'package:smart_quiz/core/models/quiz_participant_model.dart';

/// Source of truth for raw mock data.
/// This file now only contains data, no business logic.
class MockData {
  MockData._();

  // ============================================
  // RAW CATEGORIES
  // ============================================
  static final List<Category> rawCategories = [
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

  // ============================================
  // RAW QUIZZES
  // ============================================
  static final List<Quiz> rawQuizzes = [
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
  ];

  // ============================================
  // RAW QUESTIONS
  // ============================================
  static final Map<String, List<Question>> rawQuestions = {
    'quiz_1': [
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
    ],
    'quiz_history_1': [
      Question(
        id: 'qh1_1',
        question: 'Which King built Angkor Wat?',
        options: ['Jayavarman VII', 'Suryavarman II', 'Ang Duong', 'Norodom'],
        correctAnswer: 1,
        explanation:
            'Suryavarman II built Angkor Wat in the early 12th century.',
        points: 10,
      ),
    ],
  };

  // ============================================
  // RAW HISTORY
  // ============================================
  static final List<QuizHistory> rawHistory = [
    QuizHistory(
      id: 'history_1',
      quizId: 'quiz_1',
      quizTitle: 'Tense',
      category: 'present simple',
      totalQuestions: 10,
      correctAnswers: 10,
      score: 100.0,
      timeTaken: 720,
      completedAt: DateTime.now().subtract(const Duration(days: 2)),
      difficulty: 'easy',
      status: 'completed',
    ),
  ];

  // ============================================
  // RAW LEADERBOARD
  // ============================================
  static final List<LeaderboardEntry> rawLeaderboard = [
    LeaderboardEntry(
      userId: 'user_1',
      username: 'QuizMaster',
      totalScore: 2500,
      totalQuizzes: 50,
      averageScore: 85.2,
      rank: 1,
    ),
  ];

  // Generator for dynamic participants
  static List<QuizParticipant> generateMockParticipants(String quizId) {
    return [
      QuizParticipant(
        userId: 'user_p1',
        userName: 'John Doe',
        userEmail: 'john@example.com',
        score: 95.0,
        timeTaken: 720,
        completedAt: DateTime.now().subtract(const Duration(days: 1)),
        correctAnswers: 19,
        totalQuestions: 20,
      ),
    ];
  }
}
