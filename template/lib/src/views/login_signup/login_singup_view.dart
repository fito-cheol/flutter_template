import 'package:template/src/views/login_signup/signup_view.dart';
import 'package:template/src/views/login_signup/login_view.dart';
import 'package:flutter/material.dart';

class LoginSingupView extends StatefulWidget {
  const LoginSingupView({super.key});
  static const routeName = '/login_signup';

  @override
  State<LoginSingupView> createState() => _LoginSingupViewState();
}

class _LoginSingupViewState extends State<LoginSingupView> {
  bool showLoginPage = true;

  // toggle between login and register page
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginView(
        onTap: togglePages,
      );
    } else {
      return SignupView(
        onTap: togglePages,
      );
    }
  }
}
