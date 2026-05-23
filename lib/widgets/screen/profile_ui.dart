import 'package:flutter/material.dart';
import 'package:projectsemester4/models/alumni_models.dart';

import '../../screens/lupa_password.dart';

class ProfileUI extends StatelessWidget {
  final AlumniModel alumniData;

  final String alamatView;

  final String imageUrl;

  final VoidCallback
      onEditProfile;

  final VoidCallback onLogout;

  const ProfileUI({
    super.key,
    required this.alumniData,
    required this.alamatView,
    required this.imageUrl,
    required this.onEditProfile,
    required this.onLogout,
  });

  // =========================
  // CARD DATA
  // =========================

  Widget buildDataMenuItem(
    IconData icon,
    String title,
    String value,
  ) {
    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 14,
      ),

      padding:
          const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          18,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(0.03),

            blurRadius: 10,

            offset:
                const Offset(0, 4),
          ),
        ],
      ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Container(
            padding:
                const EdgeInsets.all(
              10,
            ),

            decoration:
                BoxDecoration(
              color:
                  const Color(
                0xFFF3F5F7,
              ),

              borderRadius:
                  BorderRadius.circular(
                12,
              ),
            ),

            child: Icon(
              icon,
              color:
                  const Color(
                0xFF0F2D3F,
              ),
              size: 22,
            ),
          ),

          const SizedBox(
            width: 14,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

              children: [
                Text(
                  title,

                  style:
                      const TextStyle(
                    color:
                        Colors.grey,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                Text(
                  value,

                  style:
                      const TextStyle(
                    fontSize: 15,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final a = alumniData;

    return Scaffold(
      backgroundColor:
          const Color(0xFFF7F7F7),

      body: SafeArea(
        child:
            SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),

              const Text(
                "Profile",

                style: TextStyle(
                  fontSize: 28,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              // PROFILE CARD
              Padding(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 20,
                ),

                child: Container(
                  padding:
                      const EdgeInsets.all(
                    24,
                  ),

                  decoration:
                      BoxDecoration(
                    color:
                        Colors.white,

                    borderRadius:
                        BorderRadius.circular(
                      26,
                    ),
                  ),

                  child: Column(
                    children: [
                      // FOTO
                      CircleAvatar(
                        radius: 42,

                        backgroundColor:
                            const Color(
                          0xFF0F2D3F,
                        ),

                        child: ClipOval(
                          child:
                              (a.image !=
                                          null &&
                                      a.image!
                                          .isNotEmpty)
                                  ? Image.network(
                                      imageUrl,

                                      width:
                                          84,

                                      height:
                                          84,

                                      fit: BoxFit
                                          .cover,

                                      errorBuilder:
                                          (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return const Icon(
                                          Icons
                                              .person,

                                          color:
                                              Colors.white,

                                          size:
                                              45,
                                        );
                                      },
                                    )
                                  : const Icon(
                                      Icons
                                          .person,

                                      color:
                                          Colors.white,

                                      size:
                                          45,
                                    ),
                        ),
                      ),

                      const SizedBox(
                        height: 16,
                      ),

                      Text(
                        a.nama,

                        textAlign:
                            TextAlign.center,

                        style:
                            const TextStyle(
                          fontSize: 20,
                          fontWeight:
                              FontWeight
                                  .bold,
                        ),
                      ),

                      const SizedBox(
                        height: 6,
                      ),

                      Text(
                        a.nim,

                        style:
                            const TextStyle(
                          color:
                              Colors.grey,
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      Text(
                        a.prodi,

                        textAlign:
                            TextAlign.center,

                        style:
                            const TextStyle(
                          color:
                              Colors.grey,
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      // EDIT PROFILE
                      ElevatedButton.icon(
                        onPressed:
                            onEditProfile,

                        icon: const Icon(
                          Icons.edit,
                          color: Color(
                            0xFFFF8A00,
                          ),
                        ),

                        label: const Text(
                          "Edit Profile",

                          style:
                              TextStyle(
                            fontWeight:
                                FontWeight
                                    .bold,

                            color:
                                Colors.orange,
                          ),
                        ),

                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(
                            0xFF0F2D3F,
                          ),

                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              16,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 12,
                      ),

                      // LUPA PASSWORD
                      SizedBox(
                        width:
                            double.infinity,

                        child:
                            OutlinedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    LupaPasswordPage(
                                  email:
                                      a.email ??
                                          "",
                                ),
                              ),
                            );
                          },

                          icon: const Icon(
                            Icons.lock_reset,
                            color: Color(
                              0xFF0F2D3F,
                            ),
                          ),

                          label: const Text(
                            "Lupa Password",

                            style:
                                TextStyle(
                              fontWeight:
                                  FontWeight
                                      .bold,

                              color: Color(
                                0xFF0F2D3F,
                              ),
                            ),
                          ),

                          style:
                              OutlinedButton.styleFrom(
                            side:
                                const BorderSide(
                              color: Color(
                                0xFF0F2D3F,
                              ),
                            ),

                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              // DATA LIST
              Padding(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 20,
                ),

                child: Column(
                  children: [
                    buildDataMenuItem(
                      Icons.person,
                      "Nama",
                      a.nama,
                    ),

                    buildDataMenuItem(
                      Icons.badge,
                      "NIM",
                      a.nim,
                    ),

                    buildDataMenuItem(
                      Icons.email,
                      "Email",
                      a.email ?? "-",
                    ),

                    buildDataMenuItem(
                      Icons.phone,
                      "Nomor HP",
                      (a.no_hp != null &&
                              a.no_hp!
                                  .isNotEmpty)
                          ? a.no_hp!
                          : "-",
                    ),

                    buildDataMenuItem(
                      Icons.school,
                      "Prodi",
                      a.prodi,
                    ),

                    buildDataMenuItem(
                      Icons.calendar_month,
                      "Angkatan",
                      a.angkatan,
                    ),

                    buildDataMenuItem(
                      Icons
                          .workspace_premium,
                      "Tahun Lulus",
                      a.tahunLulus,
                    ),

                    buildDataMenuItem(
                      Icons.place,
                      "Tempat Lahir",
                      a.tempatLahir ??
                          "-",
                    ),

                    buildDataMenuItem(
                      Icons.date_range,
                      "Tanggal Lahir",
                      a.tanggalLahir ??
                          "-",
                    ),

                    buildDataMenuItem(
                      Icons.location_on,
                      "Alamat",
                      alamatView
                              .isEmpty
                          ? "-"
                          : alamatView,
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              // LOGOUT
              Padding(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 20,
                ),

                child: SizedBox(
                  width:
                      double.infinity,

                  child:
                      ElevatedButton.icon(
                    onPressed: onLogout,

                    icon: const Icon(
                      Icons.logout,
                      color: Colors.red,
                    ),

                    label: const Text(
                      "Logout",

                      style: TextStyle(
                        fontWeight:
                            FontWeight
                                .bold,

                        color: Colors.red,
                      ),
                    ),

                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(
                        0xFFF3F5F7,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}