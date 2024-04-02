import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:treeo_delivery/presentation/widget/reusable_colors.dart';

class Confirmcontainer extends StatelessWidget {
  const Confirmcontainer({
    required this.child,
    required this.color,
    required this.width,
    required this.height,
    super.key,
  });
  final Widget child;
  final Color color;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(50)),
      child: child,
    );
  }
}

class Customsafeare extends StatelessWidget {
  const Customsafeare({required this.width, required this.height, super.key});
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
    );
  }
}

// ignore: must_be_immutable
class CustomContainer extends StatelessWidget {
  CustomContainer({
    required this.heading,
    required this.icon,
    required this.subheading,
    this.onTap,
    super.key,
  });
  String heading;
  String subheading;
  final IconData icon;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width * .28,
        height: height * .13,
        decoration: BoxDecoration(
          color: peahcream,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 30,
            ),
            SizedBox(
              height: height * .01,
            ),
            Text(
              heading,
              style: GoogleFonts.roboto(
                textStyle: const TextStyle(
                  color: blackColor,
                  letterSpacing: .5,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              subheading,
              style: GoogleFonts.roboto(
                textStyle: const TextStyle(
                  color: blackColor,
                  letterSpacing: .5,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
