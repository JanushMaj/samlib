import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../data/repositories/service_request_repository.dart';
import '../../auth/auth_cubit.dart';
import '../../auth/screen/no_access_screen.dart';
import '../cubit/service_request_form_cubit.dart';
import '../../../shared/form/custom_textfield.dart';
import '../../../shared/form/enum_picker/enum_picker.dart';
import '../../../shared/form/standard/standard_form_field.dart';
import '../../../shared/form/standard/standard_form_section.dart';
import '../../../domain/models/grafik/enums.dart';

class ServiceRequestFormScreen extends StatelessWidget {
  const ServiceRequestFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthCubit>().currentUser;
    final hasPermission =
        user?.effectivePermissions['canCreateServiceTasks'] ?? false;
    if (user == null || !hasPermission) {
      return const NoAccessScreen();
    }

    return BlocProvider(
      create: (_) => ServiceRequestFormCubit(
        GetIt.I<ServiceRequestRepository>(),
      ),
      child: const _ServiceRequestFormView(),
    );
  }
}

class _ServiceRequestFormView extends StatelessWidget {
  const _ServiceRequestFormView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ServiceRequestFormCubit, ServiceRequestFormState>(
      listener: (context, state) {
        if (state.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Zgłoszenie zapisane')),
          );
          Navigator.of(context).pop();
        } else if (state.errorMsg != null && !state.isSubmitting) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMsg!),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      child: BlocBuilder<ServiceRequestFormCubit, ServiceRequestFormState>(
        builder: (context, state) {
          final cubit = context.read<ServiceRequestFormCubit>();
          return Scaffold(
            appBar: AppBar(
              title: const Text('Nowe zlecenie serwisowe'),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: StandardFormSection(
                fields: [
                  StandardFormField(
                    label: 'Lokalizacja',
                    child: CustomTextField(
                      label: 'Lokalizacja',
                      initialValue: state.location,
                      onChanged: cubit.setLocation,
                    ),
                  ),
                  StandardFormField(
                    label: 'Nr zlecenia',
                    child: CustomTextField(
                      label: 'Nr zlecenia',
                      initialValue: state.orderNumber,
                      onChanged: cubit.setOrderNumber,
                    ),
                  ),
                  StandardFormField(
                    label: 'Pilność',
                    child: EnumPicker<ServiceUrgency>(
                      label: '',
                      values: ServiceUrgency.values,
                      initialValue: state.urgency,
                      onChanged: cubit.setUrgency,
                    ),
                  ),
                  StandardFormField(
                    label: 'Opis',
                    child: TextField(
                      minLines: 2,
                      maxLines: 5,
                      onChanged: cubit.setDescription,
                      decoration: const InputDecoration(labelText: 'Opis'),
                    ),
                  ),
                  StandardFormField(
                    label: '',
                    child: ElevatedButton(
                      onPressed: state.isSubmitting
                          ? null
                          : () {
                              final user =
                                  context.read<AuthCubit>().currentUser;
                              if (user != null) {
                                cubit.save(user.id);
                              }
                            },
                      child: const Text('Zapisz'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
