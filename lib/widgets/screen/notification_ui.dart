import 'package:flutter/material.dart';

class NotificationUI extends StatelessWidget {
  final List notifications;
  final bool Function(String createdAt) isNewNotification;

  const NotificationUI({
    super.key,
    required this.notifications,
    required this.isNewNotification,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Riwayat Notifikasi")),
      body: notifications.isEmpty
          ? const Center(child: Text("Belum ada notifikasi"))
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final item = notifications[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: Stack(
                      children: [
                        const Icon(Icons.notifications),

                        // indikator notif baru (kalau mau aktifkan)
                        // if (isNewNotification(item['created_at']))
                        //   Positioned(
                        //     right: 0,
                        //     child: Container(
                        //       padding: const EdgeInsets.all(4),
                        //       decoration: const BoxDecoration(
                        //         color: Colors.red,
                        //         shape: BoxShape.circle,
                        //       ),
                        //       child: const Text(
                        //         "BARU",
                        //         style: TextStyle(
                        //           fontSize: 8,
                        //           color: Colors.white,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                      ],
                    ),
                    title: Text(item['title'] ?? ''),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['body'] ?? ''),
                        const SizedBox(height: 4),
                        Text(
                          item['created_at'] ?? '',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}