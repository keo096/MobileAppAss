import 'package:flutter/material.dart';
import 'package:smart_quiz/features/auth/presentation/pages/login_page.dart';
import 'package:smart_quiz/core/constants/app_colors.dart';
import 'package:smart_quiz/core/constants/app_strings.dart';
import 'package:smart_quiz/core/constants/app_assets.dart';
import 'package:smart_quiz/core/theme/app_theme.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _steps = [
    {
      "title": AppStrings.onboardingTitle1,
      "desc": AppStrings.onboardingDesc1,
      "img": AppAssets.onboarding1,
    },
    {
      "title": AppStrings.onboardingTitle2,
      "desc": AppStrings.onboardingDesc2,
      "img": AppAssets.onboarding2,
    },
    {
      "title": AppStrings.onboardingTitle3,
      "desc": AppStrings.onboardingDesc3,
      "img": AppAssets.onboarding3,
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
                  title: Text(
                    AppStrings.appName,
                    style: const TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w900,
                      fontFamily: AppTheme.fontFamilySFPro,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(AppStrings.appTagline),
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
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10, width: 10),
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
                    (index) => _buildDot(isActive: _currentPage == index),
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentPage < _steps.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Login(),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPurpleDark,
                        shape: const StadiumBorder(),
                        elevation: 0,
                      ),
                      child: Text(
                        _currentPage == _steps.length - 1
                            ? AppStrings.getStarted
                            : AppStrings.next,
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppColors.textWhite,
                        ),
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
      width: isActive ? 24 : 10,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primaryPurpleDark : AppColors.textGrey,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

