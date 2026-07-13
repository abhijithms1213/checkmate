import 'package:checkmate/features/address/presentation/pages/addres_add.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  static const Color primaryColor = Color(0xFF006D67);

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Colors.blue, width: 2),
    );

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                const SizedBox(height: 10),

                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      "Verify OTP",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 70),

                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xff84E9DA),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.shield_outlined,
                    size: 42,
                    color: primaryColor,
                  ),
                ),

                const SizedBox(height: 40),

                const Text(
                  "Code Verification",
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff10243A),
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  "Enter the 6-digit code sent to your phone",
                  style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
                ),

                const SizedBox(height: 6),

                Text(
                  "number +1 234 *** 7890",
                  style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
                ),

                const SizedBox(height: 45),

                Pinput(
                  length: 6,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                ),

                const SizedBox(height: 50),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => AddAddressScreen()),
                      );
                    },
                    child: const Text(
                      "Verify & Proceed",
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ),
                ),

                const SizedBox(height: 50),

                const Text(
                  "Didn't receive the code?",
                  style: TextStyle(fontSize: 20),
                ),

                const SizedBox(height: 15),

                Text(
                  "Resend Code  (00:59)",
                  style: TextStyle(fontSize: 18, color: Colors.grey.shade400),
                ),

                const SizedBox(height: 80),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock_outline, color: Colors.grey, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      "Secure 256-bit encrypted verification",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
