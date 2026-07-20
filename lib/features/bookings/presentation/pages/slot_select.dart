import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:checkmate/core/constants/app_colors.dart';
import 'package:checkmate/core/widgets/logo_with_back_btn.dart';
import 'package:checkmate/features/bookings/domain/entities/test_entity.dart';
import 'package:checkmate/features/bookings/presentation/pages/payment.dart';
import 'package:checkmate/features/bookings/presentation/widgets/date_tile.dart';
import 'package:checkmate/features/bookings/domain/entities/lab_entity.dart';
import 'package:checkmate/features/bookings/presentation/bloc/labs/labs_bloc.dart';
import 'package:checkmate/features/bookings/presentation/bloc/labs/labs_event.dart';
import 'package:checkmate/features/bookings/presentation/bloc/labs/labs_state.dart';
import 'package:checkmate/features/bookings/presentation/bloc/collection_type/collection_type_bloc.dart';
import 'package:checkmate/features/bookings/presentation/bloc/collection_type/collection_type_event.dart';
import 'package:checkmate/features/bookings/presentation/bloc/collection_type/collection_type_state.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CollectionTypeBloc(),
      child: _SelectSlotBody(
        labs: widget.labs,
        test: widget.test,
        dates: dates,
        selectedDate: selectedDate,
        selectedSlotId: selectedSlotId,
        selectedTime: selectedTime,
        onDateChanged: (i) => setState(() => selectedDate = i),
        onSlotChanged: (id, time) => setState(() {
          selectedSlotId = id;
          selectedTime = time;
        }),
      ),
    );
  }
}

class _SelectSlotBody extends StatelessWidget {
  const _SelectSlotBody({
    required this.labs,
    required this.test,
    required this.dates,
    required this.selectedDate,
    required this.selectedSlotId,
    required this.selectedTime,
    required this.onDateChanged,
    required this.onSlotChanged,
  });

  final LabEntity labs;
  final TestEntity test;
  final List<Map<String, String>> dates;
  final int selectedDate;
  final String? selectedSlotId;
  final String? selectedTime;
  final void Function(int) onDateChanged;
  final void Function(String id, String time) onSlotChanged;

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
              final collectionState = context.read<CollectionTypeBloc>().state;
              if (collectionState is! CollectionTypeSelected) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please select a sample collection type')),
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
                      labs: labs,
                      test: test,
                      selectedDate: dates[selectedDate]['fullDate']!,
                      selectedTime: selectedTime!,
                      selectedSlotId: selectedSlotId!,
                      collectionType: collectionState.label,
                    ),
                  ),
                ),
              );
            },
            child: Text(
              "CONFIRM APPOINTMENT",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.spMin,
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

              Text(
                "Select Appointment Slot",
                style: TextStyle(
                  fontSize: 36.spMin,
                  fontWeight: FontWeight.bold,
                  color: darkBlue,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Full Blood Count & Lipid Profile",
                style: TextStyle(color: Colors.grey.shade700, fontSize: 18.spMin),
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
                          style: TextStyle(
                            fontSize: 20.spMin,
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
                            onTap: () => onDateChanged(index),
                            child: DateTileWidget(
                              selected: selected,
                              dates: dates,
                              index: index,
                            ),
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
                            //           fontSize: 28.spMin,
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
                                : () => onSlotChanged(slot["id"] as String, timeStr),
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
                                    fontSize: 16.spMin,
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

              //--------------------------------------------------
              // SAMPLE COLLECTION TYPE WIDGET
              //--------------------------------------------------
              Text(
                "SAMPLE COLLECTION",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14.spMin,
                  letterSpacing: 1,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                "Do you need sample collection at home?",
                style: TextStyle(
                  fontSize: 18.spMin,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF081E36),
                ),
              ),

              const SizedBox(height: 14),

              BlocBuilder<CollectionTypeBloc, CollectionTypeState>(
                builder: (context, collectionState) {
                  final isHome = collectionState is CollectionTypeSelected
                      ? collectionState.isHomeCollection
                      : null;
                  return Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => context
                              .read<CollectionTypeBloc>()
                              .add(SelectCollectionTypeEvent(true)),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: isHome == true
                                  ? AppColors.primary
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isHome == true
                                    ? AppColors.primary
                                    : Colors.grey.shade300,
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.home_outlined,
                                  color: isHome == true
                                      ? Colors.white
                                      : Colors.grey.shade600,
                                  size: 28,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "Yes",
                                  style: TextStyle(
                                    fontSize: 16.spMin,
                                    fontWeight: FontWeight.w600,
                                    color: isHome == true
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                                Text(
                                  "Home Collection",
                                  style: TextStyle(
                                    fontSize: 13.spMin,
                                    color: isHome == true
                                        ? Colors.white70
                                        : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => context
                              .read<CollectionTypeBloc>()
                              .add(SelectCollectionTypeEvent(false)),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: isHome == false
                                  ? AppColors.primary
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isHome == false
                                    ? AppColors.primary
                                    : Colors.grey.shade300,
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.local_hospital_outlined,
                                  color: isHome == false
                                      ? Colors.white
                                      : Colors.grey.shade600,
                                  size: 28,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "No",
                                  style: TextStyle(
                                    fontSize: 16.spMin,
                                    fontWeight: FontWeight.w600,
                                    color: isHome == false
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                                Text(
                                  "Walk-in",
                                  style: TextStyle(
                                    fontSize: 13.spMin,
                                    color: isHome == false
                                        ? Colors.white70
                                        : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 20),

              Divider(color: Colors.grey.shade300),

              const SizedBox(height: 20),

              Text(
                "BOOKING DETAILS",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14.spMin,
                  letterSpacing: 1,
                ),
              ),

              SizedBox(height: 18),

              Text("Lab: ${labs.name}", style: TextStyle(fontSize: 18.spMin)),

              const SizedBox(height: 8),

              Text(
                "Date: ${DateFormat('EEEE, MMMM d').format(DateTime.parse(dates[selectedDate]["fullDate"]!))}",
                style: TextStyle(fontSize: 18.spMin),
              ),

              SizedBox(height: 8),

              Text("Time: ${selectedTime ?? 'Not selected'}", style: TextStyle(fontSize: 18.spMin)),

              const SizedBox(height: 8),

              Text(
                "Total: ${labs.price} Rs",
                style: TextStyle(fontSize: 18.spMin),
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
