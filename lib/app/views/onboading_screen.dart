
import 'package:flutter/material.dart';
import 'package:smart_quiz/app/views/auth/user_auth/userLogin_screen.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  // 1. Controller to handle page movement
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final Color primaryPurple = const Color(0xFF4A306D);

  // Data for our steps
  final List<Map<String, String>> _steps = [
    {
      "title": "Learn Smarter with Quizzes",
      "desc": "Practise Knowledge anytime, anywhere",
      "img": "assets/images/onboard1.png"
    },
    {
      "title": "Choose your Topic",
      "desc": "General knowledge,\nEnglish,\ntechnology& \nmore",
      "img": "assets/images/onboard2.png" 
    },
    {
      "title": "Track Your Progress",
      "desc": "Instant feedback and time-based quizzes",
      "img": "assets/images/onboard3.png"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 100.0),
              child: Container(
                width: 400,
                height: 40,
                child: ListTile(
                  title: Text("Smart Quiz",style: TextStyle(fontSize: 35,fontWeight: FontWeight.w900,fontFamily: 'SFPro'),),
                  subtitle: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text("We are learner & Creator"),
                  ),
                ),
              ),
            ),
        
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemCount: _steps.length,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(_steps[index]["img"]!, width: 250),
                      Text(
                        _steps[index]["title"]!,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10,width: 10,),
                      Text(
                        _steps[index]["desc"]!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  );
                },
              ),
            ),
        
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _steps.length,
                    (index) => GestureDetector(
                      onTap: () {
                        _pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                        child: _buildDot(isActive: _currentPage == index),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
        
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: (
                      ) {
                        if (_currentPage < _steps.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                         Navigator.push(context, MaterialPageRoute(builder: (context)=> const Login()));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryPurple,
                        shape: const StadiumBorder(),
                        elevation: 0,
                      ),
                      child: Text(
                        _currentPage == _steps.length - 1 ? "Get Started" : "Next",
                        style: const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDot({required bool isActive}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 6,
      width: isActive ? 24 : 10, // Active dot is wider
      decoration: BoxDecoration(
        color: isActive ? primaryPurple : Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}