import 'package:checkmate/features/bookings/presentation/pages/lab_details.dart';
import 'package:checkmate/features/reviews/domain/entities/review_entity.dart';
import 'package:checkmate/features/reviews/presentation/bloc/review_bloc.dart';
import 'package:checkmate/features/reviews/presentation/bloc/review_event.dart';
import 'package:checkmate/features/reviews/presentation/bloc/review_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:checkmate/core/constants/app_colors.dart';
import 'package:checkmate/core/widgets/buttons/elevated_btn.dart';
import 'package:checkmate/features/bookings/domain/entities/test_entity.dart';
import 'package:checkmate/features/bookings/presentation/pages/book_lab.dart';
import 'package:checkmate/features/bookings/presentation/pages/slot_select.dart';
import 'package:flutter/material.dart';

import 'package:checkmate/features/bookings/domain/entities/lab_entity.dart';
import 'package:checkmate/features/bookings/presentation/bloc/labs/labs_bloc.dart';
import 'package:checkmate/injection_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LabCard extends StatelessWidget {
  final LabEntity lab;
  final TestEntity test;

  const LabCard({super.key, required this.lab, required this.test});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => s1<ReviewBloc>()..add(LoadLabRatingSummaryEvent(lab.id)),
      child: _LabCardContent(lab: lab, test: test),
    );
  }
}

class _LabCardContent extends StatelessWidget {
  final LabEntity lab;
  final TestEntity test;

  const _LabCardContent({required this.lab, required this.test});

  Widget _buildRatingBadge(LabRatingSummaryEntity? summary, bool isLoading) {
    if (isLoading) {
      return const SizedBox.shrink();
    }

    if (summary == null || summary.reviewCount == 0) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.star_outline_rounded,
              size: 14,
              color: Colors.grey.shade500,
            ),
            const SizedBox(width: 4),
            Text(
              "New",
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 12.spMin,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xffDFF7F3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 15, color: Color(0xff0A7A72)),
          const SizedBox(width: 3),
          Text(
            summary.averageRating.toStringAsFixed(1),
            style: TextStyle(
              color: const Color(0xff0A7A72),
              fontSize: 12.spMin,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            "(${summary.reviewCount})",
            style: TextStyle(
              color: const Color(0xff0A7A72).withOpacity(0.8),
              fontSize: 11.spMin,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStarRow(double rating) {
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

        return Icon(icon, color: const Color(0xFFFFB800), size: 16);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReviewBloc, ReviewState>(
      builder: (context, state) {
        final bool isLoading = state is ReviewLoading || state is ReviewInitial;
        final LabRatingSummaryEntity? summary = state is LabRatingSummaryLoaded
            ? state.summary
            : null;

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => LabReviewsPage(lab: lab, test: test),
              ),
            ).then((_) {
              // Refresh rating summary using BLoC on return
              context.read<ReviewBloc>().add(LoadLabRatingSummaryEvent(lab.id));
            });
          },
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        lab.name,
                        style: TextStyle(
                          fontSize: 20.spMin,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildRatingBadge(summary, isLoading),
                  ],
                ),

                const SizedBox(height: 6),

                // Star row + review count
                if (!isLoading &&
                    summary != null &&
                    summary.reviewCount > 0) ...[
                  Row(
                    children: [
                      _buildStarRow(summary.averageRating),
                      const SizedBox(width: 6),
                      Text(
                        "${summary.averageRating.toStringAsFixed(1)} • ${summary.reviewCount} ${summary.reviewCount == 1 ? 'review' : 'reviews'}",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12.spMin,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                ],

                if (lab.description != null) ...[
                  Text(
                    lab.description!,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 16.spMin,
                    ),
                  ),
                ],

                Divider(
                  height: 28,
                  color: const Color.fromARGB(255, 215, 215, 215),
                ),

                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Rs ${lab.price}",
                          style: TextStyle(
                            fontSize: 28.spMin,
                            color: const Color(0xff0A7A72),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "TOTAL PRICE",
                          style: TextStyle(
                            fontSize: 11.spMin,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),
                    SizedBox(
                      width: 100,
                      height: 40,
                      child: ElevatedBtnWidget(
                        primaryColor: AppColors.primary,
                        content: 'Book',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) => s1<LabsBloc>(),
                                child: SelectSlotScreen(labs: lab, test: test),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
