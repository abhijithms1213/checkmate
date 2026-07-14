import 'package:checkmate/core/constants/app_assets.dart';
import 'package:checkmate/core/constants/app_colors.dart';
import 'package:checkmate/core/widgets/buttons/elevated_btn.dart';
import 'package:checkmate/features/address/presentation/pages/addres_add.dart';
import 'package:checkmate/features/auth/presentation/bloc/otp/otp_bloc.dart';
import 'package:checkmate/features/auth/presentation/bloc/otp/otp_event.dart';
import 'package:checkmate/features/auth/presentation/bloc/otp/otp_state.dart';
import 'package:checkmate/features/bookings/presentation/pages/homepage.dart';
import 'package:checkmate/core/services/local_storage_service.dart';
import 'package:checkmate/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.phone});

  final String phone;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  String get maskedPhone {
    if (widget.phone.length < 6) {
      return widget.phone;
    }

    return '${widget.phone.substring(0, 3)}****${widget.phone.substring(widget.phone.length - 3)}';
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 52,
      height: 62,
      textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.primary, width: 2),
    );

    return BlocListener<OtpBloc, OtpState>(
      listener: (context, state) {
        if (state is UserAlreadyExists) {
          s1<LocalStorageService>().setLoggedIn(true);
          s1<LocalStorageService>().setPhone(widget.phone);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        }

        if (state is NewUser) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => AddAddressScreen(phone: widget.phone),
            ),
          );
        }

        if (state is OtpInvalid) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid or expired OTP')),
          );
        }

        if (state is OtpFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Verify OTP",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 60),

                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(AppAssets.logoOnly),
                      ),
                    ),
                  ),

                  const SizedBox(height: 36),

                  const Text(
                    "Code Verification",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff10243A),
                    ),
                  ),

                  const SizedBox(height: 14),

                  Text(
                    "Enter the 6-digit code sent to\n$maskedPhone",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 40),

                  Pinput(
                    controller: _otpController,
                    length: 6,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: focusedPinTheme,
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 40),

                  BlocBuilder<OtpBloc, OtpState>(
                    builder: (context, state) {
                      return ElevatedBtnWidget(
                        primaryColor: AppColors.primary,
                        content: state is OtpLoading
                            ? 'Verifying...'
                            : 'Verify & Proceed',
                        onTap: state is OtpLoading
                            ? () {}
                            : () {
                                final otp = _otpController.text.trim();

                                if (otp.length != 6) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Please enter a valid OTP'),
                                    ),
                                  );
                                  return;
                                }

                                context.read<OtpBloc>().add(
                                  VerifyOtpEvent(phone: widget.phone, otp: otp),
                                );
                              },
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  Text(
                    "Didn't receive the code?",
                    style: TextStyle(fontSize: 17, color: Colors.grey.shade700),
                  ),

                  const SizedBox(height: 10),

                  TextButton(
                    onPressed: () {
                      /// Resend OTP later
                    },
                    child: const Text(
                      "Resend OTP",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
