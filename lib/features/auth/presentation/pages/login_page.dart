import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ConsumerWidget, WidgetRef;

import '../notifier/auth_notifier.dart';
import '../widgets/login_form.dart';

class LoginPage extends ConsumerWidget {
  LoginPage({super.key});

  final emailController = TextEditingController(text: "+910123456789");
  final passwordController = TextEditingController(text: "changethis");
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authNotifierProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: LoginForm(
            emailController: emailController,
            passwordController: passwordController,
            isLoading: state.isLoading,
            error: state.error,
            onSubmit: () {
              ref
                  .read(authNotifierProvider.notifier)
                  .login(
                    email: emailController.text,
                    password: passwordController.text,
                  );
            },
          ),
        ),
      ),
    );
  }
}
