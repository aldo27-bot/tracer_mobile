import 'package:flutter/material.dart';
import 'package:projectsemester4/services/api_service.dart';
import '../widgets/reset_password/reset_password_ui.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;

  const ResetPasswordPage({Key? key, required this.email}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final passwordController = TextEditingController();
  bool isLoading = false;

  bool isValidPassword(String password) {
    return RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$').hasMatch(password);
  }

  Future<void> resetPassword() async {
    final password = passwordController.text.trim();

    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password tidak boleh kosong")),
      );
      return;
    }

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
      final response = await ApiService.resetPassword(widget.email, password);

      if (!mounted) return;

      // PASSWORD SAMA DENGAN PASSWORD LAMA
      if (response['message'] ==
          "Password baru tidak boleh sama dengan password lama") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Password baru tidak boleh sama dengan password lama",
            ),
          ),
        );
        return;
      }

      if (response['status'] == true) {
        showSuccessDialog();

        await Future.delayed(const Duration(seconds: 3));

        if (mounted) {
          Navigator.pop(context);
        }

        Navigator.popUntil(context, (route) => route.isFirst);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? "Gagal reset")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResetPasswordUI(
      email: widget.email,
      controller: passwordController,
      isLoading: isLoading,
      onSubmit: resetPassword,
      onBack: () => Navigator.pop(context),
    );
  }

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
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
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
                    "Password Berhasil Diubah",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF22313F),
                      decoration: TextDecoration.none,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Silakan login menggunakan password baru",
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

      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return Transform.scale(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutBack,
          ).value,
          child: Opacity(opacity: animation.value, child: child),
        );
      },
    );
  }
}
