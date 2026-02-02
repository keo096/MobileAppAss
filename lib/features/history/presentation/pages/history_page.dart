import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: QuizHistory(),
    debugShowCheckedModeBanner: false,
  ));
}

class QuizHistory extends StatelessWidget {
  const QuizHistory({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryPurple = Color(0xFF6C34C4);
    const Color backgroundGray = Color(0xFFF3F1F7);

    return Scaffold(
      backgroundColor: backgroundGray,
      body: Column(
        children: [
          // --- Fixed Header Section ---
          Container(
            padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 20),
            decoration: const BoxDecoration(
              color: primaryPurple,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Quiz History',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SFPro',
                        letterSpacing: 1,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.tune, color: Colors.white, size: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _TabItem(title: 'All', isActive: true),
                    _TabItem(title: 'Completed'),
                    _TabItem(title: 'In Progress'),
                    _TabItem(title: 'Saved'),
                  ],
                ),
              ],
            ),
          ),

          // --- Scrollable Content ---
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              children: [
                const _StatsCard(),
                const SizedBox(height: 20),
                _QuizCard(
                  title: 'Tense',
                  subtitle: 'present simple',
                  score: '100%',
                  time: '12 min',
                  date: '24 Jan, 2026',
                  status: QuizStatus.done,
                  progress: 1.0,
                  iconLetter: 'T',
                  iconColor: Colors.blue.shade600,
                ),
                _QuizCard(
                  title: 'Tense',
                  subtitle: 'past simple',
                  score: '100%',
                  time: '12 min',
                  date: '24 Jan, 2026',
                  status: QuizStatus.done,
                  progress: 1.0,
                  iconLetter: 'T',
                  iconColor: Colors.blue.shade600,
                ),
                _QuizCard(
                  title: 'Preposition',
                  subtitle: 'time, place, movement',
                  score: '75%',
                  time: '12 min',
                  date: '24 Jan, 2026',
                  status: QuizStatus.resume,
                  progress: 0.75,
                  iconLetter: 'P',
                  iconColor: Colors.green.shade600,
                ),
                _QuizCard(
                  title: 'Passive Voice',
                  subtitle: 'present, past',
                  score: '75%',
                  time: '12 min',
                  date: '24 Jan, 2026',
                  status: QuizStatus.resume,
                  progress: 0.75,
                  iconLetter: 'P',
                  iconColor: Colors.cyan.shade600,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- Supporting Widgets ---

enum QuizStatus { done, resume }

class _TabItem extends StatelessWidget {
  final String title;
  final bool isActive;
  const _TabItem({required this.title, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.white70,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 15,
          ),
        ),
        if (isActive)
          Container(
            margin: const EdgeInsets.only(top: 4),
            height: 2,
            width: 18,
            color: Colors.white,
          )
      ],
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            const Icon(Icons.grid_view_rounded, color: Colors.indigo, size: 30),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Quizzes', style: TextStyle(color: Colors.grey, fontSize: 15,fontFamily: 'SFPro')),
                Text('56', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,fontFamily: 'SFPro')),
              ],
            ),
            const Spacer(),
            const VerticalDivider(thickness: 1, color: Color(0xFFEEEEEE)),
            const Spacer(),
            const Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 38,
                  width: 38,
                  child: CircularProgressIndicator(
                    value: 1.0,
                    strokeWidth: 3,
                    color: Color(0xFF6C34C4),
                  ),
                ),
                Text('100%', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold,fontFamily: 'SFPro')),
              ],
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Average Score', style: TextStyle(color: Colors.grey, fontSize: 15,fontFamily: 'SFPro')),
                Text('2h 15mn', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,fontFamily: 'SFPro')),
              ],
            ),
            const SizedBox(width: 5),
            const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }
}

class _QuizCard extends StatelessWidget {
  final String title, subtitle, score, time, date, iconLetter;
  final Color iconColor;
  final double progress;
  final QuizStatus status;

  const _QuizCard({
    required this.title,
    required this.subtitle,
    required this.score,
    required this.time,
    required this.date,
    required this.iconLetter,
    required this.iconColor,
    required this.progress,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    bool isDone = status == QuizStatus.done;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: iconColor,
                radius: 24,
                child: Text(iconLetter,
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold,fontFamily: 'SFPro')),
              ),
              const SizedBox(width: 12),
              
              // --- Solution to Overflow: Wrap middle section in Expanded ---
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(color: Colors.grey, fontSize: 12,fontFamily: 'SFPro'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    // Use FittedBox or Wrap to ensure labels don't overflow
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        children: [
                          const Icon(Icons.access_time, size: 13, color: Colors.deepPurple),
                          const SizedBox(width: 4),
                          Text(time, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                          const Text('  |  ', style: TextStyle(color: Colors.grey)),
                          Text(score, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                          const Text('  |  ', style: TextStyle(color: Colors.grey)),
                          Text(date, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              
              // Action Button
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: isDone ? Colors.green : Colors.orange),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  isDone ? 'Done' : 'Resume',
                  style: TextStyle(
                    color: isDone ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SFPro',
                    fontSize: 15,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade100,
              valueColor: AlwaysStoppedAnimation<Color>(
                isDone ? Colors.green : Colors.orange,
              ),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}