import 'package:flutter/material.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  static const Color primaryColor = Color(0xFF006D67);
  static const Color darkText = Color(0xFF10243A);

  int selectedType = 0;

  final addressTypes = [
    "Home",
    "Office",
    "Other",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FB),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Add Address",
          style: TextStyle(
            color: darkText,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: darkText,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
              color: darkText,
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    /// Location Placeholder
                    Container(
                      height: 160,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F3F5),
                        borderRadius:
                            BorderRadius.circular(16),
                      ),
                      child: const Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 50,
                            color: primaryColor,
                          ),
                          SizedBox(height: 12),
                          Text(
                            "Enter your diagnostic delivery or\nservice location",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
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
                      hint: "e.g. Johnathan Doe",
                    ),

                    const SizedBox(height: 24),

                    _label("Street Address"),
                    const SizedBox(height: 8),

                    _textField(
                      hint:
                          "House number and street name",
                    ),

                    const SizedBox(height: 24),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              _label("City"),
                              const SizedBox(height: 8),
                              _textField(
                                hint: "San Francisco",
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 16),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              _label("State"),
                              const SizedBox(height: 8),
                              _textField(
                                hint: "California",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    _label("ZIP Code"),
                    const SizedBox(height: 8),

                    _textField(
                      hint: "94103",
                    ),

                    const SizedBox(height: 36),

                    _label("Address Type"),

                    const SizedBox(height: 12),

                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F3F5),
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: List.generate(
                          addressTypes.length,
                          (index) {
                            final selected =
                                selectedType == index;

                            return Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedType =
                                        index;
                                  });
                                },
                                child: Container(
                                  height: 42,
                                  decoration:
                                      BoxDecoration(
                                    color: selected
                                        ? Colors.white
                                        : Colors
                                            .transparent,
                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                      10,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      addressTypes[
                                          index],
                                      style:
                                          TextStyle(
                                        color: selected
                                            ? primaryColor
                                            : Colors
                                                .black87,
                                        fontWeight:
                                            FontWeight
                                                .w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// Bottom Button
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        12,
                      ),
                    ),
                  ),
                  onPressed: () {},
                  icon: const Icon(
                    Icons.check_circle_outline,
                    color: Colors.white,
                  ),
                  label: const Text(
                    "Save Address",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textField({
    required String hint,
  }) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF1F3F5),
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        color: Colors.black87,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}