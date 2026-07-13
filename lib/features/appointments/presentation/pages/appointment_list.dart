import 'package:flutter/material.dart';

class MyAppointmentsScreen extends StatelessWidget {
  const MyAppointmentsScreen({super.key});

  static const Color primaryColor = Color(0xFF006D67);
  static const Color darkText = Color(0xFF10243A);

  @override
  Widget build(BuildContext context) {
    final appointments = [
      AppointmentModel(
        amount: "\$124.00",
        title: "Comprehensive Blood Panel",
        center: "Boutique Diagnostics Center",
        date: "Oct 24, 2023",
        time: "09:30 AM",
      ),
      AppointmentModel(
        amount: "\$45.00",
        title: "Rapid PCR COVID-19 Test",
        center: "Express Health Hub",
        date: "Oct 26, 2023",
        time: "11:00 AM",
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: primaryColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.science_outlined),
            label: "Labs",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            label: "Appointments",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),

      body: SafeArea(
        child: Column(
          children: [
            /// Header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.arrow_back,
                    color: darkText,
                  ),

                  const SizedBox(width: 16),

                  const Text(
                    "Lab Services",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: darkText,
                    ),
                  ),

                  const Spacer(),

                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.more_vert,
                      color: darkText,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "My Appointments",
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: darkText,
                      ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                itemCount: appointments.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: 24),
                itemBuilder: (_, index) {
                  return AppointmentCard(
                    appointment: appointments[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final AppointmentModel appointment;

  const AppointmentCard({
    super.key,
    required this.appointment,
  });

  static const Color primaryColor = Color(0xFF006D67);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            appointment.amount,
            style: const TextStyle(
              color: primaryColor,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 18),

          Text(
            appointment.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF10243A),
            ),
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: Colors.grey.shade600,
                size: 18,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  appointment.center,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Divider(
            color: Colors.grey.shade300,
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                color: primaryColor,
              ),
              const SizedBox(width: 12),
              Text(
                appointment.date,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 18,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              const Icon(
                Icons.access_time,
                color: primaryColor,
              ),
              const SizedBox(width: 12),
              Text(
                appointment.time,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 18,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 58,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          primaryColor,
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          12,
                        ),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text(
                      "View Details",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Container(
                height: 58,
                width: 58,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),
                ),
                child: const Icon(
                  Icons.more_horiz,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AppointmentModel {
  final String amount;
  final String title;
  final String center;
  final String date;
  final String time;

  AppointmentModel({
    required this.amount,
    required this.title,
    required this.center,
    required this.date,
    required this.time,
  });
}