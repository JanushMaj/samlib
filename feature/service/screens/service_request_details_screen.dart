import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../data/repositories/service_request_repository.dart';
import '../../../domain/models/grafik/impl/service_request_element.dart';
import '../../auth/auth_cubit.dart';
import '../cubit/service_request_details_cubit.dart';
import '../../../shared/form/custom_textfield.dart';
import '../../../shared/form/enum_picker/enum_picker.dart';
import '../../../shared/form/minutes_picker/minutes_picker_field.dart';
import '../../../shared/form/small_number_picker/small_number_picker.dart';
import '../../../shared/form/standard/standard_form_field.dart';
import '../../../shared/form/standard/standard_form_section.dart';
import '../../../shared/responsive/responsive_layout.dart';

class ServiceRequestDetailsScreen extends StatelessWidget {
  final ServiceRequestElement request;
  const ServiceRequestDetailsScreen({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ServiceRequestDetailsCubit(
        GetIt.I<ServiceRequestRepository>(),
        request,
      ),
      child: const _ServiceRequestDetailsView(),
    );
  }
}

class _ServiceRequestDetailsView extends StatelessWidget {
  const _ServiceRequestDetailsView();

  @override
  Widget build(BuildContext context) {
    final canEdit = context.select<AuthCubit, bool>((cubit) =>
        cubit.currentUser?.effectivePermissions['canEditServiceRequests'] ??
        false);
    return BlocListener<ServiceRequestDetailsCubit, ServiceRequestDetailsState>(
      listener: (context, state) {
        if (state.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Zapisano zgłoszenie')),
          );
        } else if (state.errorMsg != null && !state.isSubmitting) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMsg!),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      child: BlocBuilder<ServiceRequestDetailsCubit, ServiceRequestDetailsState>(
        builder: (context, state) {
          final cubit = context.read<ServiceRequestDetailsCubit>();
          return ResponsiveScaffold(
            appBar: AppBar(
              title: Text('Zgłoszenie ${state.orderNumber}'),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: StandardFormSection(
                fields: [
                  StandardFormField(
                    label: 'Lokalizacja',
                    child: canEdit
                        ? CustomTextField(
                            label: 'Lokalizacja',
                            initialValue: state.location,
                            onChanged: cubit.setLocation,
                          )
                        : Text(state.location),
                  ),
                  StandardFormField(
                    label: 'Nr zlecenia',
                    child: canEdit
                        ? CustomTextField(
                            label: 'Nr zlecenia',
                            initialValue: state.orderNumber,
                            onChanged: cubit.setOrderNumber,
                          )
                        : Text(state.orderNumber),
                  ),
                  StandardFormField(
                    label: 'Pilność',
                    child: canEdit
                        ? EnumPicker<ServiceUrgency>(
                            label: '',
                            values: ServiceUrgency.values,
                            initialValue: state.urgency,
                            onChanged: cubit.setUrgency,
                          )
                        : Text(state.urgency.name),
                  ),
                  StandardFormField(
                    label: 'Opis',
                    child: canEdit
                        ? TextField(
                            minLines: 2,
                            maxLines: 5,
                            onChanged: cubit.setDescription,
                            controller:
                                TextEditingController(text: state.description),
                            decoration: const InputDecoration(labelText: 'Opis'),
                          )
                        : Text(state.description),
                  ),
                  StandardFormField(
                    label: 'Czas trwania',
                    child: canEdit
                        ? MinutesPickerField(
                            minutes: state.durationMinutes,
                            onChanged: cubit.setDurationMinutes,
                          )
                        : Text('${state.durationMinutes} min'),
                  ),
                  StandardFormField(
                    label: 'Liczba osób',
                    child: canEdit
                        ? SmallNumberPicker(
                            initialValue: state.peopleCount,
                            min: 1,
                            onChanged: cubit.setPeopleCount,
                          )
                        : Text('${state.peopleCount}'),
                  ),
                  if (canEdit)
                    StandardFormField(
                      label: '',
                      child: ElevatedButton(
                        onPressed: state.isSubmitting ? null : cubit.save,
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
