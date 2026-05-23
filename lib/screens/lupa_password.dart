import 'package:flutter/material.dart';
import 'package:projectsemester4/services/api_service.dart';

import '../otp/otp_page.dart';
import '../widgets/auth/lupa_password_ui.dart';

class LupaPasswordPage extends StatefulWidget {
  final String email;

  const LupaPasswordPage({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  State<LupaPasswordPage> createState() =>
      _LupaPasswordPageState();
}

class _LupaPasswordPageState
    extends State<LupaPasswordPage> {
  // =========================
  // CONTROLLER
  // =========================

  late TextEditingController emailController;

  bool isLoading = false;

  // =========================
  // INIT STATE
  // =========================

  @override
  void initState() {
    super.initState();

    emailController = TextEditingController(
      text: widget.email,
    );
  }

  // =========================
  // SEND OTP
  // =========================

  Future<void> kirimOtp() async {
    // Mencegah double click
    if (isLoading) return;

    final email = emailController.text.trim();

    // VALIDASI KOSONG
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Email tidak boleh kosong",
          ),
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
          content: Text(
            "Format email tidak valid",
          ),
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final data = await ApiService.forgotPassword(
        email,
      );

      if (!mounted) return;

      if (data['status'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "OTP telah dikirim ke email",
            ),
          ),
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OtpPage(
              email: email,
              type: 'forgot',
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              data['message'] ??
                  "Gagal mengirim OTP",
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

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
    emailController.dispose();
    super.dispose();
  }

  // =========================
  // UI
  // =========================

  @override
  Widget build(BuildContext context) {
    return LupaPasswordUI(
      emailController: emailController,
      isLoading: isLoading,
      onSendOtp: kirimOtp,
    );
  }
}