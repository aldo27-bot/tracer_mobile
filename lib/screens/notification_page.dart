import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../widgets/screen/notification_ui.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List notifications = [];
  String? lastSeen;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> saveLastSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_seen_notif', DateTime.now().toIso8601String());
  }

  bool isNewNotification(String createdAt) {
    if (lastSeen == null) return true;

    try {
      DateTime notifTime = DateTime.parse(createdAt);
      DateTime seenTime = DateTime.parse(lastSeen!);
      return notifTime.isAfter(seenTime);
    } catch (e) {
      return false;
    }
  }

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('user_id') ?? 0;

    lastSeen = prefs.getString('last_seen_notif');

    final data = await ApiService.getNotifications(userId);

    final uniqueData = <dynamic>[];
    final ids = <int>{};

    for (var item in data) {
      if (!ids.contains(item['id'])) {
        ids.add(item['id']);
        uniqueData.add(item);
      }
    }

    setState(() {
      notifications = uniqueData;
    });

    saveLastSeen();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationUI(
      notifications: notifications,
      isNewNotification: isNewNotification,
    );
  }
}