import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/alumni_models.dart';
import '../../services/api_service.dart';

class EditProfileUI extends StatelessWidget {
  final AlumniModel alumni;

  final TextEditingController namaC;
  final TextEditingController emailC;
  final TextEditingController noHpC;
  final TextEditingController prodiC;
  final TextEditingController angkatanC;
  final TextEditingController tahunLulusC;
  final TextEditingController tempatLahirC;
  final TextEditingController tanggalLahirC;
  final TextEditingController alamatC;

  final File? selectedImage;

  final bool removeImage;
  final bool isLoading;

  final VoidCallback pickImage;
  final VoidCallback deleteImage;
  final VoidCallback saveProfile;
  final VoidCallback selectDate;

  const EditProfileUI({
    super.key,
    required this.alumni,
    required this.namaC,
    required this.emailC,
    required this.noHpC,
    required this.prodiC,
    required this.angkatanC,
    required this.tahunLulusC,
    required this.tempatLahirC,
    required this.tanggalLahirC,
    required this.alamatC,
    required this.selectedImage,
    required this.removeImage,
    required this.isLoading,
    required this.pickImage,
    required this.deleteImage,
    required this.saveProfile,
    required this.selectDate,
  });

  Widget buildInput(
    String label,
    TextEditingController c,
    IconData icon, {
    bool number = false,
    bool isAddress = false,
    bool isEmail = false,
    bool isPhone = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: TextField(
        controller: c,
        keyboardType: number
            ? TextInputType.number
            : isEmail
            ? TextInputType.emailAddress
            : isPhone
            ? TextInputType.phone
            : TextInputType.text,

        inputFormatters: [
          if (number || isPhone)
            FilteringTextInputFormatter.digitsOnly
          else if (isEmail)
            FilteringTextInputFormatter.deny(RegExp(r"\s"))
          else if (isAddress)
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s,.\-/]'))
          else
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
        ],

        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: const Color(0xFF0F2D3F)),
          labelText: label,
          border: InputBorder.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),

      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            GestureDetector(
              onTap: pickImage,

              child: CircleAvatar(
                radius: 55,
                backgroundColor: Colors.grey.shade300,

                backgroundImage: selectedImage != null
                    ? FileImage(selectedImage!)
                    : (alumni.image != null &&
                              alumni.image!.isNotEmpty &&
                              !removeImage
                          ? NetworkImage(
                              "${ApiService.baseUrl.replaceAll('/api', '')}/storage/${alumni.image}",
                            )
                          : null),

                child:
                    selectedImage == null &&
                        (alumni.image == null || removeImage)
                    ? const Icon(
                        Icons.camera_alt,
                        color: Color(0xFF0F2D3F),
                        size: 40,
                      )
                    : null,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Tap untuk ganti foto",
              style: TextStyle(color: Colors.grey),
            ),

            if (selectedImage != null || (alumni.image != null && !removeImage))
              TextButton.icon(
                onPressed: deleteImage,

                icon: const Icon(Icons.delete, color: Colors.red),

                label: const Text(
                  "Hapus Foto",
                  style: TextStyle(color: Colors.red),
                ),
              ),

            const SizedBox(height: 20),

            buildInput("Nama", namaC, Icons.person),

            buildInput("Email", emailC, Icons.email, isEmail: true),

            buildInput("Nomor HP", noHpC, Icons.phone, isPhone: true),

            buildInput("Prodi", prodiC, Icons.school),

            buildInput(
              "Angkatan",
              angkatanC,
              Icons.calendar_month,
              number: true,
            ),

            buildInput(
              "Tahun Lulus",
              tahunLulusC,
              Icons.workspace_premium,
              number: true,
            ),

            buildInput("Tempat Lahir", tempatLahirC, Icons.place),

            Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: TextField(
                controller: tanggalLahirC,
                readOnly: true,

                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.date_range, color: Color(0xFF0F2D3F)),
                  labelText: "Tanggal Lahir",
                  border: InputBorder.none,
                ),

                onTap: selectDate,
              ),
            ),

            buildInput("Alamat", alamatC, Icons.location_on, isAddress: true),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F2D3F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Simpan Perubahan",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
