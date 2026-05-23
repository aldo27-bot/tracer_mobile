import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/api_service.dart';
import '../widgets/jobs/add_job_ui.dart';

class AddJobPage extends StatefulWidget {
  const AddJobPage({super.key});

  @override
  State<AddJobPage> createState() => _AddJobPageState();
}

class _AddJobPageState extends State<AddJobPage> {
  final _formKey = GlobalKey<FormState>();

  final posisiC = TextEditingController();
  final perusahaanC = TextEditingController();
  final lokasiC = TextEditingController();
  final gajiC = TextEditingController();
  final deskripsiC = TextEditingController();
  final batasC = TextEditingController();
  final kontakC = TextEditingController();
  final linkC = TextEditingController();

  bool isLoading = false;

  File? selectedImage;

  // =========================
  // PICK IMAGE
  // =========================
  Future<void> pickImage() async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  // =========================
  // PICK DATE
  // =========================
  Future<void> pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFEC7004),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      String formattedDate =
          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";

      setState(() {
        batasC.text = formattedDate;
      });
    }
  }

  // =========================
  // SAVE JOB
  // =========================
  Future<void> saveJob() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    bool success = await ApiService.addLowongan(
      posisi: posisiC.text.trim(),
      namaPerusahaan: perusahaanC.text.trim(),
      lokasi: lokasiC.text.trim(),
      gaji: gajiC.text.trim(),
      deskripsi: deskripsiC.text.trim(),
      batasLamaran: batasC.text.trim(),
      kontak: kontakC.text.trim(),
      linkLamaran: linkC.text.trim(),
      dibuatOleh: 1,
      foto: selectedImage,
    );

    setState(() {
      isLoading = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text("Lowongan berhasil ditambahkan"),
        ),
      );

      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Gagal menambahkan lowongan"),
        ),
      );
    }
  }

  @override
  void dispose() {
    posisiC.dispose();
    perusahaanC.dispose();
    lokasiC.dispose();
    gajiC.dispose();
    deskripsiC.dispose();
    batasC.dispose();
    kontakC.dispose();
    linkC.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AddJobUI(
      formKey: _formKey,

      posisiC: posisiC,
      perusahaanC: perusahaanC,
      lokasiC: lokasiC,
      gajiC: gajiC,
      deskripsiC: deskripsiC,
      batasC: batasC,
      kontakC: kontakC,
      linkC: linkC,

      selectedImage: selectedImage,

      isLoading: isLoading,

      pickImage: pickImage,
      pickDate: pickDate,
      saveJob: saveJob,
    );
  }
}