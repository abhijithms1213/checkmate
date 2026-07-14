import 'package:checkmate/core/constants/app_assets.dart';
import 'package:checkmate/features/auth/presentation/pages/otp.dart';
import 'package:checkmate/core/widgets/buttons/elevated_btn.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static const Color primaryColor = Color(0xFF006D67);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 30),

              /// Logo
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(AppAssets.logoOnly),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Text(
                    "CheckMate",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff10243A),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              Text(
                "Welcome",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff10243A),
                ),
              ),

              const SizedBox(height: 12),

              Text(
                "Login to access your diagnostics portal.",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 18),
              ),

              const SizedBox(height: 50),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Phone Number",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: "Mobile number",
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Verification code will be sent via SMS.",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),

              const SizedBox(height: 25),

              ElevatedBtnWidget(
                primaryColor: primaryColor,
                content: 'Send OTP',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => OtpScreen()),
                  );
                },
              ),

              const Spacer(),

              _bottom(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottom() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Privacy", style: TextStyle(color: Colors.grey.shade700)),
            const SizedBox(width: 30),
            Text("Terms", style: TextStyle(color: Colors.grey.shade700)),
          ],
        ),

        const SizedBox(height: 15),

        Text(
          "© 2024 CHECKMATE",
          style: TextStyle(color: Colors.grey.shade400, letterSpacing: 1),
        ),

        const SizedBox(height: 30),
      ],
    );
  }
}
