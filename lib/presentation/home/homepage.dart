import 'dart:developer';

import 'package:checkmate/presentation/bookings/book_lab.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedCategory = 0;

  final List<String> categories = ["All", "Blood", "Heart", "Women", "Hormone"];

  final List<TestModel> tests = [
    TestModel(
      title: "Full Blood Count (FBC)",
      price: "\$45.00",
      icon: Icons.science_outlined,
    ),
    TestModel(
      title: "Thyroid Profile (T3, T4, TSH)",
      price: "\$68.00",
      icon: Icons.biotech_outlined,
    ),
    TestModel(
      title: "Lipid Profile",
      price: "\$85.00",
      icon: Icons.monitor_heart_outlined,
    ),
    TestModel(
      title: "Vitamin D & B12 Panel",
      price: "\$120.00",
      icon: Icons.medication_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6F8),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: const Color(0xff00796B),
        unselectedItemColor: Colors.black54,
        onTap: (value) {},
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            label: "Bookings",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 12),

              /// Header
              Row(
                children: [
                  const Icon(Icons.medical_services_outlined, size: 28),
                  const SizedBox(width: 8),
                  const Text(
                    "CheckMate",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
                  ),

                  const Spacer(),

                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications_none),
                  ),

                  const CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage("https://i.pravatar.cc/100"),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// Search
              TextField(
                decoration: InputDecoration(
                  hintText: "Search tests...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// Categories
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final selected = selectedCategory == index;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = index;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        decoration: BoxDecoration(
                          color: selected
                              ? const Color(0xff071B35)
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Center(
                          child: Text(
                            categories[index],
                            style: TextStyle(
                              color: selected ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 28),

              /// Popular Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Popular Tests",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    "View All",
                    style: TextStyle(
                      color: Color(0xff00796B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// Test List
              Expanded(
                child: ListView.separated(
                  itemCount: tests.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return TestTile(test: tests[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TestTile extends StatelessWidget {
  final TestModel test;

  const TestTile({super.key, required this.test});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        log('test ${test.title}');
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => LabBookingScreen()));
      },
      child: Container(
        height: 84,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: const Color(0xffF1F3F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(test.icon, color: const Color(0xff00796B)),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Text(
                test.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            Text(
              test.price,
              style: const TextStyle(
                color: Color(0xff00796B),
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TestModel {
  final String title;
  final String price;
  final IconData icon;

  TestModel({required this.title, required this.price, required this.icon});
}
