import 'package:flutter/material.dart';

class RegisterUI extends StatelessWidget {
  final TextEditingController nimController;
  final TextEditingController emailController;
  final TextEditingController usernameController;
  final TextEditingController noHpController;
  final TextEditingController passwordController;

  final bool isLoading;
  final bool obscurePassword;

  final VoidCallback onTogglePassword;
  final VoidCallback onRegister;

  const RegisterUI({
    Key? key,
    required this.nimController,
    required this.emailController,
    required this.usernameController,
    required this.noHpController,
    required this.passwordController,
    required this.isLoading,
    required this.obscurePassword,
    required this.onTogglePassword,
    required this.onRegister,
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
        obscureText: isPassword
            ? obscurePassword
            : false,

        enabled: !isLoading,

        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,

          prefixIcon: Icon(
            icon,
            color: Colors.grey,
          ),

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

          contentPadding:
              const EdgeInsets.symmetric(
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
            padding: const EdgeInsets.only(
              bottom: 30,
            ),

            child: Column(
              children: [
                // TOP SHAPE
                Stack(
                  children: [
                    Container(
                      height: 220,

                      decoration: const BoxDecoration(
                        color: Color(0xFF0F2D3F),

                        borderRadius:
                            BorderRadius.only(
                          bottomLeft:
                              Radius.circular(120),
                          bottomRight:
                              Radius.circular(120),
                        ),
                      ),
                    ),

                    Positioned(
                      top: 35,
                      left: 20,

                      child: Container(
                        width: 40,
                        height: 40,

                        decoration:
                            const BoxDecoration(
                          color: Color(0xFF5D7B93),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),

                    Positioned(
                      top: 45,
                      right: 20,

                      child: Icon(
                        Icons.app_registration,
                        size: 90,
                        color: Colors.white
                            .withOpacity(0.15),
                      ),
                    ),

                    // BACK BUTTON
                    Positioned(
                      top: 20,
                      left: 10,

                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },

                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                // REGISTER CARD
                Transform.translate(
                  offset: const Offset(0, -40),

                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 24,
                    ),

                    child: Container(
                      padding:
                          const EdgeInsets.all(22),

                      decoration: BoxDecoration(
                        color: Colors.white,

                        borderRadius:
                            BorderRadius.circular(30),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withOpacity(0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),

                      child: Column(
                        children: [
                          // IMAGE
                          Container(
                            height: 120,
                            width: double.infinity,

                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(
                                      22),
                              color: const Color(
                                  0xFFF5F5F5),
                            ),

                            child: Padding(
                              padding:
                                  const EdgeInsets.all(
                                      12),

                              child: Image.asset(
                                "assets/Signup-amico.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          // TITLE
                          const Align(
                            alignment:
                                Alignment.centerLeft,

                            child: Text(
                              "Register",

                              style: TextStyle(
                                fontSize: 30,
                                fontWeight:
                                    FontWeight.bold,
                                color:
                                    Color(0xFF22313F),
                              ),
                            ),
                          ),

                          const SizedBox(height: 6),

                          const Align(
                            alignment:
                                Alignment.centerLeft,

                            child: Text(
                              "Buat akun Anda.",

                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          // NIM
                          buildInputField(
                            controller: nimController,
                            hint: "NIM",
                            icon:
                                Icons.badge_outlined,
                          ),

                          // EMAIL
                          buildInputField(
                            controller:
                                emailController,
                            hint: "Email",
                            icon:
                                Icons.email_outlined,
                          ),

                          // USERNAME
                          buildInputField(
                            controller:
                                usernameController,
                            hint: "Username",
                            icon:
                                Icons.person_outlined,
                          ),

                          // NO HP
                          buildInputField(
                            controller:
                                noHpController,
                            hint: "Nomor Handphone",
                            icon:
                                Icons.phone_outlined,
                          ),

                          // PASSWORD
                          buildInputField(
                            controller:
                                passwordController,
                            hint: "Password",
                            icon:
                                Icons.lock_outline,
                            isPassword: true,
                          ),

                          const SizedBox(height: 12),

                          // BUTTON
                          SizedBox(
                            width: double.infinity,
                            height: 54,

                            child: ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : onRegister,

                              style:
                                  ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(
                                        0xFF0F2D3F),
                                elevation: 0,

                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                              18),
                                ),
                              ),

                              child: isLoading
                                  ? const CircularProgressIndicator(
                                      color:
                                          Colors.white,
                                    )
                                  : const Text(
                                      "Register",

                                      style:
                                          TextStyle(
                                        fontSize: 16,
                                        color: Colors
                                            .white,
                                        fontWeight:
                                            FontWeight
                                                .bold,
                                      ),
                                    ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // LOGIN
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .center,

                            children: [
                              const Text(
                                "Sudah punya akun? ",

                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),

                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(
                                      context);
                                },

                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Color(
                                        0xFF0F2D3F),
                                    fontWeight:
                                        FontWeight.bold,
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