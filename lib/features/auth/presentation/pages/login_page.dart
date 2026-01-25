import 'package:flutter/material.dart';
import 'package:smart_quiz/app/views/loading_screen.dart';
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
      _usernameError = username.isEmpty ? "Please input username" : null;
      _passwordError = password.isEmpty ? "Please input password" : null;

      if (_usernameError == null && _passwordError == null) {
        if (username == 'admin' && password == '112233') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  Loading(nextPage: UserHomePage(username: username)),
            ),
          );
        } else {
          _usernameError = "Invalid username or password";
          _passwordError = "Invalid username or password";
          _usernameController.clear();
          _passwordController.clear();
        }
      }
    });
  }

  // Optimized Social Icon Widget
  Widget _socialIcon(String assetPath, {required double extraPadding}) {
    return Container(
      width: 55,
      height: 55,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0), // Consistent internal spacing
        child: Image.asset(assetPath, fit: BoxFit.contain),
      ),
    );
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 140),
              const Text(
                "Login",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'AHKbalThom',
                ),
              ),
              const SizedBox(height: 30),
              _buildInputField(
                "Username",
                "Enter your username",
                controller: _usernameController,
                icon: Icons.person,
                errorText: _usernameError,
              ),
              const SizedBox(height: 20),
              _buildInputField(
                "Password",
                "Enter your password",
                controller: _passwordController,
                isPassword: true,
                icon: Icons.lock,
                errorText: _passwordError,
              ),
              const SizedBox(height: 40),

              // Divider
              Row(
                children: const [
                  Expanded(child: Divider(color: Colors.black38, thickness: 1)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "Or Login With",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.black38, thickness: 1)),
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
                    child: Image.asset("assets/images/google.png"),
                  ),
                  SizedBox(width: 20),
                  // Container(width: 50, height: 50, color: Colors.amber),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: const Color.fromARGB(159, 255, 255, 255),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: Image.asset("assets/images/facebook.png"),
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
                      child: Image.asset("assets/images/image copy.png"),
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
                    backgroundColor: const Color(0xFFE0E0E0),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

Widget _socialIcon(String assetPath, {double extraPadding = 10.0}) {
  return Container(
    width: 55,
    height: 55,
    decoration: const BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
    ),
    child: Padding(
      // We use the extraPadding variable here to shrink the icon inside the circle
      padding: EdgeInsets.all(extraPadding),
      child: Image.asset(assetPath, fit: BoxFit.contain),
    ),
  );
}
