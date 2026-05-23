import 'package:flutter/material.dart';

import '../../models/lowongan_model.dart';

class JobDetailUI extends StatelessWidget {
  final LowonganModel job;
  final VoidCallback onOpenLink;

  const JobDetailUI({
    super.key,
    required this.job,
    required this.onOpenLink,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        title: const Text(
          "Detail Lowongan",
          style: TextStyle(
            color: Color(0xFF0F2D3F),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Column(
        children: [
          // CONTENT
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // FOTO LOWONGAN
                  if (job.fotoUrl.isNotEmpty)
                    Container(
                      width: double.infinity,
                      height: 220,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),

                        child: Image.network(
                          job.fotoUrl,
                          fit: BoxFit.cover,

                          errorBuilder: (
                            context,
                            error,
                            stackTrace,
                          ) {
                            return Container(
                              color: Colors.grey.shade200,

                              child: const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  size: 60,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  else
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(24),

                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF3E0),
                          borderRadius: BorderRadius.circular(20),
                        ),

                        child: const Icon(
                          Icons.work,
                          size: 60,
                          color: Color(0xFFEC7004),
                        ),
                      ),
                    ),

                  const SizedBox(height: 24),

                  // POSISI
                  Text(
                    job.posisi,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F2D3F),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // NAMA PERUSAHAAN
                  Text(
                    job.namaPerusahaan,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // INFO
                  infoItem(
                    Icons.location_on,
                    "Lokasi",
                    job.lokasi,
                  ),

                  infoItem(
                    Icons.attach_money,
                    "Gaji",
                    job.gaji,
                  ),

                  infoItem(
                    Icons.access_time,
                    "Batas Lamaran",
                    job.batasLamaran,
                  ),

                  const SizedBox(height: 24),

                  // DESKRIPSI TITLE
                  const Text(
                    "Deskripsi Pekerjaan",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // DESKRIPSI
                  Text(
                    job.deskripsi,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // INFO LINK
                  Container(
                    padding: const EdgeInsets.all(12),

                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: const Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.orange,
                          size: 18,
                        ),

                        SizedBox(width: 8),

                        Expanded(
                          child: Text(
                            "Jika tombol tidak membuka platform lamaran, berarti pembuat lowongan tidak menambahkan link.",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // BUTTON
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                0,
                20,
                16,
              ),

              child: SizedBox(
                width: double.infinity,
                height: 58,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F2D3F),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),

                  onPressed: onOpenLink,

                  child: const Text(
                    "Lihat Loker",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // INFO ITEM
  // =========================
  Widget infoItem(
    IconData icon,
    String title,
    String value,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),

      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFFEC7004),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}