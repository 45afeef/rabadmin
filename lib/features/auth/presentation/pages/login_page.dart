import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/login_controller.dart';
import '../widgets/login_form.dart';

class LoginPage extends ConsumerWidget {
  LoginPage({super.key});

  final emailController = TextEditingController(text: "admin@example.com");
  final passwordController = TextEditingController(text: "changethis");

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginControllerProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: LoginForm(
          emailController: emailController,
          passwordController: passwordController,
          isLoading: state.isLoading,
          error: state.error,
          onSubmit: () {
            ref
                .read(loginControllerProvider.notifier)
                .login(
                  email: emailController.text,
                  password: passwordController.text,
                );
          },
        ),
      ),
    );
  }
}
