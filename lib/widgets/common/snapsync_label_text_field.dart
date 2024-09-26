import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SnapSyncLabelTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String hintText;
  final bool isReadOnly;
  final String? errorText;
  final String? Function(String?)? validator;

  const SnapSyncLabelTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.isReadOnly = false,
    this.errorText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final defaultBorderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.0),
      borderSide: BorderSide.none,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Gap(8.0),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          cursorColor: Colors.deepPurple,
          cursorWidth: 2.5,
          cursorHeight: 18.0,
          readOnly: isReadOnly,
          style: const TextStyle(
            color: Colors.black,
          ),
          validator: validator,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade200,
            enabledBorder: defaultBorderStyle,
            focusedBorder: defaultBorderStyle,
            hintText: hintText,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 32.0,
            ),
          ),
        ),
      ],
    );
  }
}
