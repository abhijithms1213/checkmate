
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
          create: (_) => s1<ReviewBloc>(),
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
  static const Color starColor = Color(0xFFFFB800);

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

  /// Load reviews once the booking details are available
  Future<void> _loadReviews(
    BuildContext context,
    BookingFullDetailsEntity booking,
  ) async {
    String? userId;
    final userState = context.read<UserBloc>().state;
    if (userState is AddressesLoaded && userState.addresses.isNotEmpty) {
      userId = userState.addresses.first.userId;
    }
    if (userId == null) {
      final phone = s1<LocalStorageService>().phone;
      if (phone != null && phone.isNotEmpty) {
        userId = await s1<UserRepository>().getUserIdByPhone(phone);
      }
    }
    if (userId == null || !context.mounted) return;

    context.read<ReviewBloc>().add(
          LoadReviewsEvent(
            labId: booking.labId,
            userId: userId,
            tests: booking.tests
                .map((t) => {'testId': t.testId, 'testName': t.testName})
                .toList(),
          ),
        );
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
        child: BlocConsumer<AppointmentsBloc, AppointmentsState>(
          listener: (context, state) {
            if (state is BookingDetailsLoaded) {
              _loadReviews(context, state.bookingDetails);
            }
          },
          builder: (context, state) {
            if (state is AppointmentsLoading || state is AppointmentsInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is AppointmentsError) {
              return Center(child: Text(state.message));
            }

            if (state is BookingDetailsLoaded) {
              final booking = state.bookingDetails;
              final formattedCreatedDate = formatDate(
                booking.createdAt,
              );
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
                            child:
                                Text('ORDER PLACED : $formattedCreatedDate'),
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
                                    padding:
                                        const EdgeInsets.only(bottom: 14),
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
                          _ReviewSection(booking: booking),
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
// REVIEW SECTION
// ═══════════════════════════════════════════════════════════════

class _ReviewSection extends StatelessWidget {
  final BookingFullDetailsEntity booking;

  const _ReviewSection({required this.booking});

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
              content: Text(state.message),
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
              style: TextStyle(
                fontSize: 13.spMin,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 18),

            if (state is ReviewLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: CircularProgressIndicator(),
                ),
              )
            else ...[
              // Lab review card
              _ReviewCard(
                title: booking.labName,
                subtitle: "Lab Rating",
                icon: Icons.science_rounded,
                existingRating: state is ReviewsLoaded
                    ? state.labReview?.rating
                    : null,
                existingText: state is ReviewsLoaded
                    ? state.labReview?.review
                    : null,
                isSubmitting: state is ReviewSubmitting,
                onSubmit: (rating, text) async {
                  final userId = await _getUserId(context);
                  if (!context.mounted) return;
                  if (userId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("User not found. Please re-login.")),
                    );
                    return;
                  }
                  context.read<ReviewBloc>().add(
                        SubmitLabReviewEvent(
                          SubmitLabReviewParams(
                            labId: booking.labId,
                            userId: userId,
                            rating: rating,
                            review: text.isNotEmpty ? text : null,
                          ),
                        ),
                      );
                },
              ),

              const SizedBox(height: 16),

              // Per-test review cards
              ...booking.tests.map((test) {
                LabTestReviewEntity? existingReview;
                if (state is ReviewsLoaded) {
                  existingReview = state.testReviews[test.testId];
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _ReviewCard(
                    title: test.testName,
                    subtitle: "Test Rating",
                    icon: Icons.biotech_rounded,
                    existingRating: existingReview?.rating,
                    existingText: existingReview?.review,
                    isSubmitting: state is ReviewSubmitting,
                    onSubmit: (rating, text) async {
                      final userId = await _getUserId(context);
                      if (!context.mounted) return;
                      if (userId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text("User not found. Please re-login.")),
                        );
                        return;
                      }
                      context.read<ReviewBloc>().add(
                            SubmitLabTestReviewEvent(
                              labId: booking.labId,
                              testId: test.testId,
                              userId: userId,
                              rating: rating,
                              reviewText:
                                  text.isNotEmpty ? text : null,
                            ),
                          );
                    },
                  ),
                );
              }),
            ],
          ],
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// INDIVIDUAL REVIEW CARD
// ═══════════════════════════════════════════════════════════════

