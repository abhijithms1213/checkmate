import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:checkmate/core/constants/app_colors.dart';
import 'package:checkmate/core/widgets/buttons/elevated_btn.dart';
import 'package:checkmate/features/address/domain/entities/address_entity.dart';
import 'package:checkmate/features/address/domain/entities/user_entity.dart';
import 'package:checkmate/features/address/domain/repository/user_repo.dart';
import 'package:checkmate/features/address/presentation/bloc/user_bloc.dart';
import 'package:checkmate/features/address/presentation/bloc/user_event.dart';
import 'package:checkmate/features/address/presentation/bloc/user_state.dart';
import 'package:checkmate/features/bookings/presentation/pages/homepage.dart';
import 'package:checkmate/core/services/local_storage_service.dart';
import 'package:checkmate/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key, this.phone});

  final String? phone;

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  static const Color darkText = Color(0xFF10243A);

  final _nameController = TextEditingController();
  final _houseController = TextEditingController();
  final _addressController = TextEditingController();
  final _pincodeController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _houseController.dispose();
    _addressController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  void _saveUser() {
    if (_nameController.text.trim().isEmpty ||
        _houseController.text.trim().isEmpty ||
        _addressController.text.trim().isEmpty ||
        _pincodeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    if (widget.phone != null) {
      // New registration — create user first, address added in listener
      context.read<UserBloc>().add(
        CreateUserEvent(
          UserEntity(
            phone: widget.phone ?? '',
            name: _nameController.text.trim(),
          ),
        ),
      );
    } else {
      // Adding from profile — get userId from DB directly
      final phone = s1<LocalStorageService>().phone ?? '';
      s1<UserRepository>().getUserIdByPhone(phone).then((userId) {
        if (userId == null) return;
        context.read<UserBloc>().add(
          AddAddressEvent(
            AddressEntity(
              userId: userId,
              fullName: _nameController.text.trim(),
              houseNumber: _houseController.text.trim(),
              fullAddress: _addressController.text.trim(),
              pincode: _pincodeController.text.trim(),
              latitude: null,
              longitude: null,
              isDefault: false,
            ),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserCreated) {
          context.read<UserBloc>().add(
            AddAddressEvent(
              AddressEntity(
                userId: state.userId,
                fullName: _nameController.text.trim(),
                houseNumber: _houseController.text.trim(),
                fullAddress: _addressController.text.trim(),
                pincode: _pincodeController.text.trim(),
                latitude: null,
                longitude: null,
                isDefault: true,
              ),
            ),
          );
        }

        if (state is AddressAdded) {
          s1<LocalStorageService>().setPincode(_pincodeController.text.trim());
          if (widget.phone != null) {
            // Coming from registration — log in and go to home
            s1<LocalStorageService>().setLoggedIn(true);
            s1<LocalStorageService>().setPhone(widget.phone!);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
              (route) => false,
            );
          } else {
            // Coming from profile — just go back
            Navigator.pop(context);
          }
        }

        if (state is UserFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FB),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF8F9FB),
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Add Address",
            style: TextStyle(color: darkText, fontWeight: FontWeight.w600),
          ),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new, color: darkText),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 160,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F3F5),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 50,
                              color: AppColors.primary,
                            ),
                            SizedBox(height: 12),
                            Text(
                              "Enter your diagnostic delivery or\nservice location",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18.spMin,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      _label("Full Name"),
                      const SizedBox(height: 8),

                      _textField(
                        controller: _nameController,
                        hint: "e.g. Johnathan Doe",
                      ),

                      const SizedBox(height: 20),

                      _label("House Number"),
                      const SizedBox(height: 8),

                      _textField(
                        controller: _houseController,
                        hint: "123 ABCD",
                      ),

                      const SizedBox(height: 20),

                      _label("Full Address"),
                      const SizedBox(height: 8),

                      _textField(
                        controller: _addressController,
                        hint: "House number and street name",
                        maxLines: 3,
                      ),

                      const SizedBox(height: 20),

                      _label("Pincode"),
                      const SizedBox(height: 8),

                      _textField(
                        controller: _pincodeController,
                        hint: "695003",
                        keyboardType: TextInputType.number,
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(24),
                child: BlocBuilder<UserBloc, UserState>(
                  builder: (context, state) {
                    return ElevatedBtnWidget(
                      primaryColor: AppColors.primary,
                      content: state is UserLoading
                          ? 'Saving...'
                          : 'Save Address',
                      onTap: state is UserLoading ? () {} : _saveUser,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF1F3F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 15.spMin,
        color: Colors.black87,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
