import 'package:flutter/material.dart';
import 'package:smart_quiz/app/views/home_screen.dart';
import 'package:smart_quiz/app/views/loading_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Error messages
  String? _usernameError;
  String? _passwordError;
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Authentication logic
  void _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    // Reset errors
    setState(() {
      _usernameError = null;
      _passwordError = null;
    });

    // Validation
    if (username.isEmpty) {
      setState(() {
        _usernameError = "Please enter your username";
      });
      return;
    }

    if (password.isEmpty) {
      setState(() {
        _passwordError = "Please enter your password";
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Determine user role based on credentials
    String? role;
    
    // Admin check
    if (username.toLowerCase() == 'admin' && password == '112233') {
      role = 'admin';
    } 
    // User check (you can add more user validation here)
    else if (username.isNotEmpty && password.isNotEmpty) {
      // For demo: any non-admin login is treated as user
      // In production, validate against database
      role = 'user';
    }

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (role != null) {
      // Navigate to home page with role
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Loading(
            nextPage: HomeScreen(
              username: username,
              role: role!,
            ),
          ),
        ),
      );
    } else {
      setState(() {
        _usernameError = "Invalid username or password";
        _passwordError = "Invalid username or password";
        _usernameController.clear();
        _passwordController.clear();
      });
    }
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool isPassword = false,
    IconData? prefixIcon,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: errorText != null ? Colors.red : Colors.transparent,
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
            obscureText: isPassword ? _obscurePassword : false,
            style: const TextStyle(fontSize: 18),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 16),
              prefixIcon: prefixIcon != null
                  ? Icon(prefixIcon, color: Colors.grey.shade400)
                  : null,
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey.shade400,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    )
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
              style: const TextStyle(color: Colors.red, fontSize: 14),
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
              'assets/images/mainLogo.png',
              height: 35,
              color: const Color(0xFF4B2B83),
            ),
            const SizedBox(width: 10),
            const Text(
              "SmartQuiz",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 26,
                fontFamily: 'SFPro',
              ),
            ),
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE6DFF1), Color(0xFFB59AD8), Color(0xFF6A2CA0)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 100),
                const Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'AHKbalThom',
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Welcome back! Please login to continue",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 40),
                _buildInputField(
                  label: "Username",
                  hint: "Enter your username",
                  controller: _usernameController,
                  prefixIcon: Icons.person,
                  errorText: _usernameError,
                ),
                const SizedBox(height: 20),
                _buildInputField(
                  label: "Password",
                  hint: "Enter your password",
                  controller: _passwordController,
                  isPassword: true,
                  prefixIcon: Icons.lock,
                  errorText: _passwordError,
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6A2CA0),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 30),
                // Divider
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.black.withOpacity(0.3),
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "Or Login With",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.black.withOpacity(0.3),
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                // Social Login Icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialIcon("assets/images/google.png"),
                    const SizedBox(width: 20),
                    _buildSocialIcon("assets/images/facebook.png"),
                    const SizedBox(width: 20),
                    _buildSocialIcon("assets/images/image copy.png"),
                  ],
                ),
                
                
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialIcon(String assetPath) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.white.withOpacity(0.6),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Image.asset(assetPath, fit: BoxFit.contain),
      ),
    );
  }
}

