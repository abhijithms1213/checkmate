import 'dart:developer';
import 'package:checkmate/core/utils/date_extract.dart';
import 'package:checkmate/features/address/presentation/bloc/user_bloc.dart';
import 'package:checkmate/features/address/presentation/bloc/user_state.dart';
import 'package:checkmate/features/appointments/domain/entities/booking_full_details_entity.dart';
import 'package:checkmate/features/reviews/domain/entities/review_entity.dart';
import 'package:checkmate/features/reviews/presentation/bloc/review_bloc.dart';
import 'package:checkmate/features/reviews/presentation/bloc/review_event.dart';
import 'package:checkmate/features/reviews/presentation/bloc/review_state.dart';
import 'package:checkmate/core/services/local_storage_service.dart';
import 'package:checkmate/features/address/domain/repository/user_repo.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:checkmate/features/appointments/presentation/bloc/appointments_bloc.dart';
import 'package:checkmate/features/appointments/presentation/bloc/appointments_event.dart';
import 'package:checkmate/features/appointments/presentation/bloc/appointments_state.dart';
import 'package:checkmate/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class BookingDetailsScreen extends StatelessWidget {
  final String bookingId;

  const BookingDetailsScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              s1<AppointmentsBloc>()..add(GetBookingDetailsEvent(bookingId)),
        ),
        BlocProvider(
          create: (_) =>
              s1<ReviewBloc>()..add(LoadBookingReviewEvent(bookingId)),
        ),
      ],
      child: const _BookingDetailsView(),
    );
  }
}

class _BookingDetailsView extends StatelessWidget {
  const _BookingDetailsView();

  static const Color primaryColor = Color(0xFF006D67);
  static const Color darkText = Color(0xFF10243A);

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FB),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Booking Details",
          style: TextStyle(color: darkText, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: darkText),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<AppointmentsBloc, AppointmentsState>(
          builder: (context, state) {
            if (state is AppointmentsLoading || state is AppointmentsInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is AppointmentsError) {
              return Center(child: Text(state.message));
            }

            if (state is BookingDetailsLoaded) {
              final booking = state.bookingDetails;
              log(
                '[BookingDetails] id=${booking.id} | type=${booking.type} | status=${booking.status}',
              );
              final formattedCreatedDate = formatDate(booking.createdAt);
              final formattedDate = DateFormat(
                'EEE, MMM d, yyyy',
              ).format(booking.bookingDate);
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 32,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),

                          Text(
                            "Booking ID:",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14.spMin,
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: SelectableText(
                                  booking.id,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: darkText,
                                    fontSize: 12.spMin,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.copy, size: 18),
                                tooltip: "Copy Booking ID",
                                onPressed: () async {
                                  await Clipboard.setData(
                                    ClipboardData(text: booking.id),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Booking ID copied"),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          Text(
                            booking.tests.map((e) => e.testName).join(', '),
                            style: TextStyle(
                              fontSize: 28.spMin,
                              height: 1.2,
                              fontWeight: FontWeight.bold,
                              color: darkText,
                            ),
                          ),

                          const SizedBox(height: 32),

                          /// order placed
                          _card(
                            child: Text('ORDER PLACED : $formattedCreatedDate'),
                          ),
                          const SizedBox(height: 18),

                          /// Schedule Card
                          _card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _sectionTitle("SCHEDULE"),
                                const SizedBox(height: 18),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today,
                                      color: primaryColor,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      formattedDate,
                                      style: TextStyle(fontSize: 16.spMin),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 18),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time,
                                      color: primaryColor,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      booking.slotTime,
                                      style: TextStyle(fontSize: 16.spMin),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          /// Lab Card
                          _card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _sectionTitle("LABORATORY"),
                                const SizedBox(height: 18),
                                Text(
                                  booking.labName,
                                  style: TextStyle(
                                    fontSize: 18.spMin,
                                    fontWeight: FontWeight.w600,
                                    color: darkText,
                                  ),
                                ),
                                if (booking.labAddress != null) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    booking.labAddress!,
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      height: 1.5,
                                      fontSize: 15.spMin,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          /// Address Card (Home Collection)
                          if (booking.address != null) ...[
                            _card(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _sectionTitle("HOME COLLECTION ADDRESS"),
                                  const SizedBox(height: 18),
                                  Text(
                                    booking.address!.fullName,
                                    style: TextStyle(
                                      fontSize: 18.spMin,
                                      fontWeight: FontWeight.w600,
                                      color: darkText,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "${booking.address!.houseNumber}, ${booking.address!.fullAddress}\nPincode: ${booking.address!.pincode}",
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      height: 1.5,
                                      fontSize: 15.spMin,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],

                          /// Payment Summary
                          _card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _sectionTitle("PAYMENT SUMMARY"),
                                const SizedBox(height: 24),
                                ...booking.tests.map(
                                  (test) => Padding(
                                    padding: const EdgeInsets.only(bottom: 14),
                                    child: _priceRow(
                                      test.testName,
                                      "₹ ${test.price.toStringAsFixed(0)}",
                                    ),
                                  ),
                                ),
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
                                      "₹ ${booking.totalAmount.toStringAsFixed(0)}",
                                      style: TextStyle(
                                        fontSize: 18.spMin,
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 28),

                          /// ── REVIEW SECTION ──────────────────────────────
                          _BookingReviewSection(booking: booking),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  static Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: child,
    );
  }

  static Widget _sectionTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14.spMin,
        color: Colors.black54,
        letterSpacing: 0.8,
      ),
    );
  }

  static Widget _priceRow(String title, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: TextStyle(fontSize: 16.spMin)),
        ),
        Text(value, style: TextStyle(fontSize: 16.spMin)),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// BOOKING REVIEW SECTION
