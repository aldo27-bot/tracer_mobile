import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:projectsemester4/models/alumni_models.dart';
import 'package:projectsemester4/services/api_service.dart';
import 'package:projectsemester4/widgets/screen/edit_profile_ui.dart';

class EditProfilePage extends StatefulWidget {
  final AlumniModel alumni;

  const EditProfilePage({
    super.key,
    required this.alumni,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController namaC;
  late TextEditingController emailC;
  late TextEditingController noHpC;
  late TextEditingController prodiC;
  late TextEditingController angkatanC;
  late TextEditingController tahunLulusC;
  late TextEditingController tempatLahirC;
  late TextEditingController tanggalLahirC;
  late TextEditingController alamatC;

  File? selectedImage;

  bool isLoading = false;
  bool removeImage = false;

  final RegExp nameRegex = RegExp(r"^[a-zA-Z\s]+$");
  final RegExp numberRegex = RegExp(r"^[0-9]+$");
  final RegExp addressRegex = RegExp(r"^[a-zA-Z0-9\s,.\-/]+$");

  final RegExp emailRegex = RegExp(
    r"^[\w-\.]+@gmail\.com$",
  );

  final RegExp phoneRegex = RegExp(
    r"^0[0-9]{9,12}$",
  );

  final int minYear = 1990;
  final int maxYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();

    namaC = TextEditingController(text: widget.alumni.nama);

    emailC = TextEditingController(
      text: widget.alumni.email ?? "",
    );

    noHpC = TextEditingController(
      text: widget.alumni.no_hp ?? "",
    );

    prodiC = TextEditingController(
      text: widget.alumni.prodi,
    );

    angkatanC = TextEditingController(
      text: widget.alumni.angkatan,
    );

    tahunLulusC = TextEditingController(
      text: widget.alumni.tahunLulus,
    );

    tempatLahirC = TextEditingController(
      text: widget.alumni.tempatLahir ?? "",
    );

    tanggalLahirC = TextEditingController(
      text: widget.alumni.tanggalLahir ?? "",
    );

    alamatC = TextEditingController(
      text: widget.alumni.alamat ?? "",
    );
  }

  @override
  void dispose() {
    namaC.dispose();
    emailC.dispose();
    noHpC.dispose();
    prodiC.dispose();
    angkatanC.dispose();
    tahunLulusC.dispose();
    tempatLahirC.dispose();
    tanggalLahirC.dispose();
    alamatC.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  void deleteImage() {
    setState(() {
      selectedImage = null;
      removeImage = true;
    });
  }

  Future<void> selectDate() async {
    FocusScope.of(context).unfocus();

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      final formatted =
          "${picked.year}-"
          "${picked.month.toString().padLeft(2, '0')}-"
          "${picked.day.toString().padLeft(2, '0')}";

      setState(() {
        tanggalLahirC.text = formatted;
      });
    }
  }

  Future<void> saveProfile() async {
    namaC.text = namaC.text.trim();
    emailC.text = emailC.text.trim();
    noHpC.text = noHpC.text.trim();
    prodiC.text = prodiC.text.trim();
    alamatC.text = alamatC.text.trim();
    tempatLahirC.text = tempatLahirC.text.trim();
    tanggalLahirC.text = tanggalLahirC.text.trim();

    if (namaC.text.isEmpty ||
        emailC.text.isEmpty ||
        noHpC.text.isEmpty ||
        prodiC.text.isEmpty ||
        angkatanC.text.isEmpty ||
        tahunLulusC.text.isEmpty ||
        alamatC.text.isEmpty ||
        tempatLahirC.text.isEmpty ||
        tanggalLahirC.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Semua data wajib diisi"),
        ),
      );
      return;
    }

    if (!emailRegex.hasMatch(emailC.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Email harus menggunakan format @gmail.com",
          ),
        ),
      );
      return;
    }

    if (!phoneRegex.hasMatch(noHpC.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Nomor HP harus diawali 0 dan 10-13 digit",
          ),
        ),
      );
      return;
    }

    final angkatan = int.tryParse(angkatanC.text);
    final tahunLulus = int.tryParse(tahunLulusC.text);

    if (angkatan == null || tahunLulus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Angkatan & Tahun Lulus harus valid"),
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final res = await ApiService.updateProfile(
        widget.alumni.nim,
        namaC.text,
        emailC.text,
        noHpC.text,
        prodiC.text,
        angkatan,
        tahunLulus,
        tempatLahirC.text,
        tanggalLahirC.text,
        alamatC.text,
        selectedImage,
        removeImage,
      );

      if (res['status'] == true) {
        if (mounted) {
          Navigator.pop(context, {
            "nama": namaC.text,
            "email": emailC.text,
            "no_hp": noHpC.text,
            "prodi": prodiC.text,
            "angkatan": angkatanC.text,
            "tahunLulus": tahunLulusC.text,
            "alamat": alamatC.text,
            "image": res['data']['image'],
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              res['message'] ?? "Gagal update",
            ),
          ),
        );
      }
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

  @override
  Widget build(BuildContext context) {
    return EditProfileUI(
      alumni: widget.alumni,
      namaC: namaC,
      emailC: emailC,
      noHpC: noHpC,
      prodiC: prodiC,
      angkatanC: angkatanC,
      tahunLulusC: tahunLulusC,
      tempatLahirC: tempatLahirC,
      tanggalLahirC: tanggalLahirC,
      alamatC: alamatC,
      selectedImage: selectedImage,
      removeImage: removeImage,
      isLoading: isLoading,
      pickImage: pickImage,
      deleteImage: deleteImage,
      saveProfile: saveProfile,
      selectDate: selectDate,
    );
  }
}