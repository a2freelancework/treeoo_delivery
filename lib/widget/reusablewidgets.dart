import 'package:flutter/material.dart';

class Confirmcontainer extends StatelessWidget {
  final Widget child;
  final Color color;
  final double width;
  final double height;

  const Confirmcontainer(
      {required this.child,
      required this.color,
      required this.width,
      required this.height,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: child,
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(50)),
    );
  }
}

class Customsafeare extends StatelessWidget {
  final double width;
  final double height;

  const Customsafeare({required this.width, required this.height, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
    );
  }
}
