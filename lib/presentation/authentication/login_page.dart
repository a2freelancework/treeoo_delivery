// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:treeo_delivery/core/services/injection_container.dart';
import 'package:treeo_delivery/core/utils/snack_bar.dart';
import 'package:treeo_delivery/presentation/authentication/auth_bloc/auth_bloc.dart';
import 'package:treeo_delivery/presentation/authentication/widgets/auth_page_texts.dart';
import 'package:treeo_delivery/presentation/authentication/widgets/custom_textform_field.dart';
import 'package:treeo_delivery/presentation/widget/reusable_colors.dart';
import 'package:treeo_delivery/presentation/widget/reusablewidgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isObscure = true;

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _email;
  late final TextEditingController _passwd;
  final emailPass = DP.emailPasswordAuth;
  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
    _passwd = TextEditingController();

    final authState = context.read<AuthBloc>().state;
    if (authState is AuthLoggedOut) {
      _email.text = authState.email;
      _passwd.text = authState.password;
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: whiteColor,
      body: Padding(
        padding: EdgeInsets.only(left: width * .07, right: width * .07),
        child: Form(
          key: _formKey,
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
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Email',
                  style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                      color: darkgreen,
                      letterSpacing: .5,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * .01,
              ),
              SizedBox(
                width: width,
                height: height * .06,
                child: IField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    if (val == null || !emailRegex.hasMatch(val)) {
                      return 'Invalid email address';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: height * .02),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Password',
                  style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                      color: darkgreen,
                      letterSpacing: .5,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * .01,
              ),
              SizedBox(
                width: width,
                height: height * .06,
                child: IField(
                  controller: _passwd,
                  obscureText: _isObscure,
                  showSuffixIcon: true,
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                ),
              ),
              const Spacer(),
              BlocConsumer<AuthBloc, AuthState>(
                listenWhen: (_, state) => state is AuthError,
                listener: (context, state) {
                  debugPrint('*******>   $state');
                  if (state is AuthError) {
                    AppSnackBar.showSnackBar(context, state.message,
                        durationInSec: 6,);
                  }
                },
                buildWhen: (_, state) =>
                    state is AuthError || state is AuthLoading,
                builder: (context, state) {
                  if (state is AuthLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return GestureDetector(
                    onTap: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        FocusManager.instance.primaryFocus?.unfocus();
                        context.read<AuthBloc>().add(AuthLoginEvent(
                              email: _email.text,
                              password: _passwd.text,
                            ),);
                      }
                    },
                    child: Confirmcontainer(
                      width: width * .8,
                      height: height * .07,
                      color: darkgreen,
                      child: Center(
                        child: Text(
                          'Login',
                          style: GoogleFonts.roboto(
                            textStyle: const TextStyle(
                              color: whiteColor,
                              letterSpacing: .5,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  context.read<AuthBloc>().add(AuthGoToForgotPasswordScreen());
                },
                child: const AuthPageTexts(text: 'Forgote password?'),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  context.read<AuthBloc>().add(AuthGoToRegisterScreen());
                },
                child: const AuthPageTexts(text: "don't have an account? Register"),
              ),
              SizedBox(height: height * .05),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AuthPageTexts(text: 'Managed By Treeoo with '),
                  Icon(
                    Icons.favorite,
                    color: darkgreen,
                    size: 17,
                  ),
                ],
              ),
              SizedBox(
                height: height * .05,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _email.dispose();
    _passwd.dispose();
    super.dispose();
  }
}
