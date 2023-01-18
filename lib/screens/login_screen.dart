import 'package:blog_app/app_bloc.dart';
import 'package:blog_app/app_event.dart';
import 'package:blog_app/utils/debuging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends HookWidget {
  static const routeName = '/login-screen';

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController =
        useTextEditingController(text: 'ulugg1060@gmail.com'.ifDebuging);
    final passwordController =
        useTextEditingController(text: '12345678'.ifDebuging);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log in'),
      ),
      body: Column(
        children: [
          TextField(
            controller: emailController,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Enter your email here...',
            ),
          ),
          TextField(
            obscureText: true,
            controller: passwordController,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: 'Enter your password here...',
            ),
          ),
          TextButton(
            onPressed: () {
              final email = emailController.text;
              final password = passwordController.text;
              context.read<AppBloc>().add(
                    AppEventLogin(
                      email: email,
                      password: password,
                    ),
                  );
            },
            child: const Text('Log in'),
          ),
          TextButton(
            onPressed: () {
              context.read<AppBloc>().add(
                    const AppEventGoToRegistration(),
                  );
            },
            child: const Text('Not registered yet? register here!'),
          )
        ],
      ),
    );
  }
}
