import 'package:checkmate/core/constants/app_colors.dart';
import 'package:checkmate/core/services/local_storage_service.dart';
import 'package:checkmate/features/address/presentation/bloc/user_bloc.dart';
import 'package:checkmate/features/address/presentation/bloc/user_event.dart';
import 'package:checkmate/features/address/presentation/pages/address_list.dart';
import 'package:checkmate/features/appointments/presentation/pages/appointment_list.dart';
import 'package:checkmate/features/bookings/presentation/bloc/labs/labs_bloc.dart';
import 'package:checkmate/features/bookings/presentation/bloc/labs/labs_event.dart';
import 'package:checkmate/features/bookings/presentation/pages/homepage.dart';
import 'package:checkmate/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const MyAppointmentsScreen(),
    const AddressScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final phone = s1<LocalStorageService>().phone ?? '';
    final pincode = s1<LocalStorageService>().pincode ?? '';

    return MultiBlocProvider(
      providers: [
        BlocProvider<LabsBloc>(
          create: (_) => s1<LabsBloc>()..add(GetTestsEvent(pincode)),
        ),
        BlocProvider<UserBloc>(
          create: (_) => s1<UserBloc>()..add(LoadAddressesEvent(phone)),
        ),
      ],
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.science_outlined),
              label: 'Labs',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined),
              label: 'Appointments',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
