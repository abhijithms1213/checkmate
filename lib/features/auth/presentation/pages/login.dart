import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:checkmate/core/constants/app_assets.dart';
import 'package:checkmate/core/utils/otp_gen.dart';
import 'package:checkmate/core/widgets/buttons/elevated_btn.dart';
import 'package:checkmate/features/auth/domain/entities/otp_verify.dart';
import 'package:checkmate/features/auth/presentation/bloc/otp/otp_bloc.dart';
import 'package:checkmate/features/auth/presentation/bloc/otp/otp_event.dart';
import 'package:checkmate/features/auth/presentation/bloc/otp/otp_state.dart';
import 'package:checkmate/features/auth/presentation/pages/otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const Color primaryColor = Color(0xFF006D67);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _sendOtp() {
    final phone = _phoneController.text.trim();

    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter phone number')),
      );
      return;
    }

    // final otp = generateOtp();
    final otp = '123456';

    context.read<OtpBloc>().add(
      AddOtpEvent(
        OtpVerificationEntity(
          phone: phone,
          otp: otp,
          expiresAt: DateTime.now().add(const Duration(minutes: 5)),
          verified: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OtpBloc, OtpState>(
      listener: (context, state) {
        if (state is OtpSuccess) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OtpScreen(phone: _phoneController.text.trim()),
            ),
          );
        }

        if (state is OtpFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 30),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
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
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 18.spMin),
                      ),

                      const SizedBox(height: 50),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Phone Number",
                          style: TextStyle(fontSize: 18.spMin, fontWeight: FontWeight.w500),
                        ),
                      ),

                      const SizedBox(height: 10),

                      TextField(
                        controller: _phoneController,
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

                      BlocBuilder<OtpBloc, OtpState>(
                        builder: (context, state) {
                          return ElevatedBtnWidget(
                            primaryColor: LoginScreen.primaryColor,
                            content: state is OtpLoading ? 'Sending...' : 'Send OTP',
                            onTap: state is OtpLoading ? () {} : _sendOtp,
                          );
                        },
                      ),

                      const Spacer(),

                      _bottom(),
                    ],
                  ),
                ),
              ),
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
