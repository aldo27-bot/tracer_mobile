import 'package:flutter/material.dart';

import '../../models/lowongan_model.dart';

class JobsUI extends StatelessWidget {
  final List<LowonganModel> jobs;

  final bool isLoading;

  final Future<void> Function() onRefresh;

  final Function(LowonganModel) onOpenDetail;

  final VoidCallback onAddJob;

  const JobsUI({
    super.key,
    required this.jobs,
    required this.isLoading,
    required this.onRefresh,
    required this.onOpenDetail,
    required this.onAddJob,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,

        title: const Text(
          "Lowongan Kerja",
          style: TextStyle(
            color: Color(0xFF0F2D3F),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // =========================
      // BODY
      // =========================
      body: jobs.isEmpty
          ? const Center(
              child: Text(
                "Belum ada lowongan pekerjaan",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            )
          : RefreshIndicator(
              onRefresh: onRefresh,

              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: jobs.length,

                itemBuilder: (context, index) {
                  final job = jobs[index];

                  return GestureDetector(
                    onTap: () => onOpenDetail(job),

                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),

                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),

                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // FOTO
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),

                            child: job.fotoUrl.isNotEmpty
                                ? Image.network(
                                    job.fotoUrl,
                                    width: 95,
                                    height: 95,
                                    fit: BoxFit.cover,

                                    errorBuilder: (
                                      context,
                                      error,
                                      stackTrace,
                                    ) {
                                      return Container(
                                        width: 95,
                                        height: 95,
                                        color: Colors.grey.shade200,

                                        child: const Icon(
                                          Icons.broken_image,
                                          color: Colors.grey,
                                          size: 35,
                                        ),
                                      );
                                    },
                                  )
                                : Container(
                                    width: 95,
                                    height: 95,

                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFF3E0),
                                      borderRadius: BorderRadius.circular(16),
                                    ),

                                    child: const Icon(
                                      Icons.work,
                                      color: Color(0xFFEC7004),
                                      size: 40,
                                    ),
                                  ),
                          ),

                          const SizedBox(width: 16),

                          // INFO
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                // POSISI
                                Text(
                                  job.posisi,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F2D3F),
                                  ),
                                ),

                                const SizedBox(height: 6),

                                // PERUSAHAAN
                                Text(
                                  job.namaPerusahaan,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                // LOKASI
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      size: 16,
                                      color: Colors.grey,
                                    ),

                                    const SizedBox(width: 4),

                                    Expanded(
                                      child: Text(
                                        job.lokasi,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 8),

                                // GAJI
                                Text(
                                  job.gaji,
                                  style: const TextStyle(
                                    color: Color(0xFFEC7004),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                // DESKRIPSI
                                Text(
                                  job.deskripsi,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,

                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 13,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                // DEADLINE
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time,
                                      size: 16,
                                      color: Colors.redAccent,
                                    ),

                                    const SizedBox(width: 4),

                                    Text(
                                      "Batas: ${job.batasLamaran}",
                                      style: const TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

      // FLOATING BUTTON
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFEC7004),

        onPressed: onAddJob,

        child: const Icon(Icons.add),
      ),
    );
  }
}