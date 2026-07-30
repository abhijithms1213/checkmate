import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:checkmate/core/constants/app_colors.dart';
import 'package:checkmate/core/widgets/buttons/elevated_btn.dart';
import 'package:checkmate/features/address/domain/entities/address_entity.dart';
import 'package:checkmate/features/address/presentation/bloc/user_bloc.dart';
import 'package:checkmate/features/address/presentation/bloc/user_event.dart';
import 'package:checkmate/features/address/presentation/bloc/user_state.dart';
import 'package:checkmate/core/services/local_storage_service.dart';
import 'package:checkmate/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditAddressScreen extends StatefulWidget {
  const EditAddressScreen({
    super.key,
    required this.address,
  });

  final AddressEntity address;

  @override
  State<EditAddressScreen> createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
  static const Color darkText = Color(0xFF10243A);

  late final TextEditingController _nameController;
  late final TextEditingController _houseController;
  late final TextEditingController _addressController;
  late final TextEditingController _pincodeController;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.address.fullName);
    _houseController =
        TextEditingController(text: widget.address.houseNumber);
    _addressController =
        TextEditingController(text: widget.address.fullAddress);
    _pincodeController =
        TextEditingController(text: widget.address.pincode);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _houseController.dispose();
    _addressController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  void _save() {
    if (_nameController.text.trim().isEmpty ||
        _houseController.text.trim().isEmpty ||
        _addressController.text.trim().isEmpty ||
        _pincodeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final updated = widget.address.copyWith(
      fullName: _nameController.text.trim(),
      houseNumber: _houseController.text.trim(),
      fullAddress: _addressController.text.trim(),
      pincode: _pincodeController.text.trim(),
    );

    final phone = s1<LocalStorageService>().phone ?? '';
    context
        .read<UserBloc>()
        .add(EditAddressEvent(address: updated, phone: phone));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is AddressUpdated) {
          Navigator.pop(context);
        }
        if (state is UserFailure) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FB),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF8F9FB),
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Edit Address",
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
                        height: 120,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F3F5),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.edit_location_alt_outlined,
                              size: 44,
                              color: AppColors.primary,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Update your address details",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15.spMin,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      _label("Full Name"),
                      const SizedBox(height: 8),
                      _textField(controller: _nameController, hint: "e.g. Johnathan Doe"),

                      const SizedBox(height: 20),

                      _label("House Number"),
                      const SizedBox(height: 8),
                      _textField(controller: _houseController, hint: "123 ABCD"),

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
                      content: state is UserLoading ? 'Saving...' : 'Save Changes',
                      onTap: state is UserLoading ? () {} : _save,
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
    final isNumber = keyboardType == TextInputType.number;
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      maxLength: isNumber ? 6 : null,
      inputFormatters: isNumber ? [FilteringTextInputFormatter.digitsOnly] : null,
      decoration: InputDecoration(
        counterText: "", // Hide the character counter below the field
        hintStyle: const TextStyle(color: Colors.black38),
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
