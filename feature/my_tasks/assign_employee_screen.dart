import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/repositories/employee_repository.dart';
import '../../data/repositories/app_user_repository.dart';
import '../auth/auth_cubit.dart';
import '../employee/employee_picker.dart';
import '../../shared/form/custom_button.dart';
import '../../shared/responsive/responsive_layout.dart';
import '../../theme/app_tokens.dart';

class MyTasksAssignEmployeeScreen extends StatefulWidget {
  const MyTasksAssignEmployeeScreen({super.key});

  @override
  State<MyTasksAssignEmployeeScreen> createState() =>
      _MyTasksAssignEmployeeScreenState();
}

class _MyTasksAssignEmployeeScreenState
    extends State<MyTasksAssignEmployeeScreen> {
  String? _selectedId;
  String? _errorText;

  Future<bool> _isEmployeeInUse(String employeeId, String currentUid) async {
    final firestore = GetIt.I<FirebaseFirestore>();
    final query = await firestore
        .collection('users')
        .where('employeeId', isEqualTo: employeeId)
        .get();
    for (final doc in query.docs) {
      if (doc.id != currentUid) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    print('[MyTasksAssignEmployeeScreen] build');
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
                          _selectedId =
                              employees.isNotEmpty ? employees.first.uid : null;
                          _errorText = null;
                        });
                      },
                    ),
                    if (_errorText != null) ...[
                      const SizedBox(height: AppSpacing.sm * 3),
                      Text(
                        _errorText!,
                        style: TextStyle(color: Theme.of(context).colorScheme.error),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: AppSpacing.sm * 6),
                    CustomButton(
                      text: AppStrings.assignMe,
                      onPressed: _selectedId == null
                          ? null
                          : () async {
                              final user = context.read<AuthCubit>().currentUser;
                              if (user == null) return;
                              final inUse =
                                  await _isEmployeeInUse(_selectedId!, user.id);
                              if (inUse) {
                                if (mounted) {
                                  setState(() {
                                    _errorText = AppStrings.employeeAlreadyAssigned;
                                  });
                                }
                                return;
                              }
                              final updated = user.copyWith(employeeId: _selectedId);
                              await GetIt.I<AppUserRepository>().saveUser(updated);
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
