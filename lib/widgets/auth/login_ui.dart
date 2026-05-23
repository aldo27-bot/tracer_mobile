import 'package:flutter/material.dart';

import '../../screens/lupa_password.dart';
import '../../screens/register_page.dart';

class LoginUI extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  final bool isLoading;
  final bool obscurePassword;

  final VoidCallback onTogglePassword;
  final VoidCallback onLogin;

  const LoginUI({
    Key? key,
    required this.emailController,
    required this.passwordController,
    required this.isLoading,
    required this.obscurePassword,
    required this.onTogglePassword,
    required this.onLogin,
  }) : super(key: key);

  Widget buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(18),
      ),

      child: TextField(
        controller: controller,
        obscureText: isPassword ? obscurePassword : false,

        keyboardType: isPassword
            ? TextInputType.text
            : TextInputType.emailAddress,

        textInputAction: isPassword
            ? TextInputAction.done
            : TextInputAction.next,

        onSubmitted: isPassword
            ? (_) => onLogin()
            : null,

        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          prefixIcon: Icon(icon, color: Colors.grey),

          suffixIcon: isPassword
              ? IconButton(
                  onPressed: onTogglePassword,
                  icon: Icon(
                    obscurePassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Colors.grey,
                  ),
                )
              : null,

          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFF7F7F7),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 30),

            child: Column(
              children: [
                // TOP SHAPE
                Stack(
                  children: [
                    Container(
                      height: 220,
                      decoration: const BoxDecoration(
                        color: Color(0xFF0F2D3F),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(120),
                          bottomRight: Radius.circular(120),
                        ),
                      ),
                    ),

                    Positioned(
                      top: 35,
                      left: 20,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Color(0xFF5D7B93),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),

                    Positioned(
                      top: 45,
                      right: 20,
                      child: Icon(
                        Icons.school,
                        size: 90,
                        color: Colors.white.withOpacity(0.15),
                      ),
                    ),
                  ],
                ),

                // LOGIN CARD
                Transform.translate(
                  offset: const Offset(0, -40),

                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),

                    child: Container(
                      padding: const EdgeInsets.all(22),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),

                      child: Column(
                        children: [
                          Container(
                            height: 120,
                            width: double.infinity,

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              color: const Color(0xFF22313F),
                            ),

                            child: Center(
                              child: Image.asset(
                                "assets/tracer1.png",
                                width: 560,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF22313F),
                              ),
                            ),
                          ),

                          const SizedBox(height: 6),

                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Login untuk melanjutkan.",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          buildInputField(
                            controller: emailController,
                            hint: "Email",
                            icon: Icons.person_outline,
                          ),

                          buildInputField(
                            controller: passwordController,
                            hint: "Password",
                            icon: Icons.lock_outline,
                            isPassword: true,
                          ),

                          Align(
                            alignment: Alignment.centerRight,

                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => LupaPasswordPage(
                                      email: emailController.text.trim(),
                                    ),
                                  ),
                                );
                              },

                              child: const Text(
                                "Lupa Password?",
                                style: TextStyle(
                                  color: Color(0xFF0F2D3F),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          SizedBox(
                            width: double.infinity,
                            height: 54,

                            child: ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : onLogin,

                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(0xFF0F2D3F),
                                elevation: 0,

                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(18),
                                ),
                              ),

                              child: isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text(
                                      "Login",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.center,

                            children: [
                              const Text(
                                "Belum punya akun? ",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),

                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const RegisterPage(),
                                    ),
                                  );
                                },

                                child: const Text(
                                  "Register",
                                  style: TextStyle(
                                    color: Color(0xFF0F2D3F),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}