import 'package:flutter/material.dart';
import 'package:projectsemester4/screens/notification_page.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeUI extends StatelessWidget {
  final String name;

  final int totalAlumni;

  final double kerjaPercent;
  final double wirausahaPercent;

  final bool hasNotification;

  final DateTime focusedDay;
  final DateTime selectedDay;

  final Function(
    DateTime selected,
    DateTime focused,
  ) onDaySelected;

  final VoidCallback
      onNotificationOpened;

  const HomeUI({
    super.key,
    required this.name,
    required this.totalAlumni,
    required this.kerjaPercent,
    required this.wirausahaPercent,
    required this.hasNotification,
    required this.focusedDay,
    required this.selectedDay,
    required this.onDaySelected,
    required this.onNotificationOpened,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF3F6FB),

      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              // =========================
              // HEADER
              // =========================

              Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,

                children: [
                  const SizedBox(),

                  Stack(
                    children: [
                      IconButton(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const NotificationPage(),
                            ),
                          );

                          onNotificationOpened();
                        },

                        icon: const Icon(
                          Icons.notifications,
                          color: Colors.black,
                        ),
                      ),

                      // titik merah
                      if (hasNotification)
                        Positioned(
                          right: 12,
                          top: 12,

                          child: Container(
                            width: 10,
                            height: 10,

                            decoration:
                                const BoxDecoration(
                              color: Colors.red,
                              shape:
                                  BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 5),

              // =========================
              // sapaan
              // =========================

              Text(
                "Halo ${name.isNotEmpty ? name : 'Alumni'}",

                style: const TextStyle(
                  fontSize: 24,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const Text(
                "Dashboard Tracer Study",

                style: TextStyle(
                  color: Colors.orange,
                ),
              ),

              const SizedBox(height: 25),

              // =========================
              // total alumni
              // =========================

              Container(
                width: double.infinity,

                padding:
                    const EdgeInsets.all(18),

                decoration: BoxDecoration(
                  color:
                      const Color(0xFF0F2D3F),

                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),
                ),

                child: Row(
                  children: [
                    Container(
                      padding:
                          const EdgeInsets
                              .all(12),

                      decoration:
                          BoxDecoration(
                        color: Colors.white
                            .withOpacity(
                          0.15,
                        ),

                        shape:
                            BoxShape.circle,
                      ),

                      child: const Icon(
                        Icons.groups,
                        color:
                            Colors.orange,
                        size: 30,
                      ),
                    ),

                    const SizedBox(
                      width: 15,
                    ),

                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                      children: [
                        const Text(
                          "Total Alumni",

                          style: TextStyle(
                            color: Colors
                                .white70,
                          ),
                        ),

                        const SizedBox(
                          height: 5,
                        ),

                        Text(
                          "$totalAlumni Alumni",

                          style:
                              const TextStyle(
                            color:
                                Colors.white,
                            fontSize: 24,
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // =========================
              // calendar
              // =========================

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius:
                      BorderRadius.circular(
                    25,
                  ),

                  boxShadow: const [
                    BoxShadow(
                      color:
                          Colors.black12,
                      blurRadius: 10,
                    ),
                  ],
                ),

                padding:
                    const EdgeInsets.all(12),

                child: TableCalendar(
                  focusedDay: focusedDay,

                  firstDay:
                      DateTime(2020),

                  lastDay:
                      DateTime(2030),

                  selectedDayPredicate:
                      (day) => isSameDay(
                    selectedDay,
                    day,
                  ),

                  onDaySelected:
                      onDaySelected,

                  onPageChanged:
                      (focused) {},

                  headerStyle:
                      const HeaderStyle(
                    formatButtonVisible:
                        false,
                    titleCentered: true,
                  ),

                  calendarStyle:
                      const CalendarStyle(
                    todayDecoration:
                        BoxDecoration(
                      color: Color.fromARGB(
                        255,
                        236,
                        112,
                        4,
                      ),

                      shape:
                          BoxShape.circle,
                    ),

                    selectedDecoration:
                        BoxDecoration(
                      color:
                          Color(0xFF0F2D3F),

                      shape:
                          BoxShape.circle,
                    ),

                    selectedTextStyle:
                        TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // =========================
              // statistik
              // =========================

              const Text(
                "Statistik Alumni",

                style: TextStyle(
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  statCard(
                    "Kerja",
                    "${kerjaPercent.toStringAsFixed(0)}%",
                    Colors.green,
                  ),

                  const SizedBox(
                    width: 10,
                  ),

                  statCard(
                    "Wirausaha",
                    "${wirausahaPercent.toStringAsFixed(0)}%",
                    Colors.blue,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================
  // CARD STATISTIK
  // =========================

  Widget statCard(
    String title,
    String value,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding:
            const EdgeInsets.all(12),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.circular(15),
        ),

        child: Column(
          children: [
            Text(
              value,

              style: TextStyle(
                color: color,
                fontWeight:
                    FontWeight.bold,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 5),

            Text(title),
          ],
        ),
      ),
    );
  }
}