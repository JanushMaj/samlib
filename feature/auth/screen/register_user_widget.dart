import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kabast/theme/app_tokens.dart';
import '../auth_cubit.dart';
import '../auth_state.dart';

class RegisterUserWidget extends StatelessWidget {
  const RegisterUserWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final theme = Theme.of(context);

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: theme.colorScheme.error,
            ),
          );
        }
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm * 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                key: const ValueKey('register-email'),
                onChanged: authCubit.updateLoginEmail,
                decoration: const InputDecoration(labelText: AppStrings.email),
              ),
              const SizedBox(height: AppSpacing.sm * 3),
              TextField(
                key: const ValueKey('register-password'),
                onChanged: authCubit.updateLoginPassword,
                obscureText: true,
                decoration: const InputDecoration(labelText: AppStrings.password),
              ),
              const SizedBox(height: AppSpacing.sm * 6),
              ElevatedButton(
                onPressed: authCubit.signUp,
                child: const Text(AppStrings.registerUser),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
