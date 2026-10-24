import 'package:checkmate/features/bookings/domain/entities/lab_entity.dart';
import 'package:checkmate/features/bookings/domain/entities/test_entity.dart';
import 'package:checkmate/features/reviews/domain/entities/review_entity.dart';
import 'package:checkmate/features/reviews/presentation/bloc/review_bloc.dart';
import 'package:checkmate/features/reviews/presentation/bloc/review_event.dart';
import 'package:checkmate/features/reviews/presentation/bloc/review_state.dart';
import 'package:checkmate/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class LabReviewsPage extends StatelessWidget {
  final LabEntity? lab;
  final TestEntity? test;

  const LabReviewsPage({
    super.key,
    this.lab,
    this.test,
  });

  @override
  Widget build(BuildContext context) {
    final labId = lab?.id ?? '';

    return BlocProvider(
      create: (_) =>
          s1<ReviewBloc>()..add(LoadAllLabBookingReviewsEvent(labId)),
      child: _LabReviewsView(lab: lab, test: test),
    );
  }
}

class _LabReviewsView extends StatelessWidget {
  final LabEntity? lab;
  final TestEntity? test;

  const _LabReviewsView({this.lab, this.test});

  static const Color primaryColor = Color(0xFF006D67);
  static const Color textColor = Color(0xFF101438);
  static const Color starColor = Color(0xFFFFB800);
  static const Color backgroundColor = Color(0xFFFAFAFC);

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final difference = now.difference(dt);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes.clamp(1, 60)} min ago';
      }
      return '${difference.inHours} hr ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else {
      return DateFormat('MMM d, yyyy').format(dt);
    }
  }

  @override
  Widget build(BuildContext context) {
    final labName = lab?.name ?? 'Lab Reviews';

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: textColor,
            size: 20,
          ),
        ),
        title: Text(
          labName,
          style: TextStyle(
            color: textColor,
            fontSize: 18.spMin,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<ReviewBloc, ReviewState>(
          builder: (context, state) {
            if (state is ReviewLoading || state is ReviewInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ReviewError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline_rounded,
                          size: 48, color: Colors.red.shade300),
                      const SizedBox(height: 12),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.spMin,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (lab?.id != null) {
                            context.read<ReviewBloc>().add(
                                  LoadAllLabBookingReviewsEvent(lab!.id),
                                );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Try Again',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is AllLabBookingReviewsLoaded) {
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                      child: _buildLabSummaryCard(state),
                    ),
                  ),
                  if (state.reviews.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: _buildEmptyState(
                        icon: Icons.rate_review_outlined,
                        title: "No Reviews Yet",
                        message:
                            "Be the first to review this lab after completing a booking!",
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      sliver: SliverList.separated(
                        itemCount: state.reviews.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final review = state.reviews[index];
                          return _buildReviewCard(review);
                        },
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

  Widget _buildLabSummaryCard(AllLabBookingReviewsLoaded state) {
    final avg = state.averageRating;
    final count = state.totalReviewCount;
    final labName = lab?.name ?? 'Lab';
    final labAddress = lab?.address;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF0F1F5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labName,
            style: TextStyle(
              fontSize: 20.spMin,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          if (labAddress != null && labAddress.isNotEmpty) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.location_on_outlined,
                    size: 15, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    labAddress,
                    style: TextStyle(
                      fontSize: 13.spMin,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 14),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildStars(avg, size: 22),
              Text(
                avg > 0 ? avg.toStringAsFixed(1) : 'New',
                style: TextStyle(
                  color: textColor,
                  fontSize: 18.spMin,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '($count total reviews)',
                style: TextStyle(
                  fontSize: 14.spMin,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(BookingReviewWithUserEntity review) {
    final bool isHomeCollection = review.bookingType == 'Home Collection';
    final Color badgeColor =
        isHomeCollection ? const Color(0xFF1769E8) : primaryColor;
    final String badgeText =
        isHomeCollection ? 'Home Collection' : 'Walk-in';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFECEEF2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: badgeColor.withOpacity(0.12),
                child: Text(
                  review.userName.isNotEmpty
                      ? review.userName[0].toUpperCase()
                      : 'U',
                  style: TextStyle(
                    color: badgeColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.spMin,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: TextStyle(
                        fontSize: 15.spMin,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      _formatDate(review.createdAt),
                      style: TextStyle(
                        fontSize: 12.spMin,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              // Booking type badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(
                    fontSize: 11.spMin,
                    fontWeight: FontWeight.w600,
                    color: badgeColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildStars(review.averageRating, size: 18),
              const SizedBox(width: 8),
              Text(
                review.averageRating.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 13.spMin,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
            ],
          ),
          if (review.review != null && review.review!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              review.review!,
              style: TextStyle(
                fontSize: 14.spMin,
                height: 1.45,
                color: const Color(0xFF555B69),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 56, color: Colors.grey.shade300),
            const SizedBox(height: 14),
            Text(
              title,
              style: TextStyle(
                fontSize: 16.spMin,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.spMin,
                color: Colors.grey.shade500,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStars(double rating, {double size = 20}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final difference = rating - index;
        final IconData icon;

        if (difference >= 1) {
          icon = Icons.star_rounded;
        } else if (difference >= 0.5) {
          icon = Icons.star_half_rounded;
        } else {
          icon = Icons.star_outline_rounded;
        }

        return Icon(icon, color: starColor, size: size);
      }),
    );
  }
}
