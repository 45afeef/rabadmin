import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ConsumerWidget, WidgetRef;

import '../controllers/auth_controller.dart';
import '../widgets/login_form.dart';

class LoginPage extends ConsumerWidget {
  LoginPage({super.key});

  final emailController = TextEditingController(text: "+910123456789");
  final passwordController = TextEditingController(text: "changethis");
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authControllerProvider);

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
                  .read(authControllerProvider.notifier)
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
