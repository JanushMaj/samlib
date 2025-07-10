import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../theme/app_tokens.dart';
import '../../shared/responsive/responsive_layout.dart';
import '../../shared/form/custom_button.dart';
import '../../data/repositories/employee_repository.dart';
import '../auth/auth_cubit.dart';
import "../../data/repositories/app_user_repository.dart";
import '../employee/employee_picker.dart';

class AssignEmployeeScreen extends StatefulWidget {
  const AssignEmployeeScreen({super.key});

  @override
  State<AssignEmployeeScreen> createState() => _AssignEmployeeScreenState();
}

class _AssignEmployeeScreenState extends State<AssignEmployeeScreen> {
  String? _selectedId;

  @override
  Widget build(BuildContext context) {
    final employeeStream = GetIt.I<EmployeeRepository>().getEmployees();
    return ResponsiveScaffold(
      appBar: AppBar(title: const Text(AppStrings.assignEmployeeTitle)),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ResponsivePadding(
              small: const EdgeInsets.all(16),
              medium: const EdgeInsets.all(24),
              large: const EdgeInsets.all(32),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    EmployeePicker(
                      employeeStream: employeeStream,
                      singleSelection: true,
                      initialSelectedIds: _selectedId == null ? [] : [_selectedId!],
                      onSelectionChanged: (employees) {
                        setState(() {
                          _selectedId = employees.isNotEmpty ? employees.first.uid : null;
                        });
                      },
                    ),
                    const SizedBox(height: AppSpacing.sm * 6),
                    CustomButton(
                      text: AppStrings.assignMe,
                      onPressed: _selectedId == null
                          ? null
                          : () async {
                              final user = context.read<AuthCubit>().currentUser;
                              if (user != null) {
                                final updated = user.copyWith(employeeId: _selectedId);
                                await GetIt.I<AppUserRepository>().saveUser(updated);
                              }
                              if (mounted) Navigator.of(context).pop();
                            },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