class _ReviewCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final int? existingRating;
  final String? existingText;
  final bool isSubmitting;
  final void Function(int rating, String text) onSubmit;

  const _ReviewCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onSubmit,
    required this.isSubmitting,
    this.existingRating,
    this.existingText,
  });

  @override
  State<_ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<_ReviewCard> {
  late int _selectedRating;
  late TextEditingController _controller;
  bool _isEditing = false;

  static const Color primaryColor = Color(0xFF006D67);
  static const Color starColor = Color(0xFFFFB800);
  static const Color darkText = Color(0xFF10243A);

  @override
  void initState() {
    super.initState();
    _selectedRating = widget.existingRating ?? 0;
    _controller = TextEditingController(text: widget.existingText ?? '');
    _isEditing = widget.existingRating == null;
  }

  @override
  void didUpdateWidget(_ReviewCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync from bloc state after a successful submit
    if (oldWidget.existingRating != widget.existingRating && !_isEditing) {
      _selectedRating = widget.existingRating ?? _selectedRating;
      _controller.text = widget.existingText ?? _controller.text;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool alreadyReviewed = widget.existingRating != null;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: alreadyReviewed && !_isEditing
              ? const Color(0xFF006D67).withOpacity(0.35)
              : const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(widget.icon, color: primaryColor, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 15.spMin,
                          fontWeight: FontWeight.w600,
                          color: darkText,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        widget.subtitle,
                        style: TextStyle(
                          fontSize: 12.spMin,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                // Edit toggle if already reviewed
                if (alreadyReviewed)
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _isEditing = !_isEditing;
                      });
                    },
                    icon: Icon(
                      _isEditing ? Icons.close : Icons.edit,
                      size: 16,
                    ),
                    label: Text(_isEditing ? 'Cancel' : 'Edit'),
                    style: TextButton.styleFrom(
                      foregroundColor: primaryColor,
                      textStyle: TextStyle(fontSize: 13.spMin),
                      padding: EdgeInsets.zero,
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 18),

            // Star rating
            if (_isEditing || !alreadyReviewed) ...[
              Text(
                "Tap to rate",
                style: TextStyle(
                  fontSize: 12.spMin,
                  color: Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: List.generate(5, (index) {
                  final starIndex = index + 1;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedRating = starIndex;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          starIndex <= _selectedRating
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          key: ValueKey('$starIndex-${_selectedRating >= starIndex}'),
                          color: starIndex <= _selectedRating
                              ? starColor
                              : Colors.grey.shade300,
                          size: 36,
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),

              // Review text field
              TextField(
                controller: _controller,
                maxLines: 3,
                minLines: 2,
                style: TextStyle(fontSize: 14.spMin, color: darkText),
                decoration: InputDecoration(
                  hintText: "Write your review (optional)…",
                  hintStyle: TextStyle(
                    fontSize: 13.spMin,
                    color: Colors.grey.shade400,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF8F9FB),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: Colors.grey.shade200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: Colors.grey.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: primaryColor, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                ),
              ),

              const SizedBox(height: 14),

              // Submit button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: widget.isSubmitting || _selectedRating == 0
                      ? null
                      : () {
                          widget.onSubmit(
                              _selectedRating, _controller.text.trim());
                          setState(() => _isEditing = false);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    disabledBackgroundColor: Colors.grey.shade200,
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
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ] else ...[
              // Read-only display of submitted review
              Row(
                children: List.generate(
                  5,
                  (i) => Icon(
                    i < (widget.existingRating ?? 0)
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: i < (widget.existingRating ?? 0)
                        ? starColor
                        : Colors.grey.shade300,
                    size: 28,
                  ),
                ),
              ),
              if (widget.existingText != null &&
                  widget.existingText!.isNotEmpty) ...[
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FB),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    widget.existingText!,
                    style: TextStyle(
                      fontSize: 14.spMin,
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.check_circle,
                      color: Colors.green.shade600, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    "Review submitted",
                    style: TextStyle(
                      fontSize: 12.spMin,
                      color: Colors.green.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
