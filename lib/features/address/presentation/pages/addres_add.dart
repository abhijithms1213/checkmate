import 'package:checkmate/core/widgets/buttons/elevated_btn.dart';
import 'package:checkmate/features/home/presentation/pages/homepage.dart';
import 'package:flutter/material.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  static const Color primaryColor = Color(0xFF006D67);
  static const Color darkText = Color(0xFF10243A);

  int selectedType = 0;

  final addressTypes = ["Home", "Office", "Other"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FB),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Add Address",
          style: TextStyle(color: darkText, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, color: darkText),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Location Placeholder
                    Container(
                      height: 160,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F3F5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 50,
                            color: primaryColor,
                          ),
                          SizedBox(height: 12),
                          Text(
                            "Enter your diagnostic delivery or\nservice location",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    _label("Full Name"),
                    const SizedBox(height: 8),

                    _textField(hint: "e.g. Johnathan Doe"),

                    const SizedBox(height: 16),

                    _label("house Number"),

                    const SizedBox(height: 8),

                    _textField(hint: "123 abcd"),
                    const SizedBox(height: 16),

                    _label("Full Address"),
                    const SizedBox(height: 8),

                    _textField(hint: "House number and street name"),

                    const SizedBox(height: 24),

                    _label("pincode"),
                    const SizedBox(height: 8),

                    _textField(hint: "695003"),

                    const SizedBox(height: 36),
                  ],
                ),
              ),
            ),

            /// Bottom Button
            Padding(
              padding: const EdgeInsets.all(24),
              child: ElevatedBtnWidget(
                primaryColor: primaryColor,
                content: 'Save Address',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textField({required String hint}) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF1F3F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        color: Colors.black87,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
