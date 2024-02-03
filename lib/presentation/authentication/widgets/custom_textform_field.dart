import 'package:flutter/material.dart';
import 'package:treeo_delivery/presentation/widget/reusable_colors.dart';

class IField extends StatelessWidget {
  const IField({
    super.key,
    this.controller,
    this.validator,
    this.keyboardType,
    this.onPressed,
    this.obscureText = false,
    this.showSuffixIcon = false,
  });
  final TextEditingController? controller;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final void Function()? onPressed;
  final bool showSuffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorColor: blackColor,
      obscureText: obscureText,
      validator: validator,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        fillColor: whiteColor,
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: subtext),
        ),
        suffixIcon: showSuffixIcon ? IconButton(
          icon: Icon(
            obscureText ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
            size: 20,
          ),
          onPressed: onPressed,
        ) : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: subtext),
        ),
      ),
      style: const TextStyle(
        fontSize: 18,
        height: 1,
        color: blackColor,
      ),
      // maxLines: maxLines,
    );
  }
}

RegExp emailRegex = RegExp(
  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
);
