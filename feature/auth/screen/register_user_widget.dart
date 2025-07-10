import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kabast/shared/responsive/responsive_layout.dart';
import 'package:kabast/theme/app_tokens.dart';
import 'package:kabast/shared/form/custom_button.dart';
import 'package:kabast/shared/form/standard/standard_form_field.dart';
import 'package:kabast/shared/form/standard/standard_form_section.dart';
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
                    child: StandardFormSection(
                      fields: [
                        StandardFormField(
                          label: AppStrings.email,
                          child: TextFormField(
                            key: const ValueKey('register-email'),
                            onChanged: authCubit.updateLoginEmail,
                          ),
                        ),
                        StandardFormField(
                          label: AppStrings.password,
                          child: TextFormField(
                            key: const ValueKey('register-password'),
                            onChanged: authCubit.updateLoginPassword,
                            obscureText: true,
                          ),
                        ),
                        StandardFormField(
                          label: '',
                          child: CustomButton(
                            text: AppStrings.registerUser,
                            onPressed: authCubit.signUp,
                          ),
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
