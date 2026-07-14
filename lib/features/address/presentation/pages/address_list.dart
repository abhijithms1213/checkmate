import 'package:checkmate/core/widgets/button.dart';
import 'package:checkmate/features/address/presentation/pages/addres_add.dart';
import 'package:checkmate/features/auth/presentation/pages/login.dart';
import 'package:checkmate/core/services/local_storage_service.dart';
import 'package:checkmate/injection_container.dart';
import 'package:flutter/material.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  static const Color primaryColor = Color(0xFF006D67);
  static const Color darkText = Color(0xFF10243A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),

      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 2),

      body: SafeArea(
        child: Column(
          children: [
            /// Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Lab Services",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: darkText,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    const Text(
                      "Saved Addresses",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: darkText,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "Manage your sample collection locations",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 24),

                    const AddressCard(
                      title: "Home",
                      address1: "42nd Clinical Avenue, Suite 500",
                      address2: "Metropolis, Central District, 10101",
                      isDefault: true,
                      icon: Icons.home_outlined,
                    ),

                    const SizedBox(height: 16),

                    const AddressCard(
                      title: "Office",
                      address1: "Innovation Plaza, Block C",
                      address2: "West Tech Park, Metropolis, 10102",
                      icon: Icons.business_center_outlined,
                    ),

                    const SizedBox(height: 36),

                    SizedBox(
                      width: double.infinity,
                      height: 64,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AddAddressScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: const Text(
                          "+ Add New Address",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      height: 64,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.redAccent, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          await s1<LocalStorageService>().clear();
                          if (context.mounted) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (_) => const LoginScreen()),
                              (route) => false,
                            );
                          }
                        },
                        icon: const Icon(Icons.logout, color: Colors.redAccent),
                        label: const Text(
                          "Log Out",
                          style: TextStyle(color: Colors.redAccent, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddressCard extends StatelessWidget {
  final String title;
  final String address1;
  final String address2;
  final bool isDefault;
  final IconData icon;

  const AddressCard({
    super.key,
    required this.title,
    required this.address1,
    required this.address2,
    required this.icon,
    this.isDefault = false,
  });

  static const Color primaryColor = Color(0xFF006D67);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: primaryColor),
              const SizedBox(width: 8),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const Spacer(),

              if (isDefault)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF82E6D8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Default",
                    style: TextStyle(color: primaryColor),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),

          Text(
            address1,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
          ),

          const SizedBox(height: 6),

          Text(
            address2,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              if (!isDefault)
                const Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: primaryColor,
                      size: 18,
                    ),
                    SizedBox(width: 4),
                    Text(
                      "Set as Default",
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

              const Spacer(),

              // TextButton(
              //   onPressed: () {},
              //   child: const Text(
              //     "Edit",
              //     style: TextStyle(color: Colors.black),
              //   ),
              // ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
