import 'dart:async';

import 'package:flutter/material.dart';

import '../models/lowongan_model.dart';
import '../services/api_service.dart';

import '../widgets/jobs/jobs_ui.dart';

import 'job_detail_page.dart';
import 'add_job_page.dart';

class JobsPage extends StatefulWidget {
  const JobsPage({super.key});

  @override
  State<JobsPage> createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> {
  List<LowonganModel> jobs = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getLowongan();
  }

  // =========================
  // GET DATA LOWONGAN
  // =========================
  Future<void> getLowongan() async {
    try {
      final data = await ApiService.getLowongan();

      setState(() {
        jobs = data;
        isLoading = false;
      });
    } catch (e) {
      print("ERROR LOWONGAN: $e");

      setState(() {
        isLoading = false;
      });
    }
  }

  // =========================
  // OPEN DETAIL
  // =========================
  void openDetail(LowonganModel job) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => JobDetailPage(job: job),
      ),
    );
  }

  // =========================
  // ADD LOWONGAN
  // =========================
  Future<void> openAddJob() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddJobPage(),
      ),
    );

    if (result == true) {
      getLowongan();
    }
  }

  @override
  Widget build(BuildContext context) {
    return JobsUI(
      jobs: jobs,
      isLoading: isLoading,
      onRefresh: getLowongan,
      onOpenDetail: openDetail,
      onAddJob: openAddJob,
    );
  }
}