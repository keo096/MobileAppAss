import 'package:flutter/material.dart';

class QuizCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final String buttonText;

  const QuizCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 166, 93, 197),
            Color.fromARGB(255, 149, 34, 250),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Image.asset(imagePath, width: 100, height: 100),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'SFPro',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                    fontFamily: 'SFPro',
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: const StadiumBorder(),
                  ),
                  child: Text(
                    buttonText,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontFamily: 'SFPro',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

