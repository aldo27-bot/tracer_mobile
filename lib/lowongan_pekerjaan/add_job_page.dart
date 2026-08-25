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

  // =========================================================
  // VALIDASI POSISI
  // =========================================================

  String? validatePosisi(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'Posisi wajib diisi';
    }

    if (text.length < 3) {
      return 'Posisi minimal 3 karakter';
    }

    if (text.length > 100) {
      return 'Posisi maksimal 100 karakter';
    }

    // Tidak boleh hanya angka
    if (RegExp(r'^\d+$').hasMatch(text)) {
      return 'Posisi harus berupa nama pekerjaan';
    }

    // Minimal harus memiliki huruf
    if (!RegExp(r'[a-zA-Z]').hasMatch(text)) {
      return 'Posisi harus mengandung huruf';
    }

    return null;
  }

  // =========================================================
  // VALIDASI NAMA PERUSAHAAN
  // =========================================================

  String? validatePerusahaan(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'Nama perusahaan wajib diisi';
    }

    if (text.length < 2) {
      return 'Nama perusahaan minimal 2 karakter';
    }

    if (text.length > 150) {
      return 'Nama perusahaan maksimal 150 karakter';
    }

    // Tidak boleh hanya angka
    if (RegExp(r'^\d+$').hasMatch(text)) {
      return 'Nama perusahaan tidak boleh hanya berupa angka';
    }

    // Minimal harus memiliki huruf
    if (!RegExp(r'[a-zA-Z]').hasMatch(text)) {
      return 'Nama perusahaan harus mengandung huruf';
    }

    return null;
  }

  // =========================================================
  // VALIDASI LOKASI
  // =========================================================

  String? validateLokasi(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'Lokasi wajib diisi';
    }

    if (text.length < 3) {
      return 'Lokasi minimal 3 karakter';
    }

    if (text.length > 150) {
      return 'Lokasi maksimal 150 karakter';
    }

    if (RegExp(r'^\d+$').hasMatch(text)) {
      return 'Lokasi tidak boleh hanya berupa angka';
    }

    if (!RegExp(r'[a-zA-Z]').hasMatch(text)) {
      return 'Lokasi harus mengandung nama wilayah';
    }

    return null;
  }

  // =========================================================
  // VALIDASI GAJI
  // =========================================================

  String? validateGaji(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'Gaji wajib diisi';
    }

    // Bersihkan format gaji
    final cleanGaji = text
        .replaceAll('Rp', '')
        .replaceAll('rp', '')
        .replaceAll('RP', '')
        .replaceAll('.', '')
        .replaceAll(',', '')
        .replaceAll(' ', '');

    if (cleanGaji.isEmpty) {
      return 'Gaji wajib diisi';
    }

    // Cek karakter selain angka
    if (!RegExp(r'^\d+$').hasMatch(cleanGaji)) {
      return 'Gaji hanya boleh berisi angka';
    }

    final gaji = int.tryParse(cleanGaji);

    if (gaji == null) {
      return 'Format gaji tidak valid';
    }

    if (gaji <= 0) {
      return 'Gaji harus lebih dari Rp 0';
    }

    // Batas maksimal untuk mencegah input tidak masuk akal
    if (gaji > 1000000000) {
      return 'Nominal gaji terlalu besar';
    }

    return null;
  }

  // =========================================================
  // VALIDASI DESKRIPSI
  // =========================================================

  String? validateDeskripsi(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'Deskripsi wajib diisi';
    }

    if (text.length < 10) {
      return 'Deskripsi minimal 10 karakter';
    }

    if (text.length > 5000) {
      return 'Deskripsi maksimal 5000 karakter';
    }

    // Cek apakah hanya angka/simbol
    if (!RegExp(r'[a-zA-Z]').hasMatch(text)) {
      return 'Deskripsi harus mengandung teks';
    }

    return null;
  }

  // =========================================================
  // VALIDASI BATAS LAMARAN
  // =========================================================

  String? validateBatasLamaran(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'Batas lamaran wajib dipilih';
    }

    final tanggal = DateTime.tryParse(text);

    if (tanggal == null) {
      return 'Format tanggal tidak valid';
    }

    final sekarang = DateTime.now();

    final hariIni = DateTime(
      sekarang.year,
      sekarang.month,
      sekarang.day,
    );

    final tanggalLamaran = DateTime(
      tanggal.year,
      tanggal.month,
      tanggal.day,
    );

    if (tanggalLamaran.isBefore(hariIni)) {
      return 'Batas lamaran tidak boleh sebelum hari ini';
    }

    return null;
  }

  // =========================================================
  // VALIDASI KONTAK
  // =========================================================

  String? validateKontak(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'Nomor kontak wajib diisi';
    }

    // Hilangkan spasi, + dan -
    final nomor = text.replaceAll(
      RegExp(r'[\s\-\+]'),
      '',
    );

    if (nomor.isEmpty) {
      return 'Nomor kontak wajib diisi';
    }

    if (!RegExp(r'^\d+$').hasMatch(nomor)) {
      return 'Nomor kontak hanya boleh berisi angka';
    }

    if (nomor.length < 10) {
      return 'Nomor kontak terlalu pendek, minimal 10 digit';
    }

    if (nomor.length > 15) {
      return 'Nomor kontak terlalu panjang, maksimal 15 digit';
    }

    // Validasi nomor Indonesia
    if (!nomor.startsWith('08') &&
        !nomor.startsWith('62')) {
      return 'Nomor kontak harus menggunakan format Indonesia';
    }

    return null;
  }

  // =========================================================
  // VALIDASI LINK LAMARAN
  // =========================================================

  String? validateLink(String? value) {
    final text = value?.trim() ?? '';

    // Link opsional
    if (text.isEmpty) {
      return null;
    }

    // Harus menggunakan http/https
    if (!text.startsWith('http://') &&
        !text.startsWith('https://')) {
      return 'Link harus diawali http:// atau https://';
    }

    final uri = Uri.tryParse(text);

    if (uri == null) {
      return 'Format link tidak valid';
    }

    if (uri.host.isEmpty) {
      return 'Alamat website tidak valid';
    }

    if (uri.scheme != 'http' &&
        uri.scheme != 'https') {
      return 'Link hanya boleh menggunakan HTTP atau HTTPS';
    }

    return null;
  }

  // =========================================================
  // PICK IMAGE
  // =========================================================

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

  // =========================================================
  // PICK DATE
  // =========================================================

  Future<void> pickDate() async {
    final now = DateTime.now();

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
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
      final formattedDate =
          '${pickedDate.year}-'
          '${pickedDate.month.toString().padLeft(2, '0')}-'
          '${pickedDate.day.toString().padLeft(2, '0')}';

      setState(() {
        batasC.text = formattedDate;
      });

      // Refresh validator
      _formKey.currentState?.validate();
    }
  }

  // =========================================================
  // VALIDASI FOTO
  // =========================================================

  bool validateImage() {
    if (selectedImage != null) {
      return true;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'Foto lowongan wajib dipilih',
        ),
      ),
    );

    return false;
  }

  // =========================================================
  // SAVE JOB
  // =========================================================

  Future<void> saveJob() async {
    // Cegah klik berkali-kali
    if (isLoading) {
      return;
    }

    // Validasi semua field
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validasi foto
    if (!validateImage()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final success = await ApiService.addLowongan(
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

      if (!mounted) {
        return;
      }

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              'Lowongan berhasil ditambahkan',
            ),
          ),
        );

        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'Gagal menambahkan lowongan',
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Terjadi kesalahan: $e',
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

  // =========================================================
  // DISPOSE
  // =========================================================

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

  // =========================================================
  // BUILD
  // =========================================================

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

      validatePosisi: validatePosisi,
      validatePerusahaan: validatePerusahaan,
      validateLokasi: validateLokasi,
      validateGaji: validateGaji,
      validateDeskripsi: validateDeskripsi,
      validateBatasLamaran: validateBatasLamaran,
      validateKontak: validateKontak,
      validateLink: validateLink,
    );
  }
}