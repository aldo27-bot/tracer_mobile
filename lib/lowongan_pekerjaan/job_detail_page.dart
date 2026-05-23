import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/lowongan_model.dart';
import '../widgets/jobs/job_detail_ui.dart';

class JobDetailPage extends StatelessWidget {
  final LowonganModel job;

  const JobDetailPage({
    super.key,
    required this.job,
  });

  // =========================
  // OPEN LINK
  // =========================
  Future<void> openLink(BuildContext context) async {
    // jika link kosong
    if (job.linkLamaran.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Link lamaran tidak tersedia",
          ),
        ),
      );

      return;
    }

    final Uri url = Uri.parse(job.linkLamaran);

    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Tidak dapat membuka link",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return JobDetailUI(
      job: job,
      onOpenLink: () => openLink(context),
    );
  }
}