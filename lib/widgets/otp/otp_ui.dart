import 'package:flutter/material.dart';

class OtpUI extends StatelessWidget {
  final String email;
  final TextEditingController otpController;

  final bool isVerifying;
  final bool isResending;
  final int resendSeconds;

  final VoidCallback onVerify;
  final VoidCallback onResend;
  final VoidCallback onBack;

  const OtpUI({
    super.key,
    required this.email,
    required this.otpController,
    required this.isVerifying,
    required this.isResending,
    required this.resendSeconds,
    required this.onVerify,
    required this.onResend,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ================= HEADER =================
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
                      onPressed: onBack,
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                ],
              ),

              // ================= CARD =================
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
                          "assets/EnterOTP-pana.png",
                          height: 120,
                        ),

                        const SizedBox(height: 18),

                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Verifikasi OTP",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Kode OTP dikirim ke\n$email",
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ================= OTP INPUT =================
                        TextField(
                          controller: otpController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            letterSpacing: 8,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: const InputDecoration(
                            hintText: "Enter OTP",
                            border: InputBorder.none,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ================= BUTTON VERIFY =================
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: isVerifying ? null : onVerify,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0F2D3F),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: isVerifying
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    "Verifikasi OTP",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ================= RESEND OTP =================
                        GestureDetector(
                          onTap: (resendSeconds > 0 || isResending)
                              ? null
                              : onResend,
                          child: Text(
                            resendSeconds > 0
                                ? "Kirim ulang dalam $resendSeconds detik"
                                : "Kirim ulang OTP",
                            style: TextStyle(
                              color: resendSeconds > 0
                                  ? Colors.grey
                                  : const Color(0xFF0F2D3F),
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