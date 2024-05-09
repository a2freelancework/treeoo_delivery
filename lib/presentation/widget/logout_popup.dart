import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treeo_delivery/presentation/authentication/auth_bloc/auth_bloc.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({super.key});
  static Future<void> showConfirmDialog(
    BuildContext context,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return const ConfirmDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
      fontSize: 18, //20,

      color: Color(0xFF212121),
    );
    return Center(
      child: SizedBox(
        width: 450,
        child: AlertDialog(
          title:  const Text(
            'Sign out',
            style: style,
          ),
          content: Text(
            'Are you sure you want to sign out?',
            style: style.copyWith(fontSize: 15),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: style.copyWith(fontSize: 16),
              ),
              onPressed: () {
                Navigator.pop(context);
              }, // Close the dialog
            ),
            const SizedBox(width: 20),
            TextButton(
              child: Text(
                'OK',
                style: style.copyWith(fontSize: 16),
              ),
              onPressed: () {
                context.read<AuthBloc>().add(const AuthSignOutEvent());
              }, // Close the dialog
            ),
          ],
        ),
      ),
    );
  }
}
