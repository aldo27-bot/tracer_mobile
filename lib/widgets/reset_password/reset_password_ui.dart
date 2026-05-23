import 'package:flutter/material.dart';

class ResetPasswordUI extends StatefulWidget {
  final String email;
  final TextEditingController controller;
  final bool isLoading;

  final VoidCallback onSubmit;
  final VoidCallback onBack;

  const ResetPasswordUI({
    super.key,
    required this.email,
    required this.controller,
    required this.isLoading,
    required this.onSubmit,
    required this.onBack,
  });

  @override
  State<ResetPasswordUI> createState() => _ResetPasswordUIState();
}

class _ResetPasswordUIState extends State<ResetPasswordUI> {
  bool obscurePassword = true;

  Widget buildInputField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(18),
      ),
      child: TextField(
        controller: widget.controller,
        obscureText: obscurePassword,
        decoration: InputDecoration(
          hintText: "Password Baru",
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),

          suffixIcon: IconButton(
            icon: Icon(
              obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                obscurePassword = !obscurePassword;
              });
            },
          ),

          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                    top: 20,
                    left: 10,
                    child: IconButton(
                      onPressed: widget.onBack,
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                ],
              ),

              Transform.translate(
                offset: const Offset(0, -40),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/Reset_password.png",
                          height: 120,
                        ),

                        const SizedBox(height: 20),

                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Reset Password",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Masukkan password baru untuk\n${widget.email}",
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),

                        const SizedBox(height: 20),

                        buildInputField(),

                        const SizedBox(height: 10),

                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: widget.isLoading ? null : widget.onSubmit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0F2D3F),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: widget.isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    "Reset Password",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        GestureDetector(
                          onTap: widget.onBack,
                          child: const Text(
                            "kembali ke halaman sebelumnya",
                            style: TextStyle(
                              color: Color(0xFF0F2D3F),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
    );
  }
}