import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/models/grafik/grafik_element.dart';
import 'grafik_element_registry.dart';
import '../../../injection.dart';
import 'components/date_input_selector.dart';
import 'components/type_dropdown.dart';
import '../../../shared/form/custom_button.dart';
import '../../../shared/form/custom_textfield.dart';
import '../cubit/form/grafik_element_form_cubit.dart';
import '../../../domain/services/i_grafik_element_service.dart';

class GrafikElementFormScreen extends StatelessWidget {
  final GrafikElement? existingElement;

  const GrafikElementFormScreen({Key? key, this.existingElement}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GrafikElementFormCubit(
        grafikService: getIt<IGrafikElementService>(),
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
                child: Column(
                  children: [
                    dateInput,
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Opis',
                      initialValue: element.additionalInfo,
                      onChanged: (val) =>
                          context.read<GrafikElementFormCubit>().updateField('additionalInfo', val),
                    ),
                    const SizedBox(height: 16),
                    GrafikElementRegistry.buildFormFields(element),
                    const SizedBox(height: 16),
                    CustomButton(
                      text: 'Zapisz',
                      onPressed: state.isSubmitting
                          ? null
                          : () => context.read<GrafikElementFormCubit>().saveElement(),
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
