import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:checkmate/core/constants/constants.dart';
import 'package:checkmate/core/widgets/logo_with_back_btn.dart';
import 'package:checkmate/features/address/domain/entities/address_entity.dart';
import 'package:checkmate/features/address/presentation/bloc/user_bloc.dart';
import 'package:checkmate/features/address/presentation/bloc/user_state.dart';
import 'package:checkmate/features/bookings/data/data_sources/lab_datasource.dart';
import 'package:checkmate/features/bookings/data/models/booking_request_model.dart';
import 'package:checkmate/features/bookings/domain/entities/lab_entity.dart';
import 'package:checkmate/features/bookings/domain/entities/test_entity.dart';
import 'package:checkmate/features/bookings/presentation/pages/success.dart';
import 'package:checkmate/features/bookings/presentation/bloc/labs/labs_bloc.dart';
import 'package:checkmate/features/bookings/presentation/bloc/labs/labs_event.dart';
import 'package:checkmate/features/bookings/presentation/bloc/labs/labs_state.dart';
import 'package:checkmate/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'dart:developer';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class ReviewPayScreen extends StatefulWidget {
  const ReviewPayScreen({
    super.key,
    required this.labs,
    required this.test,
    required this.selectedDate,
    required this.selectedTime,
    required this.selectedSlotId,
    required this.collectionType,
  });
  final LabEntity labs;
  final TestEntity test;
  final String selectedDate; // ISO8601 string
  final String selectedTime;
  final String selectedSlotId;
  final String collectionType; // 'Home Collection' or 'Walk-in'

  @override
  State<ReviewPayScreen> createState() => _ReviewPayScreenState();
}

class _ReviewPayScreenState extends State<ReviewPayScreen> {
  String selectedPayment = "Pay Online (Razorpay)";
  late Razorpay _razorpay;

