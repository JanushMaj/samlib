import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kabast/theme/app_tokens.dart';
import 'package:kabast/feature/auth/auth_cubit.dart';
import 'package:kabast/feature/auth/auth_state.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final theme = Theme.of(context);

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppStrings.signInError),
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
              Image.asset(
                AppAssets.logoGradient,
                height: 100,
                semanticLabel: AppStrings.logoAlt,
              ),
              const SizedBox(height: AppSpacing.sm * 3),
              TextField(
                key: const ValueKey('login-email'),
                onChanged: authCubit.updateLoginEmail,
                decoration: const InputDecoration(labelText: AppStrings.email),
              ),
              const SizedBox(height: AppSpacing.sm * 3),
              TextField(
                key: const ValueKey('login-password'),
                onChanged: authCubit.updateLoginPassword,
                obscureText: true,
                decoration: const InputDecoration(labelText: AppStrings.password),
              ),
              const SizedBox(height: AppSpacing.sm * 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: authCubit.signIn,
                    child: const Text(AppStrings.login),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
