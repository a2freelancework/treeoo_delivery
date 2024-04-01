// ignore_for_file: lines_longer_than_80_chars

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treeo_delivery/core/services/injection_container.dart';
import 'package:treeo_delivery/core/utils/snack_bar.dart';
import 'package:treeo_delivery/firebase_options.dart';
import 'package:treeo_delivery/presentation/authentication/auth_bloc/auth_bloc.dart';
import 'package:treeo_delivery/presentation/authentication/forgot_password_page.dart';
import 'package:treeo_delivery/presentation/authentication/login_page.dart';
import 'package:treeo_delivery/presentation/authentication/sign_up_page.dart';
import 'package:treeo_delivery/presentation/screens/deliverydashboard.dart';
import 'package:treeo_delivery/presentation/screens/select_location_screen.dart';
import 'package:treeo_delivery/presentation/screens/vehicleselection.dart';
import 'package:treeo_delivery/presentation/widget/reusable_colors.dart';

// https://www.youtube.com/watch?v=WvGHJef7O-g

///   dart fix --apply --code=unused_import


// UserAuth.I.currentUser

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => authBloc..add(AuthEventInitialize()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: darkgreen),
          useMaterial3: true,
        ),
        home: const AuthPage(),
      ),
    );
  }
}

class NewWidgetIcon extends StatelessWidget {
  const NewWidgetIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.add_a_photo);
  }
}

class AuthPage extends StatelessWidget {
  const AuthPage({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (_, state) {
        if (state is AuthVerificationSentState ||
            state is AuthError ||
            state is AuthLoading) {
          return false;
        }
        return true;
      },
      builder: (context, state) {
        if (state is AuthLoggedIn) {
          if (state.isVehicleSelected) {
            if (state.isLocationSelected) {
              return const DeliveryDashboard();
            } else {
              return const SelectLocation();
            }
          } else {
            return const VehicleSelection();
          }
        } else if (state is AuthNeedVerification || state is AuthLoggedOut) {
          return const LoginScreen();
        } else if (state is AuthRegisterScreenState) {
          return const UserRegisterScreen();
        } else if (state is AuthForgotPasswordScreenState) {
          return const ForgotPasswordScreen();
        } else {
          return const AuthSplash();
        }
      },
    );
  }
}

class AuthSplash extends StatelessWidget {
  const AuthSplash({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listenWhen: (_, state) => state is AuthError,
        listener: (context, state) {
          if (state is AuthError) {
            AppSnackBar.showSnackBar(context, state.message);
          }
        },
        child: const Center(
          child: Text('Loading...'),
        ),
      ),
    );
  }
}

const iconPath = 'https://firebasestorage.googleapis.com/v0/b/treoo-database.appspot.com/o/category_icon%2Fcardbod.png?alt=media&token=473bdf59-f194-473c-a43d-ff9908123488';

/*
flutter build ipa --release
flutter build appbundle --release
*/
