import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onSubmit;
  final bool isLoading;
  final String? error;

  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.onSubmit,
    this.isLoading = false,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(labelText: 'Email'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: passwordController,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'Password'),
        ),
        const SizedBox(height: 16),

        if (error != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(error!, style: const TextStyle(color: Colors.red)),
          ),

        ElevatedButton(
          onPressed: isLoading ? null : onSubmit,
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Login'),
        ),
      ],
    );
  }
}
