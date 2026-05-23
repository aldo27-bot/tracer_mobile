import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api_service.dart';
import '../widgets/screen/home_ui.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() =>
      _HomePageState();
}

class _HomePageState
    extends State<HomePage> {
  String name = "";

  double progress = 0;

  bool hasNotification = true;

  // =========================
  // statistik realtime
  // =========================

  double kerjaPercent = 0;
  double wirausahaPercent = 0;

  int totalAlumni = 0;

  DateTime focusedDay = DateTime.now();
  DateTime selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();

    getName();
    loadStatistik();
    loadProgress();
  }

  // =========================
  // load progress
  // =========================

  Future<void> loadProgress() async {
    final prefs =
        await SharedPreferences.getInstance();

    setState(() {
      progress =
          prefs.getDouble("progress") ?? 0;
    });
  }

  // =========================
  // ambil nama
  // =========================

  Future<void> getName() async {
    final prefs =
        await SharedPreferences.getInstance();

    setState(() {
      name = prefs.getString('name') ?? "";
    });
  }

  // =========================
  // statistik alumni
  // =========================

  Future<void> loadStatistik() async {
    try {
      final res =
          await ApiService.getStatistikAlumni();

      if (res['status'] == true) {
        final data = res['data'];

        int total = data['total'];
        int kerja = data['kerja'];
        int wirausaha =
            data['wirausaha'];

        setState(() {
          totalAlumni = total;

          kerjaPercent = total > 0
              ? (kerja / total) * 100
              : 0;

          wirausahaPercent = total > 0
              ? (wirausaha / total) * 100
              : 0;
        });
      }
    } catch (e) {
      debugPrint(
        "ERROR STATISTIK: $e",
      );
    }
  }

  // =========================
  // select calendar
  // =========================

  void onDaySelected(
    DateTime selected,
    DateTime focused,
  ) {
    setState(() {
      selectedDay = selected;
      focusedDay = focused;
    });
  }

  // =========================
  // notif opened
  // =========================

  void onNotificationOpened() {
    setState(() {
      hasNotification = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return HomeUI(
      name: name,
      totalAlumni: totalAlumni,
      kerjaPercent: kerjaPercent,
      wirausahaPercent:
          wirausahaPercent,
      hasNotification:
          hasNotification,
      focusedDay: focusedDay,
      selectedDay: selectedDay,
      onDaySelected:
          onDaySelected,
      onNotificationOpened:
          onNotificationOpened,
    );
  }
}