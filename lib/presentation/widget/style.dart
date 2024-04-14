// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:treeo_delivery/presentation/widget/reusable_colors.dart';

const tStyle15 = TextStyle(
  fontWeight: FontWeight.w500,
  fontFamily: 'Gilroy',
  fontSize: 14,
  letterSpacing: .4,
  color: otpgrey,
);
const tStyle15W600 = TextStyle(
  fontWeight: FontWeight.w600,
  fontFamily: 'Gilroy',
  fontSize: 14,
  letterSpacing: .4,
  color: blackColor,
);

final priceFormat = [
  FilteringTextInputFormatter.allow(RegExp(r'^\d{0,10}(\.\d{0,2})?'),),
];
