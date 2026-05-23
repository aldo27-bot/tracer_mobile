import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:projectsemester4/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../otp/otp_page.dart';
import '../widgets/auth/login_ui.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // =========================
  // CONTROLLER
  // =========================

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  bool obscurePassword = true;

  // =========================
  // SAFE PARSER
  // =========================

  String safeString(dynamic value) {
    return value?.toString() ?? '';
  }

  int safeInt(dynamic value) {
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  // =========================
  // LOGIN
  // =========================

  Future<void> login() async {
    if (isLoading) return;

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // VALIDASI KOSONG
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email dan password tidak boleh kosong"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // VALIDASI EMAIL
    final emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    );

    if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Format email tidak valid"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final data = await ApiService.login(email, password);

      print("LOGIN RESPONSE: $data");

      if (data['status'] == true) {
        final prefs = await SharedPreferences.getInstance();

        final user = data['user'] ?? {};

        await prefs.setBool('isLogin', true);
        await prefs.setString('name', safeString(user['name']));
        await prefs.setInt('user_id', safeInt(user['user_id']));
        await prefs.setString('auth_token', safeString(data['token']));
        await prefs.setString('image', safeString(user['image']));
        await prefs.setString('alamat', safeString(user['alamat']));

        if (!mounted) return;

        showSuccessDialog();

        await Future.delayed(const Duration(seconds: 3));

        if (mounted) {
          Navigator.pop(context);
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => MainPage(),
          ),
        );
      } else {
        if (data['message'] == "Akun belum verifikasi OTP") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OtpPage(
                email: email,
                type: 'login',
              ),
            ),
          );
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              data['message'] ?? "Login gagal",
            ),
          ),
        );
      }
    } on TimeoutException {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Server terlalu lama merespon"),
        ),
      );
    } on SocketException {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Tidak bisa terhubung ke server"),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  // =========================
  // SUCCESS DIALOG
  // =========================

  void showSuccessDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: "Success",
      barrierColor: Colors.black.withOpacity(0.45),
      transitionDuration: const Duration(milliseconds: 500),

      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            padding: const EdgeInsets.symmetric(
              horizontal: 28,
              vertical: 32,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),

            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 700),
                    curve: Curves.elasticOut,

                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Container(
                          width: 95,
                          height: 95,
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            shape: BoxShape.circle,
                          ),

                          child: Icon(
                            Icons.check_rounded,
                            color: Colors.green.shade600,
                            size: 58,
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    "Login Berhasil",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF22313F),
                      decoration: TextDecoration.none,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Selamat datang di aplikasi Tracer Study",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },

      transitionBuilder:
          (context, animation, secondaryAnimation, child) {
        return Transform.scale(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutBack,
          ).value,
          child: Opacity(
            opacity: animation.value,
            child: child,
          ),
        );
      },
    );
  }

  // =========================
  // DISPOSE
  // =========================

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // =========================
  // UI
  // =========================

  @override
  Widget build(BuildContext context) {
    return LoginUI(
      emailController: emailController,
      passwordController: passwordController,
      isLoading: isLoading,
      obscurePassword: obscurePassword,

      onTogglePassword: () {
        setState(() {
          obscurePassword = !obscurePassword;
        });
      },

      onLogin: login,
    );
  }
}