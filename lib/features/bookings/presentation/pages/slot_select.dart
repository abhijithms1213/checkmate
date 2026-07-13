import 'package:checkmate/core/widgets/logo_row.dart';
import 'package:checkmate/features/bookings/presentation/pages/payment.dart';
import 'package:flutter/material.dart';

class SelectSlotScreen extends StatefulWidget {
  const SelectSlotScreen({super.key});

  @override
  State<SelectSlotScreen> createState() => _SelectSlotScreenState();
}

class _SelectSlotScreenState extends State<SelectSlotScreen> {
  int selectedDate = 1;

  String selectedTime = "12:30 PM";

  final List<Map<String, String>> dates = [
    {"day": "MON", "date": "23"},
    {"day": "TUE", "date": "24"},
    {"day": "WED", "date": "25"},
    {"day": "THU", "date": "26"},
    {"day": "FRI", "date": "27"},
  ];

  final List<String> slots = [
    "08:00 AM",
    "08:30 AM",
    "09:00 AM",
    "10:30 AM",
    "12:30 PM",
    "01:00 PM",
    "02:30 PM",
    "03:00 PM",
    "05:30 PM",
    "06:00 PM",
    "07:00 PM",
    "07:30 PM",
  ];

  final List<String> disabledSlots = ["07:00 PM", "07:30 PM"];

  static const Color primaryColor = Color(0xFF006D67);
  static const Color darkBlue = Color(0xFF081E36);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F9FB),

      bottomNavigationBar: Container(
        height: 72,
        padding: const EdgeInsets.all(12),
        color: primaryColor,
        child: Center(
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ReviewPayScreen()),
              );
            },
            child: Text(
              "CONFIRM APPOINTMENT",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                letterSpacing: 1,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              LogoRowWidget(),
              const SizedBox(height: 30),

              const Text(
                "Select Appointment Slot",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: darkBlue,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Full Blood Count & Lipid Profile",
                style: TextStyle(color: Colors.grey.shade700, fontSize: 18),
              ),

              const SizedBox(height: 28),

              /// Date Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          "October 2023",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.chevron_left),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.chevron_right),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    SizedBox(
                      height: 80,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: dates.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final selected = selectedDate == index;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedDate = index;
                              });
                            },
                            child: Container(
                              width: 72,
                              decoration: BoxDecoration(
                                color: selected ? darkBlue : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    dates[index]["day"]!,
                                    style: TextStyle(
                                      color: selected
                                          ? Colors.white
                                          : Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    dates[index]["date"]!,
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: selected
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// Slots
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: slots.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 2.2,
                  ),
                  itemBuilder: (context, index) {
                    final slot = slots[index];

                    final disabled = disabledSlots.contains(slot);

                    final selected = selectedTime == slot;

                    return GestureDetector(
                      onTap: disabled
                          ? null
                          : () {
                              setState(() {
                                selectedTime = slot;
                              });
                            },
                      child: Container(
                        decoration: BoxDecoration(
                          color: selected
                              ? primaryColor
                              : disabled
                              ? const Color(0xffF3F4F6)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Center(
                          child: Text(
                            slot,
                            style: TextStyle(
                              fontSize: 16,
                              color: selected
                                  ? Colors.white
                                  : disabled
                                  ? Colors.grey
                                  : Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 30),

              Divider(color: Colors.grey.shade300),

              const SizedBox(height: 20),

              const Text(
                "BOOKING DETAILS",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                  letterSpacing: 1,
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                "Lab: City Diagnostic Center",
                style: TextStyle(fontSize: 18),
              ),

              const SizedBox(height: 8),

              const Text(
                "Date: Tuesday, October 24",
                style: TextStyle(fontSize: 18),
              ),

              const SizedBox(height: 8),

              Text("Time: $selectedTime", style: const TextStyle(fontSize: 18)),

              const SizedBox(height: 8),

              const Text("Total: \$145.00", style: TextStyle(fontSize: 18)),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
