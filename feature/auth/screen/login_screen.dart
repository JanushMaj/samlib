import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kabast/shared/responsive/responsive_layout.dart';
import 'package:kabast/theme/app_tokens.dart';
import '../auth_cubit.dart';
import '../auth_state.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print('[LoginScreen] build');
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
      child: ResponsiveScaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ResponsivePadding(
                small: EdgeInsets.all(AppSpacing.sm * 4),
                medium: EdgeInsets.all(AppSpacing.sm * 6),
                large: EdgeInsets.all(AppSpacing.sm * 8),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                    maxWidth: 400,
                  ),
                child: Center(
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
                            onPressed: () => authCubit.signIn(),
                            child: const Text(AppStrings.login),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
          },
        ),
      ),
    );
  }
}
