// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';

extension NavigationExt<T> on BuildContext {
  Future<T?> push(Widget widget) =>
      Navigator.push(this, MaterialPageRoute(builder: (_) => widget));

  Future<T?> pushReplacement(Widget widget) => Navigator.pushReplacement(
        this,
        MaterialPageRoute(builder: (_) => widget),
      );

  Future<T?> pushAndRemoveUntil(Widget widget) => Navigator.pushAndRemoveUntil(
        this,
        MaterialPageRoute(builder: (_) => widget),
        (route) => false,
      );

  Size get mqSize => MediaQuery.of(this).size;

  double get mqWidth => mqSize.width;
  double get mqHeight => mqSize.height;
}
