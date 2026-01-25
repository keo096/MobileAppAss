import 'package:flutter/material.dart';
import 'package:smart_quiz/core/widgets/loading_widget.dart';
import 'package:smart_quiz/core/constants/app_colors.dart';
import 'package:smart_quiz/core/constants/app_strings.dart';
import 'package:smart_quiz/core/constants/app_assets.dart';
import 'package:smart_quiz/core/theme/app_theme.dart';
import 'package:smart_quiz/features/home/presentation/pages/home_page.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Error messages
  String? _usernameError;
  String? _passwordError;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    setState(() {
      _usernameError = username.isEmpty ? AppStrings.pleaseInputUsername : null;
      _passwordError = password.isEmpty ? AppStrings.pleaseInputPassword : null;

      if (_usernameError == null && _passwordError == null) {
        if (username == 'admin' && password == '112233') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  LoadingWidget(nextPage: UserHomePage(username: username)),
            ),
          );
        } else {
          _usernameError = AppStrings.invalidCredentials;
          _passwordError = AppStrings.invalidCredentials;
          _usernameController.clear();
          _passwordController.clear();
        }
      }
    });
  }

  Widget _buildInputField(
    String label,
    String hint, {
    bool isPassword = false,
    required TextEditingController controller,
    IconData? icon,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.label,
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundWhite,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: errorText != null ? AppColors.error : Colors.transparent,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            obscureText: isPassword,
            style: const TextStyle(fontSize: 18),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 16),
              prefixIcon: icon != null
                  ? Icon(icon, color: Colors.grey.shade400)
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 5),
            child: Text(
              errorText,
              style: AppTheme.caption.copyWith(color: AppColors.error),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black54),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              AppAssets.mainLogo,
              height: 35,
              color: AppColors.primaryPurpleLogo,
            ),
            const SizedBox(width: 10),
            Text(
              AppStrings.appName,
              style: AppTheme.headingMedium,
            ),
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradient,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 140),
              Text(
                AppStrings.login,
                style: AppTheme.headingLarge,
              ),
              const SizedBox(height: 30),
              _buildInputField(
                AppStrings.username,
                AppStrings.enterUsername,
                controller: _usernameController,
                icon: Icons.person,
                errorText: _usernameError,
              ),
              const SizedBox(height: 20),
              _buildInputField(
                AppStrings.password,
                AppStrings.enterPassword,
                controller: _passwordController,
                isPassword: true,
                icon: Icons.lock,
                errorText: _passwordError,
              ),
              const SizedBox(height: 40),

              // Divider
              Row(
                children: [
                  const Expanded(child: Divider(color: Colors.black38, thickness: 1)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      AppStrings.orLoginWith,
                      style: AppTheme.caption.copyWith(
                        color: AppColors.textBlack87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider(color: Colors.black38, thickness: 1)),
                ],
              ),
              const SizedBox(height: 25),

              // Perfected Social Icons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: const Color.fromARGB(159, 255, 255, 255),
                    ),
                    child: Image.asset(AppAssets.googleIcon),
                  ),
                  SizedBox(width: 20),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: const Color.fromARGB(159, 255, 255, 255),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: Image.asset(AppAssets.facebookIcon),
                    ),
                  ),
                  SizedBox(width: 20),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: const Color.fromARGB(159, 255, 255, 255),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(AppAssets.appleIcon),
                    ),
                  ),
                  // Container(width: 50, height: 50, color: Colors.amber),
                ],
              ),
              SizedBox(height: 170),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.backgroundGrey,
                    foregroundColor: AppColors.textBlack,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    AppStrings.login,
                    style: AppTheme.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
