import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:projectsemester4/services/api_service.dart';

import '../otp/otp_page.dart';
import '../widgets/auth/register_ui.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // =========================
  // CONTROLLER
  // =========================

  final nimController = TextEditingController();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final noHpController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  bool obscurePassword = true;

  // =========================
  // VALIDASI EMAIL
  // =========================

  bool isValidEmail(String email) {
    return RegExp(r"^[\w-\.]+@gmail\.com$")
        .hasMatch(email);
  }

  // =========================
  // VALIDASI USERNAME
  // =========================

  bool isValidUsername(String username) {
    return RegExp(r'^[a-zA-Z0-9_]+$')
        .hasMatch(username);
  }

  // =========================
  // VALIDASI PASSWORD
  // =========================

  bool isValidPassword(String password) {
    return RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$',
    ).hasMatch(password);
  }

  // =========================
  // VALIDASI NOMOR HP
  // =========================

  bool isValidPhone(String phone) {
    return RegExp(r'^0[0-9]{9,12}$')
        .hasMatch(phone);
  }

  // =========================
  // REGISTER
  // =========================

  Future<void> register() async {
    if (isLoading) return;

    final nim = nimController.text.trim();
    final email = emailController.text.trim();
    final username = usernameController.text.trim();
    final noHp = noHpController.text.trim();
    final password = passwordController.text.trim();

    // VALIDASI KOSONG
    if (nim.isEmpty ||
        email.isEmpty ||
        username.isEmpty ||
        noHp.isEmpty ||
        password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Semua field wajib diisi",
          ),
        ),
      );
      return;
    }

    // VALIDASI EMAIL
    if (!isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Email harus menggunakan format @gmail.com",
          ),
        ),
      );
      return;
    }

    // VALIDASI USERNAME
    if (!isValidUsername(username)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Username tidak boleh mengandung simbol atau emote",
          ),
        ),
      );
      return;
    }

    // VALIDASI NOMOR HP
    if (!isValidPhone(noHp)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Nomor HP harus diawali 0 dan terdiri dari 10-13 angka",
          ),
        ),
      );
      return;
    }

    // VALIDASI PASSWORD
    if (!isValidPassword(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Password minimal 8 karakter, wajib huruf besar, kecil, dan angka",
          ),
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final data = await ApiService.register(
        nim,
        email,
        username,
        noHp,
        password,
      );

      if (!mounted) return;

      if (data['status'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("OTP berhasil dikirim"),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => OtpPage(
              email: email,
              type: 'register',
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              data['message'] ?? "Register gagal",
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } on TimeoutException {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Server lama merespon",
          ),
        ),
      );
    } on SocketException {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Tidak ada koneksi internet",
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  // =========================
  // DISPOSE
  // =========================

  @override
  void dispose() {
    nimController.dispose();
    emailController.dispose();
    usernameController.dispose();
    noHpController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // =========================
  // UI
  // =========================

  @override
  Widget build(BuildContext context) {
    return RegisterUI(
      nimController: nimController,
      emailController: emailController,
      usernameController: usernameController,
      noHpController: noHpController,
      passwordController: passwordController,

      isLoading: isLoading,
      obscurePassword: obscurePassword,

      onTogglePassword: () {
        setState(() {
          obscurePassword = !obscurePassword;
        });
      },

      onRegister: register,
    );
  }
}