import 'package:checkmate/core/constants/app_colors.dart';
import 'package:checkmate/core/widgets/logo_with_back_btn.dart';
import 'package:checkmate/features/bookings/domain/entities/test_entity.dart';
import 'package:checkmate/features/bookings/presentation/pages/payment.dart';
import 'package:checkmate/features/bookings/presentation/widgets/date_tile.dart';
import 'package:checkmate/features/bookings/domain/entities/lab_entity.dart';
import 'package:checkmate/features/bookings/presentation/bloc/labs/labs_bloc.dart';
import 'package:checkmate/features/bookings/presentation/bloc/labs/labs_event.dart';
import 'package:checkmate/features/bookings/presentation/bloc/labs/labs_state.dart';
import 'package:checkmate/features/address/presentation/bloc/user_bloc.dart';
import 'package:checkmate/features/address/presentation/bloc/user_event.dart';
import 'package:checkmate/core/services/local_storage_service.dart';
import 'package:checkmate/injection_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SelectSlotScreen extends StatefulWidget {
  const SelectSlotScreen({super.key, required this.labs, required this.test});
  final LabEntity labs;
  final TestEntity test;
  @override
  State<SelectSlotScreen> createState() => _SelectSlotScreenState();
}

class _SelectSlotScreenState extends State<SelectSlotScreen> {
  int selectedDate = 0;

  String? selectedSlotId;
  String? selectedTime;

  late List<Map<String, String>> dates;

  @override
  void initState() {
    super.initState();
    context.read<LabsBloc>().add(GetSlotsByLabIdEvent(widget.labs.id));
    dates = List.generate(30, (index) {
      final date = DateTime.now().add(Duration(days: index));
      return {
        "day": DateFormat('E').format(date).toUpperCase(),
        "date": DateFormat('d').format(date),
        "fullDate": date.toIso8601String(),
      };
    });
  }

  static const Color darkBlue = Color(0xFF081E36);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F9FB),

      bottomNavigationBar: Container(
        height: 72,
        padding: const EdgeInsets.all(12),
        color: AppColors.primary,
        child: Center(
          child: InkWell(
            onTap: () {
              if (selectedTime == null || selectedSlotId == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please select a time slot')),
                );
                return;
              }
              final phone = s1<LocalStorageService>().phone ?? '';
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (_) => s1<UserBloc>()..add(LoadAddressesEvent(phone)),
                      ),
                      BlocProvider(
                        create: (_) => s1<LabsBloc>(),
                      ),
                    ],
                    child: ReviewPayScreen(
                      labs: widget.labs,
                      test: widget.test,
                      selectedDate: dates[selectedDate]['fullDate']!,
                      selectedTime: selectedTime!,
                      selectedSlotId: selectedSlotId!,
                    ),
                  ),
                ),
              );
            },
            child: Text(
              "CONFIRM APPOINTMENT",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                letterSpacing: 1,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              CmpnyNameWithBackBtnWidget(isPadding: false),
              const SizedBox(height: 30),

              const Text(
                "Select Appointment Slot",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: darkBlue,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Full Blood Count & Lipid Profile",
                style: TextStyle(color: Colors.grey.shade700, fontSize: 18),
              ),

              const SizedBox(height: 28),

              /// Date Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          DateFormat('MMMM yyyy').format(
                            DateTime.parse(dates[selectedDate]["fullDate"]!),
                          ),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    SizedBox(
                      height: 80,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: dates.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final selected = selectedDate == index;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedDate = index;
                              });
                            },
                            child: DateTileWidget(
                              selected: selected,
                              dates: dates,
                              index: index,
                            ),
                            // child: Container(
                            //   width: 72,
                            //   decoration: BoxDecoration(
                            //     color: selected ? darkBlue : Colors.white,
                            //     borderRadius: BorderRadius.circular(12),
                            //     border: Border.all(color: Colors.grey.shade300),
                            //   ),
                            //   child: Column(
                            //     mainAxisAlignment: MainAxisAlignment.center,
                            //     children: [
                            //       Text(
                            //         dates[index]["day"]!,
                            //         style: TextStyle(
                            //           color: selected
                            //               ? Colors.white
                            //               : Colors.grey,
                            //         ),
                            //       ),
                            //       const SizedBox(height: 4),
                            //       Text(
                            //         dates[index]["date"]!,
                            //         style: TextStyle(
                            //           fontSize: 28,
                            //           fontWeight: FontWeight.bold,
                            //           color: selected
                            //               ? Colors.white
                            //               : Colors.black,
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// Slots
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: BlocBuilder<LabsBloc, LabsState>(
                  builder: (context, state) {
                    if (state is LabsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is LabsError) {
                      return Center(child: Text(state.message));
                    } else if (state is SlotsLoaded) {
                      if (state.slots.isEmpty) {
                        return const Center(child: Text("No slots available"));
                      }

                      // Format slots
                      final formattedSlots = state.slots.map((s) {
                        return {
                          "id": s.id,
                          "time": s
                              .slotTime, // Assuming it's already a formatted string or easily displayable
                          "isActive": s.isActive,
                        };
                      }).toList();

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: formattedSlots.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 14,
                              crossAxisSpacing: 14,
                              childAspectRatio: 2.2,
                            ),
                        itemBuilder: (context, index) {
                          final slot = formattedSlots[index];
                          final timeStr = slot["time"] as String;
                          final disabled = !(slot["isActive"] as bool);
                          final selected = selectedTime == timeStr;

                          return GestureDetector(
                            onTap: disabled
                                ? null
                                : () {
                                    setState(() {
                                      selectedTime = timeStr;
                                      selectedSlotId = slot["id"] as String;
                                    });
                                  },
                            child: Container(
                              decoration: BoxDecoration(
                                color: selected
                                    ? AppColors.primary
                                    : disabled
                                    ? const Color(0xffF3F4F6)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Center(
                                child: Text(
                                  timeStr,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: selected
                                        ? Colors.white
                                        : disabled
                                        ? Colors.grey
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),

              const SizedBox(height: 30),

              Divider(color: Colors.grey.shade300),

              const SizedBox(height: 20),

              const Text(
                "BOOKING DETAILS",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                  letterSpacing: 1,
                ),
              ),

              const SizedBox(height: 18),

              Text("Lab: ${widget.labs.name}", style: TextStyle(fontSize: 18)),

              const SizedBox(height: 8),

              Text(
                "Date: ${DateFormat('EEEE, MMMM d').format(DateTime.parse(dates[selectedDate]["fullDate"]!))}",
                style: const TextStyle(fontSize: 18),
              ),

              const SizedBox(height: 8),

              Text("Time: ${selectedTime ?? 'Not selected'}", style: const TextStyle(fontSize: 18)),

              const SizedBox(height: 8),

              Text(
                "Total: ${widget.labs.price} Rs",
                style: TextStyle(fontSize: 18),
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
