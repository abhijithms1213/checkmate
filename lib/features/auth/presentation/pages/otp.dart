import 'package:checkmate/core/constants/app_assets.dart';
import 'package:checkmate/core/constants/app_colors.dart';
import 'package:checkmate/features/address/presentation/pages/addres_add.dart';
import 'package:checkmate/core/widgets/buttons/elevated_btn.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key, required this.phone});
  final String phone;
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
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(AppAssets.logoOnly),
                    ),
                    shape: BoxShape.circle,
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
                  "Enter the 4-digit code sent to your phone +1 234 *** 7890",
                  style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 45),

                Pinput(
                  length: 4,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                ),

                const SizedBox(height: 50),

                ElevatedBtnWidget(
                  primaryColor: AppColors.primary,
                  content: 'Verify & Proceed',

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AddAddressScreen()),
                    );
                  },
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
