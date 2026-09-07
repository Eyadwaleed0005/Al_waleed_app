import 'package:al_waleed/features/authentication/presentation/widgets/login_screen_contant.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LoginScreenContant(),
    );
  }
}