import 'package:flutter/material.dart';
import 'package:smart_quiz/core/widgets/loading_widget.dart';
import 'package:smart_quiz/core/constants/app_colors.dart';
import 'package:smart_quiz/core/constants/app_strings.dart';
import 'package:smart_quiz/core/constants/app_assets.dart';
import 'package:smart_quiz/core/theme/app_theme.dart';
import 'package:smart_quiz/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:smart_quiz/features/home/presentation/pages/home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Error messages
  String? _usernameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  // Password visibility
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    setState(() {
      _usernameError = username.isEmpty ? AppStrings.pleaseInputUsername : null;
      _emailError = email.isEmpty ? "Please input email" : null;
      _passwordError = password.isEmpty ? AppStrings.pleaseInputPassword : null;
      _confirmPasswordError = confirmPassword.isEmpty
          ? "Please confirm password"
          : password != confirmPassword
          ? "Passwords do not match"
          : null;

      if (_usernameError == null &&
          _emailError == null &&
          _passwordError == null &&
          _confirmPasswordError == null) {
        // TODO: Implement actual registration logic
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoadingWidget(nextPage: const UserHomePage()),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                // Logo
                Center(
                  child: Image.asset(
                    AppAssets.mainLogo,
                    width: 120,
                    height: 120,
                  ),
                ),
                const SizedBox(height: 30),
                // Title
                Text(
                  AppStrings.register,
                  style: AppTheme.headingLarge.copyWith(
                    color: AppColors.textWhite,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                // Username Field
                AuthTextField(
                  label: AppStrings.username,
                  hint: AppStrings.enterUsername,
                  controller: _usernameController,
                  prefixIcon: Icons.person_outline,
                  errorText: _usernameError,
                ),
                const SizedBox(height: 20),
                // Email Field
                AuthTextField(
                  label: "Email",
                  hint: "Enter your email",
                  controller: _emailController,
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  errorText: _emailError,
                ),
                const SizedBox(height: 20),
                // Password Field
                AuthTextField(
                  label: AppStrings.password,
                  hint: AppStrings.enterPassword,
                  controller: _passwordController,
                  isPassword: true,
                  obscureText: _obscurePassword,
                  prefixIcon: Icons.lock_outline,
                  errorText: _passwordError,
                  onToggleVisibility: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                const SizedBox(height: 20),
                // Confirm Password Field
                AuthTextField(
                  label: "Confirm Password",
                  hint: "Re-enter your password",
                  controller: _confirmPasswordController,
                  isPassword: true,
                  obscureText: _obscureConfirmPassword,
                  prefixIcon: Icons.lock_outline,
                  errorText: _confirmPasswordError,
                  onToggleVisibility: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
                const SizedBox(height: 30),
                // Register Button
                ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.textWhite,
                    foregroundColor: AppColors.primaryPurple,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    AppStrings.register,
                    style: AppTheme.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppColors.textWhite,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        AppStrings.login,
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppColors.textWhite,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