  static const Color primaryColor = Color(0xFF006D67);

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    _processOrder(transactionId: response.paymentId);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment failed: ${response.message ?? "Unknown error"}'),
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('External Wallet Selected: ${response.walletName}'),
      ),
    );
  }

  void _processOrder({String? transactionId}) {
    final userState = context.read<UserBloc>().state;
    if (userState is AddressesLoaded && userState.addresses.isNotEmpty) {
      AddressEntity? defaultAddress;
      try {
        defaultAddress = userState.addresses.firstWhere((a) => a.isDefault);
      } catch (_) {
        defaultAddress = userState.addresses.first;
      }

      final request = BookingRequestModel(
        userId: defaultAddress.userId,
        addressId: defaultAddress.id ?? '',
        labId: widget.labs.id,
        slotId: widget.selectedSlotId,
        bookingDate: DateTime.parse(widget.selectedDate),
        totalAmount: widget.labs.price,
        type: widget.collectionType,
        tests: [
          BookingTestItem(testId: widget.test.id, price: widget.labs.price),
        ],
        transactionId: transactionId,
        paymentStatus: transactionId != null ? 'completed' : 'pending',
      );

      log(
        'PAYMENT PAYLOAD: userId: ${request.userId}, addressId: ${request.addressId}, labId: ${request.labId}, slotId: ${request.slotId}, date: ${request.bookingDate}, amount: ${request.totalAmount}, testId: ${request.tests.first.testId}',
      );

      context.read<LabsBloc>().add(PlaceOrderEvent(request));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add an address first')),
      );
    }
  }

  String get _formattedDate {
    try {
      final dt = DateTime.parse(widget.selectedDate);
      return DateFormat('EEE, MMM d yyyy').format(dt);
    } catch (_) {
      return widget.selectedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final price = widget.labs.price;

    return BlocListener<LabsBloc, LabsState>(
      listener: (context, state) {
        if (state is OrderPlacing) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (ctx) => const Center(child: CircularProgressIndicator()),
          );
        } else if (state is OrderPlaced) {
          Navigator.of(context, rootNavigator: true).pop(); // dismiss dialog
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => BookingSuccessScreen(
                booking: state.booking,
                labName: widget.labs.name,
                testName: widget.test.name,
                selectedTime: widget.selectedTime,
              ),
            ),
            (route) => false,
          );
        } else if (state is LabsError) {
          Navigator.of(context, rootNavigator: true).pop(); // dismiss dialog
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Order failed: ${state.message}')),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xffF8F9FB),
        body: SafeArea(
          child: Column(
            children: [
              /// Header
              CmpnyNameWithBackBtnWidget(),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Title
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Review & Pay",
                              style: TextStyle(
                                fontSize: 24.spMin,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF10243A),
                              ),
                            ),
                          ),
                          Text(
                            "Final Step",
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 16.spMin,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      const Divider(),
                      const SizedBox(height: 20),

                      //--------------------------------------------------
                      // CONTACT INFO
                      //--------------------------------------------------
                      _sectionLabel("CONTACT INFO"),
                      const SizedBox(height: 12),
                      BlocBuilder<UserBloc, UserState>(
                        builder: (context, state) {
                          AddressEntity? defaultAddress;
                          if (state is AddressesLoaded &&
                              state.addresses.isNotEmpty) {
                            try {
                              defaultAddress = state.addresses.firstWhere(
                                (a) => a.isDefault,
                              );
                            } catch (_) {
                              defaultAddress = state.addresses.first;
                            }
                          }

                          return _infoCard(
                            children: [
                              _infoRow(
                                Icons.person_outline,
                                "Name",
                                defaultAddress?.fullName ?? '—',
                              ),
                              const Divider(height: 24),
                              _infoRow(
                                Icons.location_on_outlined,
                                "Service Pincode",
                                defaultAddress?.pincode ?? '—',
                              ),
                              const Divider(height: 24),
                              _infoRow(
                                Icons.home_outlined,
                                "Address",
                                defaultAddress != null
                                    ? '${defaultAddress.houseNumber}, ${defaultAddress.fullAddress}'
                                    : '—',
                              ),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      //--------------------------------------------------
                      // TEST DETAILS
                      //--------------------------------------------------
                      _sectionLabel("TEST DETAILS"),
                      const SizedBox(height: 12),
                      _infoCard(
                        children: [
                          _infoRow(
                            Icons.science_outlined,
                            "Test",
                            widget.test.name,
                          ),
                          if (widget.test.category != null) ...[
                            const Divider(height: 24),
                            _infoRow(
                              Icons.category_outlined,
                              "Category",
                              widget.test.category!,
                            ),
                          ],
                          if (widget.test.description != null) ...[
                            const Divider(height: 24),
                            _infoRow(
                              Icons.info_outline,
                              "Description",
                              widget.test.description!,
                            ),
                          ],
                        ],
                      ),

                      const SizedBox(height: 24),

                      //--------------------------------------------------
                      // LABORATORY
                      //--------------------------------------------------
                      _sectionLabel("LABORATORY"),
                      const SizedBox(height: 12),
                      _infoCard(
                        children: [
                          _infoRow(
                            Icons.local_hospital_outlined,
                            "Lab Name",
                            widget.labs.name,
                          ),
                          if (widget.labs.description != null) ...[
                            const Divider(height: 24),
                            _infoRow(
                              Icons.place_outlined,
                              "Location",
                              widget.labs.description!,
                            ),
                          ],

                          if (widget.labs.description != null) ...[
                            const Divider(height: 24),
                            _infoRow(
                              Icons.place_outlined,
                              "About Lab",
                              widget.labs.address!,
                            ),
                          ],
                        ],
                      ),

                      const SizedBox(height: 24),

                      //--------------------------------------------------
                      // SCHEDULE
                      //--------------------------------------------------
                      _sectionLabel("SCHEDULE"),
                      const SizedBox(height: 12),
                      _infoCard(
                        children: [
                          _infoRow(
                            Icons.calendar_today_outlined,
                            "Date",
                            _formattedDate,
                          ),
                          const Divider(height: 24),
                          _infoRow(
                            Icons.access_time_outlined,
                            "Time Slot",
                            widget.selectedTime,
                          ),
                          const Divider(height: 24),
                          _infoRow(
                            widget.collectionType == 'Home Collection'
                                ? Icons.home_outlined
                                : Icons.local_hospital_outlined,
                            "Collection Type",
                            widget.collectionType,
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      //--------------------------------------------------
                      // PAYMENT METHOD
                      //--------------------------------------------------
                      Text(
                        "Payment Method",
                        style: TextStyle(
                          fontSize: 18.spMin,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      // const SizedBox(height: 16),
                      // _paymentTile("Pay at Lab", Icons.account_balance_outlined),
                      const SizedBox(height: 10),
                      _paymentTile(
                        "Pay Online (Razorpay)",
                        Icons.qr_code_outlined,
                      ),

                      const SizedBox(height: 40),

                      //--------------------------------------------------
                      // ORDER SUMMARY
                      //--------------------------------------------------
                      Text(
                        "Order Summary",
                        style: TextStyle(
                          fontSize: 18.spMin,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 20),

                      _priceRow(widget.test.name, "₹ $price"),
                      const SizedBox(height: 12),
                      const Divider(),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Text(
                            "Total Amount",
                            style: TextStyle(
                              fontSize: 18.spMin,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "₹ $price",
                            style: TextStyle(
                              fontSize: 18.spMin,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),

                      //--------------------------------------------------
                      // CONFIRM BUTTON
                      //--------------------------------------------------
                      SizedBox(
                        width: double.infinity,
                        height: 58,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () async {
                            if (selectedPayment == "Pay at Lab") {
                              _processOrder();
                            } else {
                              const bool isProduction = bool.fromEnvironment(
                                'dart.vm.product',
                              );

                              log('is Production: $isProduction');
                              final razorpayKey = isProduction
                                  ? razorpayKeyIdLive
                                  : razorpayKeyIdTest;
                              // Pay Online via Razorpay
                              var options = {
                                'key': razorpayKeyIdTest, // Test Key
                                'amount': (widget.labs.price * 100).toInt(),
                                'name': 'CheckMate Diagnostics',
                                'description': widget.test.name,
                                'timeout': 300,
                                'theme': {
                                  'color': '#006D67', // CheckMate primary color
                                },
                              };

                              try {
                                _razorpay.open(options);
                              } catch (e) {
                                log('Error starting razorpay: $e');
                              }
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Confirm & Pay",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.spMin,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward, color: Colors.white),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),
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

  Widget _infoCard({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: primaryColor, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.spMin,
                  color: Colors.black54,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15.spMin,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF10243A),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _paymentTile(String title, IconData icon) {
    final isSelected = selectedPayment == title;

    return InkWell(
      onTap: () {
        setState(() {
          selectedPayment = title;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 58,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? primaryColor : const Color(0xFFD1D5DB),
            width: isSelected ? 1.5 : 1,
          ),
          color: isSelected ? const Color(0xFFE8F5F4) : Colors.white,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? primaryColor : Colors.grey,
              size: 22,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(title, style: TextStyle(fontSize: 16.spMin)),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? primaryColor : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  static Widget _sectionLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12.spMin,
        color: Colors.black54,
        letterSpacing: 0.8,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  static Widget _priceRow(String title, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(fontSize: 15.spMin, color: Colors.black87),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 15.spMin,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
