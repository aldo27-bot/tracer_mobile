import 'dart:io';

import 'package:flutter/material.dart';

class AddJobUI extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  final TextEditingController posisiC;
  final TextEditingController perusahaanC;
  final TextEditingController lokasiC;
  final TextEditingController gajiC;
  final TextEditingController deskripsiC;
  final TextEditingController batasC;
  final TextEditingController kontakC;
  final TextEditingController linkC;

  final File? selectedImage;

  final bool isLoading;

  final VoidCallback pickImage;
  final VoidCallback pickDate;
  final VoidCallback saveJob;

  const AddJobUI({
    super.key,
    required this.formKey,
    required this.posisiC,
    required this.perusahaanC,
    required this.lokasiC,
    required this.gajiC,
    required this.deskripsiC,
    required this.batasC,
    required this.kontakC,
    required this.linkC,
    required this.selectedImage,
    required this.isLoading,
    required this.pickImage,
    required this.pickDate,
    required this.saveJob,
  });

  Widget buildField({
    required String label,
    required TextEditingController controller,
    String? hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Color(0xFFEC7004),
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Tambah Lowongan",
          style: TextStyle(
            color: Color(0xFF0F2D3F),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Isi informasi lowongan pekerjaan",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F2D3F),
                ),
              ),

              const SizedBox(height: 24),

              GestureDetector(
                onTap: pickImage,

                child: Container(
                  width: double.infinity,
                  height: 200,

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300),
                  ),

                  child: selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(
                            selectedImage!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_outlined,
                              size: 60,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Pilih Foto Lowongan",
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 20),

              buildField(
                label: "Posisi",
                controller: posisiC,
                hint: "Contoh: Flutter Developer",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Posisi wajib diisi";
                  }
                  return null;
                },
              ),

              buildField(
                label: "Nama Perusahaan",
                controller: perusahaanC,
                hint: "Contoh: PT Maju Jaya",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Nama perusahaan wajib diisi";
                  }
                  return null;
                },
              ),

              buildField(
                label: "Lokasi",
                controller: lokasiC,
                hint: "Contoh: Surabaya",
              ),

              buildField(
                label: "Gaji",
                controller: gajiC,
                hint: "Contoh: Rp 5.000.000",
              ),

              buildField(
                label: "Deskripsi",
                controller: deskripsiC,
                maxLines: 5,
                hint: "Masukkan deskripsi pekerjaan",
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: TextFormField(
                  controller: batasC,
                  readOnly: true,
                  onTap: pickDate,
                  decoration: InputDecoration(
                    labelText: "Batas Lamaran",
                    hintText: "Pilih tanggal",
                    suffixIcon: const Icon(
                      Icons.calendar_month,
                      color: Color(0xFFEC7004),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),

              buildField(
                label: "Kontak",
                controller: kontakC,
                keyboardType: TextInputType.phone,
              ),

              buildField(
                label: "Link Lamaran (Opsional)",
                controller: linkC,
                keyboardType: TextInputType.url,
              ),

              const SizedBox(height: 10),

              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : saveJob,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F2D3F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),

                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              "Simpan Lowongan",
                              style: TextStyle(
                                color: Colors.orange,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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