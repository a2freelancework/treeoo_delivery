import 'package:flutter/material.dart';
import 'package:treeo_delivery/presentation/widget/reusable_colors.dart';
import 'package:treeo_delivery/presentation/widget/style.dart';

class LabeledInputField extends StatelessWidget {
  const LabeledInputField({
    required this.label,
    this.keyboardType = TextInputType.number,
    this.controller,
    this.onChanged,
    this.onTapOutside,
    super.key,
  });
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final String label;
  final void Function(PointerDownEvent)? onTapOutside;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: tStyle15W600,
        ),
        SizedBox(
          height: height * .06,
          width: width * 0.35,
          child: InputField(
            controller: controller,
            keyboardType: keyboardType,
            onTapOutside: onTapOutside,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

class InputField extends StatelessWidget {
  const InputField({
    this.controller,
    this.onTapOutside,
    this.onChanged,
    this.keyboardType = TextInputType.number,
    super.key,
  });

  final TextEditingController? controller;
  final TextInputType keyboardType;
  final void Function(PointerDownEvent p1)? onTapOutside;
  final void Function(String p1)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: blackColor,
      controller: controller,
      keyboardType: keyboardType,
      onTapOutside: onTapOutside,
      decoration: InputDecoration(
        fillColor: whiteColor,
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: subtext),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: subtext),
        ),
      ),
      onChanged: onChanged,

      style: const TextStyle(
        fontSize: 13,
        height: 1,
        color: blackColor,
      ),
      // maxLines: maxLines,
    );
  }
}
