import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:treeo_delivery/screens/vehicleselection.dart';
import 'package:treeo_delivery/widget/reusable_colors.dart';
import 'package:treeo_delivery/widget/reusablewidgets.dart';

class LoginSection extends StatefulWidget {
  const LoginSection({super.key});

  @override
  State<LoginSection> createState() => _LoginSectionState();
}

class _LoginSectionState extends State<LoginSection> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: whiteColor,
      body: Padding(
        padding: EdgeInsets.only(left: width * .05, right: width * .05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(),
            Text(
              Appname,
              style: GoogleFonts.roboto(
                textStyle: const TextStyle(
                    color: darkgreen,
                    letterSpacing: .5,
                    fontSize: 40,
                    fontWeight: FontWeight.w600),
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Staff ID",
                style: GoogleFonts.roboto(
                  textStyle: const TextStyle(
                      color: darkgreen,
                      letterSpacing: .5,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(
              height: height * .01,
            ),
            SizedBox(
              height: height * .06,
              width: width,
              child: TextField(
                cursorColor: blackColor,
                // controller: _emailController,
                decoration: InputDecoration(
                  fillColor: whiteColor,
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: subtext, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: subtext, width: 1),
                  ),
                ),
                style: const TextStyle(
                  fontSize: 18.0,
                  height: 1,
                  color: blackColor,
                ),
                // maxLines: maxLines,
              ),
            ),
            SizedBox(
              height: height * .02,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Password",
                style: GoogleFonts.roboto(
                  textStyle: const TextStyle(
                      color: darkgreen,
                      letterSpacing: .5,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(
              height: height * .01,
            ),
            SizedBox(
              width: width,
              height: height * .06,
              child: TextField(
                // controller: _passwordController,
                cursorColor: blackColor,
                obscureText: _isObscure,
                decoration: InputDecoration(
                  fillColor: whiteColor,
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: subtext, width: 1),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: subtext, width: 1),
                  ),
                ),
                style: const TextStyle(
                  fontSize: 18.0,
                  height: 1,
                  color: blackColor,
                ),
                // maxLines: maxLines,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const VehicleSelection()),
                );
              },
              child: Confirmcontainer(
                width: width * .8,
                height: height * .07,
                color: darkgreen,
                child: Center(
                  child: Text(
                    "Login",
                    style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                          color: whiteColor,
                          letterSpacing: .5,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Managed By Treeoo with ",
                  style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                        color: darkgreen,
                        letterSpacing: .5,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                const Icon(
                  Icons.favorite,
                  color: darkgreen,
                  size: 17,
                )
              ],
            ),
            SizedBox(
              height: height * .08,
            )
          ],
        ),
      ),
    );
  }
}
