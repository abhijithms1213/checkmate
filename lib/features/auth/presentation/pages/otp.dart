import 'dart:async';
import 'dart:developer';
import 'package:checkmate/core/utils/otp_gen.dart';
import 'package:checkmate/features/auth/domain/entities/otp_verify.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:checkmate/core/constants/app_assets.dart';
import 'package:checkmate/core/constants/app_colors.dart';
import 'package:checkmate/core/widgets/buttons/elevated_btn.dart';
import 'package:checkmate/features/address/presentation/pages/addres_add.dart';
import 'package:checkmate/features/auth/domain/entities/otp_verify.dart';
import 'package:checkmate/features/auth/presentation/bloc/otp/otp_bloc.dart';
import 'package:checkmate/features/auth/presentation/bloc/otp/otp_event.dart';
import 'package:checkmate/features/auth/presentation/bloc/otp/otp_state.dart';
import 'package:checkmate/features/main/presentation/pages/main_layout.dart';
import 'package:checkmate/features/auth/presentation/pages/login.dart';
import 'package:checkmate/core/services/local_storage_service.dart';
import 'package:checkmate/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:whatsapp_zero_tap/whatsapp_zero_tap.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.phone});

  final String phone;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  final WhatsappZeroTap _whatsappZeroTapPlugin = WhatsappZeroTap();
  String _otp = '';

  Timer? _timer;
  int _secondsRemaining = 61;
  bool _canResend = false;
  bool _isWaitingForOtp = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    initOtp();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        initWhatsAppListener();
      }
    });
  }

  Future<void> initOtp() async {
    // Trigger your existing backend/BLoC flow.
    context.read<OtpBloc>().add(
      AddOtpEvent(
        OtpVerificationEntity(
          phone: widget.phone,
          otp: generateOtp(),
          expiresAt: DateTime.now().add(const Duration(minutes: 5)),
          verified: false,
        ),
      ),
    );
  }

  Future<void> initWhatsAppListener() async {
    debugPrint(
      'WA installed: ${await _whatsappZeroTapPlugin.isWhatsAppInstalled()}',
    );
    debugPrint(
      'Handshake supported: ${await _whatsappZeroTapPlugin.isWhatsAppOtpHandshakeSupported()}',
    );
    if (_isWaitingForOtp) return;

    setState(() => _isWaitingForOtp = true);

    try {
      // Start listening before requesting OTP delivery.
      final otpFuture = _whatsappZeroTapPlugin.listenForOTP(
        timeout: const Duration(seconds: 30),
      );

      final receivedOtp = await otpFuture;

      if (!mounted) return;

      if (receivedOtp != null && RegExp(r'^\d{6}$').hasMatch(receivedOtp)) {
        log('OTP received: $receivedOtp');
        _otpController.value = TextEditingValue(
          text: receivedOtp,
          selection: TextSelection.collapsed(offset: receivedOtp.length),
        );

        setState(() => _otp = receivedOtp);
      } else {
        debugPrint('Zero-Tap returned no valid six-digit OTP.');
        log('OTP received in else cAse: $otpFuture');
      }

      setState(() => _otp = receivedOtp!);
      log('after if: $otpFuture');
    } on PlatformException catch (e) {
      debugPrint('Zero-Tap error: ${e.code}');
    } catch (e) {
      debugPrint('OTP listener failed: ${e.runtimeType}');
    } finally {
      if (mounted) {
        setState(() => _isWaitingForOtp = false);
      }
    }
  }

  void _startTimer() {
    setState(() {
      _secondsRemaining = 60;
      _canResend = false;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  void _resendOtp() {
    if (!_canResend) return;
    final String otp = generateOtp();
    context.read<OtpBloc>().add(
      AddOtpEvent(
        OtpVerificationEntity(
          phone: widget.phone,
          otp: otp,
          expiresAt: DateTime.now().add(const Duration(minutes: 5)),
          verified: false,
        ),
      ),
    );
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  String get maskedPhone {
    if (widget.phone.length < 6) return widget.phone;
    return '${widget.phone.substring(0, 3)}****${widget.phone.substring(widget.phone.length - 3)}';
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 52,
      height: 62,
      textStyle: TextStyle(fontSize: 22.spMin, fontWeight: FontWeight.w600),
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
          if (state.pincode != null && state.pincode!.isNotEmpty) {
            s1<LocalStorageService>().setPincode(state.pincode!);
          }
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const MainLayout()),
            (route) => false,
          );
        }

        if (state is NewUser) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => AddAddressScreen(phone: widget.phone),
            ),
            (route) => false,
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

        // if (state is OtpSuccess) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(content: Text('OTP resent! Check your SMS.')),
        //   );
        // }
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            log('message: $_otp');
          },
        ),
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
                        icon: const Icon(Icons.arrow_back_ios_new),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Verify OTP",
                        style: TextStyle(
                          fontSize: 24.spMin,
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

                  Text(
                    "Code Verification",
                    style: TextStyle(
                      fontSize: 32.spMin,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff10243A),
                    ),
                  ),

                  const SizedBox(height: 14),

                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text:
                              "Enter the 6-digit code sent to\n$maskedPhone on ",
                        ),
                        const TextSpan(
                          text: "Whatsapp",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff10243A),
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17.spMin,
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

                  const SizedBox(height: 32),

                  Text(
                    "Didn't receive the code?",
                    style: TextStyle(
                      fontSize: 17.spMin,
                      color: Colors.grey.shade700,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Resend button / countdown timer
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _canResend
                        ? TextButton(
                            key: const ValueKey('resend'),
                            onPressed: _resendOtp,
                            child: Text(
                              "Resend OTP",
                              style: TextStyle(
                                fontSize: 17.spMin,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          )
                        : Text(
                            key: const ValueKey('countdown'),
                            "Resend in 0:${_secondsRemaining.toString().padLeft(2, '0')}",
                            style: TextStyle(
                              fontSize: 16.spMin,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w500,
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
