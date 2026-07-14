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
    return Container(
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
            children: [
              Expanded(
                child: Text(
                  lab.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // Container(
              //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              //   decoration: BoxDecoration(
              //     color: const Color(0xffDFF7F3),
              //     borderRadius: BorderRadius.circular(6),
              //   ),
              //   child: Row(
              //     children: [
              //       const Icon(Icons.star, size: 14, color: Color(0xff0A7A72)),
              //       const SizedBox(width: 3),
              //       Text(
              //         lab.rating,
              //         style: const TextStyle(
              //           color: Color(0xff0A7A72),
              //           fontWeight: FontWeight.w600,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // if (lab.trusted) ...[
              //   const SizedBox(width: 8),
              //   Container(
              //     padding: const EdgeInsets.symmetric(
              //       horizontal: 8,
              //       vertical: 4,
              //     ),
              //     decoration: BoxDecoration(
              //       color: const Color(0xff0B1E33),
              //       borderRadius: BorderRadius.circular(5),
              //     ),
              //     child: const Text(
              //       "TRUSTED",
              //       style: TextStyle(
              //         color: Colors.white,
              //         fontSize: 11,
              //         fontWeight: FontWeight.w600,
              //       ),
              //     ),
              //   ),
              // ],
            ],
          ),

          const SizedBox(height: 8),

          Text(
            lab.description ?? "Nearby Location",
            style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
          ),

          const SizedBox(height: 14),

          // Wrap(
          //   spacing: 18,
          //   runSpacing: 8,
          //   children: lab.features
          //       .map(
          //         (e) => Row(
          //           mainAxisSize: MainAxisSize.min,
          //           children: [
          //             const Text(
          //               "•",
          //               style: TextStyle(
          //                 color: Color(0xff0A7A72),
          //                 fontWeight: FontWeight.bold,
          //               ),
          //             ),
          //             const SizedBox(width: 4),
          //             Text(e, style: TextStyle(color: Colors.grey.shade700)),
          //           ],
          //         ),
          //       )
          //       .toList(),
          // ),
          Divider(height: 28, color: const Color.fromARGB(255, 215, 215, 215)),

          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Rs ${lab.price}",
                    style: const TextStyle(
                      fontSize: 28,
                      color: Color(0xff0A7A72),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "TOTAL PRICE",
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
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
    );
  }
}