// ═══════════════════════════════════════════════════════════════

class _BookingReviewSection extends StatelessWidget {
  final BookingFullDetailsEntity booking;

  const _BookingReviewSection({required this.booking});

  static const Color primaryColor = Color(0xFF006D67);
  static const Color darkText = Color(0xFF10243A);
  static const Color starColor = Color(0xFFFFB800);

  Future<String?> _getUserId(BuildContext context) async {
    final userState = context.read<UserBloc>().state;
    if (userState is AddressesLoaded && userState.addresses.isNotEmpty) {
      return userState.addresses.first.userId;
    }
    final phone = s1<LocalStorageService>().phone;
    if (phone != null && phone.isNotEmpty) {
      return await s1<UserRepository>().getUserIdByPhone(phone);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReviewBloc, ReviewState>(
      listener: (context, state) {
        if (state is ReviewSubmitted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Review submitted successfully!'),
              backgroundColor: primaryColor,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );
        } else if (state is ReviewError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red.shade700,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        final bool isLoading = state is ReviewLoading;
        final bool isSubmitting = state is ReviewSubmitting;
        final BookingReviewEntity? existingReview = state is BookingReviewLoaded
            ? state.review
            : null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header
            Row(
              children: [
                const Icon(Icons.star_rounded, color: starColor, size: 22),
                const SizedBox(width: 8),
                Text(
                  "Rate Your Experience",
                  style: TextStyle(
                    fontSize: 18.spMin,
                    fontWeight: FontWeight.w700,
                    color: darkText,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              "Your feedback helps others make better choices.",
              style: TextStyle(fontSize: 13.spMin, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 18),

            if (isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: CircularProgressIndicator(),
                ),
              )
            else
              _BookingReviewForm(
                booking: booking,
                existingReview: existingReview,
                isSubmitting: isSubmitting,
                onSubmit: (params) async {
                  final userId = await _getUserId(context);
                  if (!context.mounted) return;
                  if (userId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("User not found. Please re-login."),
                      ),
                    );
                    return;
                  }
                  context.read<ReviewBloc>().add(
                    SubmitBookingReviewEvent(
                      SubmitBookingReviewParams(
                        bookingId: params.bookingId,
                        userId: userId,
                        bookingType: params.bookingType,
                        overallExperienceRating: params.overallExperienceRating,
                        resultAccuracyRating: params.resultAccuracyRating,
                        resultTurnaroundRating: params.resultTurnaroundRating,
                        review: params.review,
                        waitingTimeRating: params.waitingTimeRating,
                        collectorRating: params.collectorRating,
                        collectorPunctualityRating:
                            params.collectorPunctualityRating,
                        sampleCollectionRating: params.sampleCollectionRating,
                        sampleHandlingRating: params.sampleHandlingRating,
                      ),
                    ),
                  );
                },
              ),
          ],
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// BOOKING REVIEW FORM
// ═══════════════════════════════════════════════════════════════

class _BookingReviewForm extends StatefulWidget {
  final BookingFullDetailsEntity booking;
  final BookingReviewEntity? existingReview;
  final bool isSubmitting;
  final Future<void> Function(SubmitBookingReviewParams params) onSubmit;

  const _BookingReviewForm({
    required this.booking,
    required this.existingReview,
    required this.isSubmitting,
    required this.onSubmit,
  });

  @override
  State<_BookingReviewForm> createState() => _BookingReviewFormState();
}

class _BookingReviewFormState extends State<_BookingReviewForm> {
  static const Color primaryColor = Color(0xFF006D67);
  static const Color darkText = Color(0xFF0C1A30);
  static const Color cardBg = Colors.white;
  static const Color iconBg = Color(0xFFE2F4F2);

  bool _isEditing = false;
  late TextEditingController _reviewController;

  // Mandatory overall rating (1-5)
  int _overallExperienceRating = 0; // Lab / Overall Experience Rating
  int _overallPhlebotomistRating = 0; // Phlebotomist Overall Experience Rating

  // Common optional ratings
  int _resultAccuracyRating = 0; // Result Accuracy
  int _resultTurnaroundRating = 0; // On-Time Results

  // Walk-in optional rating
  int _waitingTimeRating = 0; // Waiting Time

  // Home Collection optional ratings
  int _collectorPunctualityRating = 0; // Punctuality
  int _sampleCollectionRating = 0; // Sample Collection
  int _sampleHandlingRating = 0; // Sample Handling

  bool get _isHomeCollection =>
      widget.booking.type.toLowerCase().contains('home');

  @override
  void initState() {
    super.initState();
    _initFromExisting();
  }

  @override
  void didUpdateWidget(_BookingReviewForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.existingReview == null && widget.existingReview != null) {
      _initFromExisting();
    }
  }

  void _initFromExisting() {
    final r = widget.existingReview;
    _reviewController = TextEditingController(text: r?.review ?? '');
    _isEditing = r == null;

    if (r != null) {
      _overallExperienceRating = r.overallExperienceRating;
      _resultAccuracyRating = r.resultAccuracyRating ?? 0;
      _resultTurnaroundRating = r.resultTurnaroundRating ?? 0;
      _waitingTimeRating = r.waitingTimeRating ?? 0;
      _collectorPunctualityRating = r.collectorPunctualityRating ?? 0;
      _sampleCollectionRating = r.sampleCollectionRating ?? 0;
      _sampleHandlingRating = r.sampleHandlingRating ?? 0;
      _overallPhlebotomistRating = r.collectorRating ?? 0;
    }
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  // Only the overall experience rating (1 to 5) is mandatory now
  bool get _canSubmit => _overallExperienceRating > 0;

  void _submit() {
    widget.onSubmit(
      SubmitBookingReviewParams(
        bookingId: widget.booking.id,
        bookingType: widget.booking.type,
        overallExperienceRating: _overallExperienceRating,
        resultAccuracyRating: _resultAccuracyRating > 0
            ? _resultAccuracyRating
            : null,
        resultTurnaroundRating: _resultTurnaroundRating > 0
            ? _resultTurnaroundRating
            : null,
        review: _reviewController.text.trim().isEmpty
            ? null
            : _reviewController.text.trim(),
        waitingTimeRating: (!_isHomeCollection && _waitingTimeRating > 0)
            ? _waitingTimeRating
            : null,
        collectorRating: _overallPhlebotomistRating > 0
            ? _overallPhlebotomistRating
            : null,
        collectorPunctualityRating:
            (_isHomeCollection && _collectorPunctualityRating > 0)
            ? _collectorPunctualityRating
            : null,
        sampleCollectionRating:
            (_isHomeCollection && _sampleCollectionRating > 0)
            ? _sampleCollectionRating
            : null,
        sampleHandlingRating: (_isHomeCollection && _sampleHandlingRating > 0)
            ? _sampleHandlingRating
            : null,
      ),
    );
    setState(() => _isEditing = false);
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool alreadyReviewed = widget.existingReview != null;

    if (alreadyReviewed && !_isEditing) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.check_circle, color: primaryColor, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    "Review Submitted",
                    style: TextStyle(
                      fontSize: 14.spMin,
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: () => setState(() => _isEditing = true),
                icon: const Icon(Icons.edit_outlined, size: 16),
                label: const Text('Edit Review'),
                style: TextButton.styleFrom(
                  foregroundColor: primaryColor,
                  textStyle: TextStyle(
                    fontSize: 13.spMin,
                    fontWeight: FontWeight.w600,
                  ),
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _ReadOnlyReviewDisplay(
            review: widget.existingReview!,
            labName: widget.booking.labName,
            isHomeCollection: _isHomeCollection,
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_isHomeCollection) ...[
          // ── Card 1: Phlebotomist Overall Rating & Sub-criteria ───────
          _buildCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: iconBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.science_rounded,
                          color: primaryColor,
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Lab Overall Rating",
                            style: TextStyle(
                              fontSize: 16.spMin,
                              fontWeight: FontWeight.w700,
                              color: darkText,
                            ),
                          ),
                          const SizedBox(height: 6),
                          _StarBar(
                            value: _overallExperienceRating,
                            size: 32,
                            spacing: 4,
                            alignment: MainAxisAlignment.spaceBetween,
                            onChanged: (v) =>
                                setState(() => _overallExperienceRating = v),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _RatingRow(
                  label: 'Result Accuracy',
                  icon: Icons.fact_check_outlined,
                  value: _resultAccuracyRating,
                  onChanged: (v) => setState(() => _resultAccuracyRating = v),
                ),
                _RatingRow(
                  label: 'On-Time Results',
                  icon: Icons.timer_outlined,
                  value: _resultTurnaroundRating,
                  isLast: true,
                  onChanged: (v) => setState(() => _resultTurnaroundRating = v),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // ── Card 2: Phlebotomist Overall Rating & Sub-criteria ───────
          _buildCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: iconBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.medical_services_rounded,
                          color: primaryColor,
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Phlebotomist Overall Rating",
                            style: TextStyle(
                              fontSize: 16.spMin,
                              fontWeight: FontWeight.w700,
                              color: darkText,
                            ),
                          ),
                          const SizedBox(height: 6),
                          _StarBar(
                            value: _overallPhlebotomistRating,
                            size: 32,
                            spacing: 4,
                            alignment: MainAxisAlignment.spaceBetween,
                            onChanged: (v) =>
                                setState(() => _overallPhlebotomistRating = v),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _RatingRow(
                  label: 'Punctuality',
                  icon: Icons.access_time_rounded,
                  value: _collectorPunctualityRating,
                  onChanged: (v) =>
                      setState(() => _collectorPunctualityRating = v),
                ),
                _RatingRow(
                  label: 'Sample Collection',
                  icon: Icons.vaccines_rounded,
                  value: _sampleCollectionRating,
                  onChanged: (v) => setState(() => _sampleCollectionRating = v),
                ),
                _RatingRow(
                  label: 'Sample Handling',
                  icon: Icons.inventory_2_outlined,
                  value: _sampleHandlingRating,
                  isLast: true,
                  onChanged: (v) => setState(() => _sampleHandlingRating = v),
                ),
              ],
            ),
          ),
        ] else ...[
          // ── Walk-in Card ─────────────────────────────────────────────
          _buildCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: iconBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.science_rounded,
                          color: primaryColor,
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.booking.labName,
                            style: TextStyle(
                              fontSize: 16.spMin,
                              fontWeight: FontWeight.w700,
                              color: darkText,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: iconBg,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'WALK-IN REVIEW',
                              style: TextStyle(
                                fontSize: 10.spMin,
                                fontWeight: FontWeight.w700,
                                color: primaryColor,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _RatingRow(
                  label: 'Lab Overall Rating',
                  icon: Icons.star_rate_rounded,
                  value: _overallExperienceRating,
                  starSize: 26,
                  isProminent: true,
                  onChanged: (v) =>
                      setState(() => _overallExperienceRating = v),
                ),
                _RatingRow(
                  label: 'Waiting Time',
                  icon: Icons.hourglass_empty_rounded,
                  value: _waitingTimeRating,
                  starSize: 21,
                  onChanged: (v) => setState(() => _waitingTimeRating = v),
                ),
                _RatingRow(
                  label: 'Result Accuracy',
                  icon: Icons.fact_check_outlined,
                  value: _resultAccuracyRating,
                  starSize: 21,
                  onChanged: (v) => setState(() => _resultAccuracyRating = v),
                ),
                _RatingRow(
                  label: 'On-Time Results',
                  icon: Icons.access_time_rounded,
                  value: _resultTurnaroundRating,
                  starSize: 21,
                  isLast: true,
                  onChanged: (v) => setState(() => _resultTurnaroundRating = v),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 16),

        // ── Review text input ──────────────────────────────────────────
        Text(
          "Write your review",
          style: TextStyle(
            fontSize: 13.spMin,
            color: const Color(0xFF4A5568),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),

        Stack(
          children: [
            TextField(
              controller: _reviewController,
              maxLength: 500,
              maxLines: 3,
              minLines: 3,
              onChanged: (_) => setState(() {}),
              style: TextStyle(fontSize: 14.spMin, color: darkText),
              decoration: InputDecoration(
                hintText: "Share your experience...",
                hintStyle: TextStyle(
                  fontSize: 13.spMin,
                  color: const Color(0xFF9AA5B5),
                ),
                filled: true,
                fillColor: Colors.white,
                counterText: "",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: primaryColor, width: 1.5),
                ),
                contentPadding: const EdgeInsets.fromLTRB(14, 12, 14, 28),
              ),
            ),
            Positioned(
              right: 12,
              bottom: 8,
              child: Text(
                "${_reviewController.text.length}/500",
                style: TextStyle(
                  fontSize: 11.spMin,
                  color: const Color(0xFF8C9BAE),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // ── Submit / Cancel Button ────────────────────────────────────
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: widget.isSubmitting || !_canSubmit ? null : _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              disabledBackgroundColor: const Color(0xFFD2D8DF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: widget.isSubmitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    alreadyReviewed ? "Update Review" : "Submit Review",
                    style: TextStyle(
                      fontSize: 15.spMin,
                      color: _canSubmit
                          ? Colors.white
                          : const Color(0xFF8F9CA9),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),

        if (alreadyReviewed && _isEditing) ...[
          const SizedBox(height: 8),
          Center(
            child: TextButton(
              onPressed: () => setState(() => _isEditing = false),
              child: Text(
                "Cancel",
                style: TextStyle(
                  fontSize: 14.spMin,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// STAR BAR HELPER
// ═══════════════════════════════════════════════════════════════

class _StarBar extends StatelessWidget {
  final int value;
  final double size;
  final double spacing;
  final MainAxisAlignment alignment;
  final void Function(int)? onChanged;

  static const Color starColor = Color(0xFFFFB800);
  static const Color emptyStarColor = Color(0xFFB0B9C3);

  const _StarBar({
    required this.value,
    this.size = 24,
    this.spacing = 3,
    this.alignment = MainAxisAlignment.end,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: alignment,
      mainAxisSize: alignment == MainAxisAlignment.spaceBetween
          ? MainAxisSize.max
          : MainAxisSize.min,
      children: List.generate(5, (i) {
        final starIndex = i + 1;
        final bool isFilled = starIndex <= value;
        return GestureDetector(
          onTap: onChanged != null ? () => onChanged!(starIndex) : null,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: EdgeInsets.only(
              left: alignment == MainAxisAlignment.spaceBetween ? 0 : spacing,
            ),
            child: Icon(
              isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
              color: isFilled ? starColor : emptyStarColor,
              size: size,
            ),
          ),
        );
      }),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// STAR RATING ROW
// ═══════════════════════════════════════════════════════════════

class _RatingRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final int value;
  final void Function(int) onChanged;
  final double starSize;
  final bool isProminent;
  final bool isLast;

  static const Color primaryColor = Color(0xFF006D67);
  static const Color darkText = Color(0xFF0C1A30);

  const _RatingRow({
    required this.label,
    required this.icon,
    required this.value,
    required this.onChanged,
    this.starSize = 22,
    this.isProminent = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
      child: Row(
        children: [
          Icon(icon, color: primaryColor, size: isProminent ? 22 : 19),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: isProminent ? 14.5.spMin : 13.5.spMin,
                color: darkText,
                fontWeight: isProminent ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ),
          _StarBar(
            value: value,
            size: starSize,
            spacing: 3,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// READ-ONLY REVIEW DISPLAY
// ═══════════════════════════════════════════════════════════════

class _ReadOnlyReviewDisplay extends StatelessWidget {
  final BookingReviewEntity review;
  final String labName;
  final bool isHomeCollection;

  const _ReadOnlyReviewDisplay({
    required this.review,
    required this.labName,
    this.isHomeCollection = false,
  });

  static const Color primaryColor = Color(0xFF006D67);
  static const Color darkText = Color(0xFF0C1A30);
  static const Color iconBg = Color(0xFFE2F4F2);

  bool get _isHomeCollection =>
      isHomeCollection || review.bookingType.toLowerCase().contains('home');

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _readOnlyRow({
    required String label,
    required IconData icon,
    required int rating,
    double starSize = 21,
    bool isProminent = false,
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: Row(
        children: [
          Icon(icon, color: primaryColor, size: isProminent ? 22 : 19),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: isProminent ? 14.5.spMin : 13.5.spMin,
                color: darkText,
                fontWeight: isProminent ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ),
          _StarBar(value: rating, size: starSize, spacing: 3),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_isHomeCollection) ...[
          // Phlebotomist Card
          _buildCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: iconBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.medical_services_rounded,
                          color: primaryColor,
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Phlebotomist Overall Rating",
                            style: TextStyle(
                              fontSize: 16.spMin,
                              fontWeight: FontWeight.w700,
                              color: darkText,
                            ),
                          ),
                          const SizedBox(height: 6),
                          _StarBar(
                            value: review.overallExperienceRating,
                            size: 32,
                            spacing: 4,
                            alignment: MainAxisAlignment.spaceBetween,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _readOnlyRow(
                  label: 'Punctuality',
                  icon: Icons.access_time_rounded,
                  rating: review.collectorPunctualityRating ?? 0,
                ),
                _readOnlyRow(
                  label: 'Sample Collection',
                  icon: Icons.vaccines_rounded,
                  rating: review.sampleCollectionRating ?? 0,
                ),
                _readOnlyRow(
                  label: 'Sample Handling',
                  icon: Icons.inventory_2_outlined,
                  rating: review.sampleHandlingRating ?? 0,
                  isLast: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          // Lab Card
          _buildCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: iconBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.science_rounded,
                          color: primaryColor,
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Lab Overall Rating",
                            style: TextStyle(
                              fontSize: 16.spMin,
                              fontWeight: FontWeight.w700,
                              color: darkText,
                            ),
                          ),
                          const SizedBox(height: 6),
                          _StarBar(
                            value: review.overallExperienceRating,
                            size: 32,
                            spacing: 4,
                            alignment: MainAxisAlignment.spaceBetween,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (review.resultAccuracyRating != null &&
                    review.resultAccuracyRating! > 0) ...[
                  const SizedBox(height: 18),
                  _readOnlyRow(
                    label: 'Result Accuracy',
                    icon: Icons.fact_check_outlined,
                    rating: review.resultAccuracyRating!,
                  ),
                ],
                if (review.resultTurnaroundRating != null &&
                    review.resultTurnaroundRating! > 0) ...[
                  const SizedBox(height: 18),
                  _readOnlyRow(
                    label: 'On-Time Results',
                    icon: Icons.timer_outlined,
                    rating: review.resultTurnaroundRating!,
                    isLast: true,
                  ),
                ],
              ],
            ),
          ),
        ] else ...[
          // Walk-in Card
          _buildCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: iconBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.science_rounded,
                          color: primaryColor,
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            labName,
                            style: TextStyle(
                              fontSize: 16.spMin,
                              fontWeight: FontWeight.w700,
                              color: darkText,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: iconBg,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'WALK-IN REVIEW',
                              style: TextStyle(
                                fontSize: 10.spMin,
                                fontWeight: FontWeight.w700,
                                color: primaryColor,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _readOnlyRow(
                  label: 'Lab Overall Rating',
                  icon: Icons.star_rate_rounded,
                  rating: review.overallExperienceRating,
                  starSize: 26,
                  isProminent: true,
                ),
                if (review.waitingTimeRating != null &&
                    review.waitingTimeRating! > 0)
                  _readOnlyRow(
                    label: 'Waiting Time',
                    icon: Icons.hourglass_empty_rounded,
                    rating: review.waitingTimeRating ?? 0,
                  ),
                if (review.resultAccuracyRating != null &&
                    review.resultAccuracyRating! > 0)
                  _readOnlyRow(
                    label: 'Result Accuracy',
                    icon: Icons.fact_check_outlined,
                    rating: review.resultAccuracyRating!,
                  ),
                if (review.resultTurnaroundRating != null &&
                    review.resultTurnaroundRating! > 0)
                  _readOnlyRow(
                    label: 'On-Time Results',
                    icon: Icons.access_time_rounded,
                    rating: review.resultTurnaroundRating!,
                    isLast: true,
                  ),
              ],
            ),
          ),
        ],

        if (review.review != null && review.review!.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            "Your Review",
            style: TextStyle(
              fontSize: 13.spMin,
              color: const Color(0xFF4A5568),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Text(
              review.review!,
              style: TextStyle(
                fontSize: 14.spMin,
                color: darkText,
                height: 1.5,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
