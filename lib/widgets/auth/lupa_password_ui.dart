import 'package:flutter/material.dart';

class LupaPasswordUI extends StatelessWidget {
  final TextEditingController emailController;

  final bool isLoading;

  final VoidCallback onSendOtp;

  const LupaPasswordUI({
    Key? key,
    required this.emailController,
    required this.isLoading,
    required this.onSendOtp,
  }) : super(key: key);

  Widget buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),

      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(18),
      ),

      child: TextField(
        controller: controller,
        keyboardType:
            TextInputType.emailAddress,

        textInputAction:
            TextInputAction.done,

        onSubmitted: (_) => onSendOtp(),

        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,

          prefixIcon: Icon(
            icon,
            color: Colors.grey,
          ),

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
      backgroundColor:
          const Color(0xFFF7F7F7),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.only(
              bottom: 30,
            ),

            child: Column(
              children: [
                // TOP SHAPE
                Stack(
                  children: [
                    Container(
                      height: 220,

                      decoration:
                          const BoxDecoration(
                        color:
                            Color(0xFF0F2D3F),

                        borderRadius:
                            BorderRadius.only(
                          bottomLeft:
                              Radius.circular(
                                  120),
                          bottomRight:
                              Radius.circular(
                                  120),
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
                          color:
                              Color(0xFF5D7B93),
                          shape:
                              BoxShape.circle,
                        ),
                      ),
                    ),

                    Positioned(
                      top: 45,
                      right: 20,

                      child: Icon(
                        Icons.lock_reset,
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
                          Navigator.pop(
                              context);
                        },

                        icon: const Icon(
                          Icons.arrow_back,
                          color:
                              Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                // CARD
                Transform.translate(
                  offset: const Offset(
                    0,
                    -40,
                  ),

                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 24,
                    ),

                    child: Container(
                      padding:
                          const EdgeInsets.all(
                        22,
                      ),

                      decoration:
                          BoxDecoration(
                        color: Colors.white,

                        borderRadius:
                            BorderRadius
                                .circular(
                          30,
                        ),

                        boxShadow: [
                          BoxShadow(
                            color: Colors
                                .black
                                .withOpacity(
                              0.08,
                            ),

                            blurRadius: 20,

                            offset:
                                const Offset(
                              0,
                              8,
                            ),
                          ),
                        ],
                      ),

                      child: Column(
                        children: [
                          // IMAGE
                          Container(
                            height: 120,
                            width:
                                double.infinity,

                            decoration:
                                BoxDecoration(
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                22,
                              ),

                              color:
                                  const Color(
                                0xFFF5F5F5,
                              ),
                            ),

                            child: Padding(
                              padding:
                                  const EdgeInsets
                                      .all(12),

                              child: Image.asset(
                                "assets/Forgotpassword-amico.png",
                                fit: BoxFit
                                    .contain,
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          // TITLE
                          const Align(
                            alignment:
                                Alignment
                                    .centerLeft,

                            child: Text(
                              "Lupa Password",

                              style:
                                  TextStyle(
                                fontSize: 28,
                                fontWeight:
                                    FontWeight
                                        .bold,

                                color: Color(
                                  0xFF22313F,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 6,
                          ),

                          const Align(
                            alignment:
                                Alignment
                                    .centerLeft,

                            child: Text(
                              "Masukkan email Anda untuk menerima kode OTP.",

                              style:
                                  TextStyle(
                                color:
                                    Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 22,
                          ),

                          // EMAIL FIELD
                          buildInputField(
                            controller:
                                emailController,
                            hint: "Email",
                            icon: Icons
                                .email_outlined,
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          // BUTTON
                          SizedBox(
                            width:
                                double.infinity,
                            height: 54,

                            child:
                                ElevatedButton(
                              onPressed:
                                  isLoading
                                      ? null
                                      : onSendOtp,

                              style:
                                  ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(
                                  0xFF0F2D3F,
                                ),

                                elevation: 0,

                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(
                                    18,
                                  ),
                                ),
                              ),

                              child:
                                  isLoading
                                      ? const CircularProgressIndicator(
                                          color:
                                              Colors.white,
                                        )
                                      : const Text(
                                          "Kirim OTP",

                                          style:
                                              TextStyle(
                                            fontSize:
                                                16,

                                            color:
                                                Colors.white,

                                            fontWeight:
                                                FontWeight.bold,
                                          ),
                                        ),
                            ),
                          ),

                          const SizedBox(
                            height: 18,
                          ),

                          // BACK
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .center,

                            children: [
                              const Text(
                                "Kembali ke ",

                                style:
                                    TextStyle(
                                  color:
                                      Colors.grey,
                                  fontSize: 13,
                                ),
                              ),

                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(
                                      context);
                                },

                                child: const Text(
                                  "halaman sebelumnya",

                                  style:
                                      TextStyle(
                                    color: Color(
                                      0xFF0F2D3F,
                                    ),

                                    fontWeight:
                                        FontWeight
                                            .bold,

                                    fontSize:
                                        13,
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