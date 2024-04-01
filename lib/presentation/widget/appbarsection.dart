// ignore_for_file: lines_longer_than_80_chars


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:treeo_delivery/presentation/widget/reusable_colors.dart';

class AppbarSectionwithoutback extends StatelessWidget {
  const AppbarSectionwithoutback({required this.heading, super.key});
  final String heading;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Spacer(),
        Text(
          heading,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontFamily: 'Gilroy',
            fontSize: 16,
            letterSpacing: .8,
            color: blackColor,
          ),
        ),
        const Spacer(),
      ],
    );
  }
}

class AppbarSection extends StatelessWidget {
  const AppbarSection({
    required this.heading,
    super.key,
    this.onBackTap,
  });
  final String heading;
  final void Function()? onBackTap;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: width * .04,
        ),
        BackshadowContainer(
          onTap: onBackTap,
        ),
        const Spacer(),
        Text(
          heading,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontFamily: 'Gilroy',
            fontSize: 16,
            letterSpacing: .8,
            color: blackColor,
          ),
        ),
        SizedBox(
          width: width * .13,
        ),
        const Spacer(),
      ],
    );
  }
}

class BackshadowContainer extends StatelessWidget {
  const BackshadowContainer({
    super.key,
    this.onTap,
  });
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap ??
          () {
            Navigator.pop(context);
          },
      child: Container(
        width: width * .12,
        height: height * .06,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: whiteColor,
          border: Border.all(width: .5, color: const Color(0XFFB1B1B1)),
          // boxShadow: [
          //   BoxShadow(
          //     color: shadowcolor,
          //     // offset: Offset(0, 2),
          //     blurRadius: 3,
          //     spreadRadius: 1,
          //   ),
          // ],
        ),
        child: const Center(
          child: Icon(
            Icons.arrow_back_ios_new_outlined,
            size: 16,
            color: blackColor,
          ),
        ),
      ),
    );
  }
}

class OrderContainer extends StatelessWidget {
  const OrderContainer({
    required this.name,
    required this.onTap,
    super.key,
  });
  final String name;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width * .9,
        height: height * .055,
        decoration: BoxDecoration(
          color: darkgreen,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            name,
            style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                color: whiteColor,
                letterSpacing: .5,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomeContainer extends StatelessWidget {
  const CustomeContainer({
    required this.name,
    required this.containercolor,
    required this.onnTap,
    super.key,
  });
  final String name;
  final Color containercolor;
  final VoidCallback onnTap;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onnTap,
      child: Container(
        width: width * .43,
        height: height * .055,
        decoration: BoxDecoration(
          color: containercolor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            name,
            style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                color: whiteColor,
                letterSpacing: .5,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}


final phonInputFormat = [
  FilteringTextInputFormatter.allow(RegExp(r'^\d{0,10}')),
];

class CustomTextfeild extends StatelessWidget {
  const CustomTextfeild({
    required this.searchterm,
    this.prefixText,
    this.keyboardType,
    this.inputFormatters,
    this.controller,
    this.validator,
    this.readOnly = false,
    this.suffixIcon,
    super.key,
  });
  final String searchterm;
  final String? prefixText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool readOnly;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      height: height * .05,
      width: width * .9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: shadowcolor,
            // offset: Offset(0, 2),
            blurRadius: 1,
            spreadRadius: 1,
          ),
        ],
      ),
      child: TextFormField(
        cursorColor: blackColor,
        onEditingComplete: () {},
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        validator: validator,
        readOnly: readOnly,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          fillColor: whiteColor,
          filled: true,
          hintText: searchterm,
          prefixText: prefixText,
          contentPadding: const EdgeInsets.all(8),
          hintStyle: const TextStyle(fontSize: 12, color: Color(0xff6B6B6B)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: whiteColor, width: .3),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: whiteColor, width: .3),
          ),
        ),
        style: const TextStyle(
          fontSize: 12,
          height: 1,
          fontWeight: FontWeight.w400,
          color: Color(0xff6B6B6B),
        ),
        // maxLines: maxLines,
      ),
    );
  }
}

class Line extends StatelessWidget {
  const Line({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return SizedBox(
      width: width,
      height: 10,
      child: const Divider(
        color: otpgrey,
        thickness: .4,
      ),
    );
  }
}
