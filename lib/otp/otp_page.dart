import 'dart:async';
import 'package:flutter/material.dart';
import 'package:projectsemester4/services/api_service.dart';
import 'package:projectsemester4/resetpassword/resetpassword.dart';
import '../widgets/otp/otp_ui.dart';
import '../screens/login_page.dart';

class OtpPage extends StatefulWidget {
  final String email;
  final String type;

  const OtpPage({
    Key? key,
    required this.email,
    required this.type,
  }) : super(key: key);

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final otpController = TextEditingController();

  bool isVerifying = false;
  bool isResending = false;

  Timer? resendTimer;
  int resendSeconds = 0;

  // =========================
  // TIMER RESEND OTP
  // =========================

  void startResendTimer() {
    resendSeconds = 20;
    resendTimer?.cancel();

    resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendSeconds == 0) {
        timer.cancel();
      } else {
        setState(() {
          resendSeconds--;
        });
      }
    });
  }

  // =========================
  // SUCCESS DIALOG
  // =========================

  void showSuccessDialog() {
    String title = "Verifikasi Berhasil";
    String subtitle = "OTP berhasil diverifikasi";

    if (widget.type == 'register') {
      subtitle = "Akun berhasil dibuat, silakan login";
    } else if (widget.type == 'forgot') {
      subtitle = "OTP valid, silakan ubah password baru";
    } else if (widget.type == 'login') {
      subtitle = "OTP berhasil diverifikasi";
    }

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

                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF22313F),
                      decoration: TextDecoration.none,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
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
  // VERIFY OTP
  // =========================

  Future<void> verifyOtp() async {
    if (isVerifying) return;

    if (otpController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Masukkan OTP")),
      );
      return;
    }

    setState(() => isVerifying = true);

    try {
      final data = await ApiService.verifyOtp(
        widget.email,
        otpController.text.trim(),
        widget.type,
      );

      if (!mounted) return;

      if (data['status'] == true) {
        showSuccessDialog();

        await Future.delayed(const Duration(seconds: 3));

        if (!mounted) return;

        Navigator.pop(context);

        if (widget.type == 'register' || widget.type == 'login') {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
          );
        } else if (widget.type == 'forgot') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => ResetPasswordPage(email: widget.email),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? "OTP salah")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Terjadi kesalahan")),
      );
    } finally {
      if (mounted) {
        setState(() => isVerifying = false);
      }
    }
  }

  // =========================
  // RESEND OTP
  // =========================

  Future<void> resendOtp() async {
    if (resendSeconds > 0 || isResending) return;

    setState(() => isResending = true);

    try {
      final data = await ApiService.resendOtp(
        widget.email,
        widget.type,
      );

      if (!mounted) return;

      if (data['status'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("OTP berhasil dikirim ulang")),
        );

        startResendTimer();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? "Gagal kirim OTP")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isResending = false);
      }
    }
  }

  // =========================
  // DISPOSE
  // =========================

  @override
  void dispose() {
    resendTimer?.cancel();
    otpController.dispose();
    super.dispose();
  }

  // =========================
  // UI
  // =========================

  @override
  Widget build(BuildContext context) {
    return OtpUI(
      email: widget.email,
      otpController: otpController,
      isVerifying: isVerifying,
      isResending: isResending,
      resendSeconds: resendSeconds,
      onVerify: verifyOtp,
      onResend: resendOtp,
      onBack: () => Navigator.pop(context),
    );
  }
}