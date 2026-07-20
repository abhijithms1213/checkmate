import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:checkmate/core/services/local_storage_service.dart';
import 'package:checkmate/core/widgets/button.dart';
import 'package:checkmate/features/address/domain/entities/address_entity.dart';
import 'package:checkmate/features/address/presentation/bloc/user_bloc.dart';
import 'package:checkmate/features/address/presentation/bloc/user_event.dart';
import 'package:checkmate/features/address/presentation/bloc/user_state.dart';
import 'package:checkmate/features/address/presentation/pages/addres_add.dart';
import 'package:checkmate/features/auth/presentation/pages/login.dart';
import 'package:checkmate/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  static const Color primaryColor = Color(0xFF006D67);
  static const Color darkText = Color(0xFF10243A);

  @override
  Widget build(BuildContext context) {
    final phone = s1<LocalStorageService>().phone ?? '';

    return BlocProvider(
      create: (_) => s1<UserBloc>()..add(LoadAddressesEvent(phone)),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FB),
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 40), // balance the logout icon
                    Expanded(
                      child: Text(
                        "My Profile",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.spMin,
                          fontWeight: FontWeight.w600,
                          color: darkText,
                        ),
                      ),
                    ),
                    Builder(
                      builder: (ctx) => IconButton(
                        tooltip: 'Log Out',
                        icon: const Icon(
                          Icons.logout_rounded,
                          color: Colors.redAccent,
                        ),
                        onPressed: () async {
                          await s1<LocalStorageService>().clear();
                          if (ctx.mounted) {
                            Navigator.pushAndRemoveUntil(
                              ctx,
                              MaterialPageRoute(
                                builder: (_) => const LoginScreen(),
                              ),
                              (route) => false,
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: BlocConsumer<UserBloc, UserState>(
                  listener: (context, state) {
                    if (state is UserFailure) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.message)));
                    }
                  },
                  builder: (context, state) {
                    if (state is UserLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    List<AddressEntity> addresses = [];
                    if (state is AddressesLoaded) {
                      addresses = state.addresses;
                    }

                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Text(
                            "Saved Addresses",
                            style: TextStyle(
                              fontSize: 24.spMin,
                              fontWeight: FontWeight.bold,
                              color: darkText,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Manage your sample collection locations",
                            style: TextStyle(
                              fontSize: 15.spMin,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 24),

                          if (addresses.isEmpty && state is! UserLoading)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 40,
                                ),
                                child: Text(
                                  "No addresses saved yet.",
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 16.spMin,
                                  ),
                                ),
                              ),
                            ),

                          ...addresses.map(
                            (address) => Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _AddressCard(
                                address: address,
                                phone: phone,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          SizedBox(
                            width: double.infinity,
                            height: 64,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context)
                                    .push(
                                      MaterialPageRoute(
                                        // phone: null → user already exists, just add address
                                        builder: (_) =>
                                            const AddAddressScreen(),
                                      ),
                                    )
                                    .then((_) {
                                      context.read<UserBloc>().add(
                                        LoadAddressesEvent(phone),
                                      );
                                    });
                              },
                              label: Text(
                                "Add New Address",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.spMin,
                                ),
                              ),
                            ),
                          ),



                          const SizedBox(height: 24),
                        ],
                      ),
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
}

class _AddressCard extends StatelessWidget {
  final AddressEntity address;
  final String phone;

  const _AddressCard({required this.address, required this.phone});

  static const Color primaryColor = Color(0xFF006D67);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: address.isDefault
              ? primaryColor.withOpacity(0.4)
              : const Color(0xFFE5E7EB),
          width: address.isDefault ? 1.5 : 1,
        ),
        boxShadow: address.isDefault
            ? [
                BoxShadow(
                  color: primaryColor.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on_outlined, color: primaryColor, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  address.fullName,
                  style: TextStyle(
                    fontSize: 18.spMin,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (address.isDefault)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF82E6D8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Default",
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 13.spMin,
                    ),
                  ),
                ),
              if (!address.isDefault) ...[
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _showDeleteConfirm(context, address.id!, phone),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.delete_outline,
                      color: Colors.red.shade400,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 12),

          Text(
            '${address.houseNumber}, ${address.fullAddress}',
            style: TextStyle(fontSize: 15.spMin, color: Colors.grey.shade700),
          ),

          const SizedBox(height: 4),

          Text(
            'Pincode: ${address.pincode}',
            style: TextStyle(fontSize: 14.spMin, color: Colors.grey.shade500),
          ),

          if (!address.isDefault) ...[
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                s1<LocalStorageService>().setPincode(address.pincode);
                context.read<UserBloc>().add(
                  SetDefaultAddressEvent(
                    addressId: address.id!,
                    userId: address.userId,
                    phone: phone,
                  ),
                );
              },
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: primaryColor,
                    size: 18,
                  ),
                  SizedBox(width: 4),
                  Text(
                    "Set as Default",
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 14.spMin,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showDeleteConfirm(
    BuildContext context,
    String addressId,
    String phone,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Address"),
        content: const Text("Are you sure you want to delete this address?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<UserBloc>().add(
                DeleteAddressEvent(addressId: addressId, phone: phone),
              );
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
