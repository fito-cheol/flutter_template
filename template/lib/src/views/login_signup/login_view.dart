import 'package:template/src/axios/auth.dart';
import 'package:flutter/material.dart';

import '../../components/my_button.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key, required this.onTap});
  final Function()? onTap;

  static const routeName = '/login';

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signInUser() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
    try {
      login(emailController.text, passwordController.text);
      Navigator.pop(context); // pop loading circle
      genericSuccessMessage('로그인 성공');
    } on Exception catch (e) {
      Navigator.pop(context); // pop loading circle
      genericErrorMessage(e.toString());
    }
  }

  void genericSuccessMessage(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(message),
            content: const Text(''),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            backgroundColor: Colors.green,
            actions: <Widget>[
              TextButton(
                child: const Text('확인'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  void genericErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          backgroundColor: Colors.red,
          title: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('로그인'),
        ),
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SingleChildScrollView(
              child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SizedBox(
                height: 50,
              ),
              const Icon(
                Icons.lock_person,
                size: 150,
              ),
              const SizedBox(height: 10),
              const Text(
                '온더 닷 플래닛',
                style: TextStyle(
                  color: Color.fromARGB(255, 90, 89, 89),
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 25),
              TextField(
                controller: emailController,
                obscureText: false,
                decoration: const InputDecoration.collapsed(hintText: '아이디'),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration.collapsed(hintText: '비밀번호'),
                obscureText: true,
              ),
              const SizedBox(height: 15),
              MyButton(
                onTap: signInUser,
                text: 'Sign In',
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Forgot your login details? ',
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    ),
                    Text(
                      'Get help logging in.',
                      style: TextStyle(
                        color: Colors.blue.shade900,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Not a member? ',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      'Register now',
                      style: TextStyle(
                          color: Colors.blue[900],
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  ),
                ],
              )
            ]),
          )),
        ));
  }
}
