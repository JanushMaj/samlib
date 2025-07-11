import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/models/grafik/grafik_element.dart';
import 'grafik_element_registry.dart';
import '../../../injection.dart';
import 'components/date_input_selector.dart';
import 'components/type_dropdown.dart';
import '../../../shared/form/custom_button.dart';
import '../../../shared/form/custom_textfield.dart';
import '../../../shared/form/standard/standard_form_field.dart';
import '../../../shared/form/standard/standard_form_section.dart';
import '../cubit/form/grafik_element_form_cubit.dart';
import '../cubit/form/grafik_element_form_state.dart';
import '../../../data/repositories/grafik_element_repository.dart';
import '../../../data/repositories/task_assignment_repository.dart';

class GrafikElementFormScreen extends StatelessWidget {
  final GrafikElement? existingElement;

  const GrafikElementFormScreen({Key? key, this.existingElement}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('[GrafikElementFormScreen] build');
    return BlocProvider(
      create: (_) => GrafikElementFormCubit(
        grafikService: getIt<GrafikElementRepository>(),
        assignmentRepository: getIt<TaskAssignmentRepository>(),
      )..initialize(existingElement),
      child: BlocConsumer<GrafikElementFormCubit, GrafikElementFormState>(
        listener: (context, state) {
          if (state is GrafikElementFormEditing && state.isSuccess) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop(true);
              }
            });
          }
        },
        builder: (context, state) {
          if (state is GrafikElementFormInitial) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (state is GrafikElementFormEditing) {
            final element = state.element;

            final dateInput = DateInputSelector(element: element);

            return Scaffold(
              appBar: AppBar(
                title: TypeDropdown(element: element),
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: StandardFormSection(
                  fields: [
                    StandardFormField(
                      label: 'Termin',
                      child: dateInput,
                    ),
                    StandardFormField(
                      label: 'Opis',
                      child: TextFormField(
                        initialValue: element.additionalInfo,
                        onChanged: (val) =>
                            context.read<GrafikElementFormCubit>().updateField('additionalInfo', val),
                      ),
                    ),
                    StandardFormField(
                      label: '',
                      child: GrafikElementRegistry.buildFormFields(element),
                    ),
                    StandardFormField(
                      label: '',
                      child: CustomButton(
                        text: 'Zapisz',
                        onPressed: state.isSubmitting
                            ? null
                            : () => context.read<GrafikElementFormCubit>().saveElement(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

}
