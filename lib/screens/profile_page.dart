import 'dart:async';

import 'package:flutter/material.dart';
import 'package:projectsemester4/models/alumni_models.dart';
import 'package:projectsemester4/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/edit_profile_page.dart';
import '../screens/login_page.dart';
import '../screens/lupa_password.dart';
import '../widgets/screen/profile_ui.dart';

class ProfilePage extends StatefulWidget {
  final AlumniModel alumni;
  final Function(AlumniModel updated)?
      onProfileUpdate;

  const ProfilePage({
    super.key,
    required this.alumni,
    this.onProfileUpdate,
  });

  @override
  State<ProfilePage> createState() =>
      _ProfilePageState();
}

class _ProfilePageState
    extends State<ProfilePage> {
  late AlumniModel alumniData;

  late TextEditingController
      alamatController;

  bool isLoading = false;

  String alamatView = "";

  @override
  void initState() {
    super.initState();

    alumniData = widget.alumni;

    alamatView =
        widget.alumni.alamat ?? "";

    alamatController =
        TextEditingController(
      text: alamatView,
    );

    loadProfile();
  }

  @override
  void dispose() {
    alamatController.dispose();
    super.dispose();
  }

  // =========================
  // IMAGE URL
  // =========================

  String getImageUrl(String? image) {
    if (image == null ||
        image.isEmpty) {
      return "";
    }

    return "${ApiService.baseUrl.replaceAll('/api', '')}/storage/$image?v=${DateTime.now().millisecondsSinceEpoch}";
  }

  // =========================
  // UPDATE ALAMAT
  // =========================

  Future<void> updateAlamat() async {
    final alamatBaru =
        alamatController.text.trim();

    if (alamatBaru.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Alamat tidak boleh kosong",
          ),
        ),
      );

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final data =
          await ApiService.updateAlamat(
        widget.alumni.nim,
        alamatBaru,
      );

      if (data['status'] == true) {
        setState(() {
          alamatView = alamatBaru;
        });

        Navigator.pop(context);

        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              "Alamat berhasil diperbarui",
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(
              data['message'] ??
                  "Gagal update alamat",
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            "Error: $e",
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // =========================
  // LOAD PROFILE
  // =========================

  Future<void> loadProfile() async {
    try {
      final prefs =
          await SharedPreferences
              .getInstance();

      final userId =
          prefs.getInt('user_id');

      if (userId == null) return;

      final data =
          await ApiService.getProfile(
        userId,
      );

      if (data['status'] == true) {
        final user = data['data'];

        setState(() {
          alumniData = AlumniModel(
            nama:
                user['nama']
                        ?.toString() ??
                    '',

            nim:
                user['nim']
                        ?.toString() ??
                    '',

            email:
                user['email']
                    ?.toString(),

            no_hp:
                user['no_hp']
                    ?.toString(),

            prodi:
                user['prodi']
                        ?.toString() ??
                    '',

            angkatan:
                user['angkatan']
                        ?.toString() ??
                    '',

            tahunLulus:
                user['tahun_lulus']
                        ?.toString() ??
                    '',

            alamat:
                user['alamat']
                    ?.toString(),

            image:
                user['image']
                    ?.toString(),

            tempatLahir:
                user['tempat_lahir']
                    ?.toString(),

            tanggalLahir:
                user['tanggal_lahir']
                    ?.toString(),
          );
        });
      }
    } catch (e) {
      debugPrint(
        "ERROR LOAD PROFILE: $e",
      );
    }
  }

  // =========================
  // EDIT PROFILE
  // =========================

  Future<void> editProfile() async {
    final result =
        await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            EditProfilePage(
          alumni: alumniData,
        ),
      ),
    );

    if (result != null) {
      await loadProfile();

      final updated = AlumniModel(
        nama: result["nama"],

        nim: alumniData.nim,

        email: result["email"],

        no_hp: result["no_hp"],

        prodi: result["prodi"],

        angkatan:
            result["angkatan"]
                .toString(),

        tahunLulus:
            result["tahunLulus"]
                .toString(),

        alamat: result["alamat"],

        image:
            (result["image"] !=
                        null &&
                    result["image"]
                        .toString()
                        .isNotEmpty)
                ? result["image"]
                : null,

        tempatLahir:
            alumniData
                .tempatLahir,

        tanggalLahir:
            alumniData
                .tanggalLahir,
      );

      setState(() {
        alumniData = updated;

        alamatView =
            result["alamat"] ?? "";
      });

      widget.onProfileUpdate
          ?.call(updated);
    }
  }

  // =========================
  // LOGOUT
  // =========================

  Future<void> logout() async {
    final prefs =
        await SharedPreferences
            .getInstance();

    await prefs.clear();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const LoginPage(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ProfileUI(
      alumniData: alumniData,
      alamatView: alamatView,
      imageUrl:
          getImageUrl(
        alumniData.image,
      ),

      onEditProfile:
          editProfile,

      onLogout: logout,
    );
  }
}