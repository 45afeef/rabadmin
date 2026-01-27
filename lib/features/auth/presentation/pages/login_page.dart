import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ConsumerWidget, WidgetRef;

import '../controllers/login_controller.dart';
import '../widgets/login_form.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginControllerProvider);

    final emailController = TextEditingController();
    final passwordController = TextEditingController();

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
