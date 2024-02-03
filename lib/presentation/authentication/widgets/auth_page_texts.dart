
// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:treeo_delivery/presentation/widget/reusable_colors.dart';

class AuthPageTexts extends StatelessWidget {
  const AuthPageTexts({
    required this.text,
    super.key,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.roboto(
        textStyle: const TextStyle(
          color: darkgreen,
          letterSpacing: .5,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

RegExp _emailRegex = RegExp(
  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
);
