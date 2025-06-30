import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/models/grafik/enums.dart';
import '../../../domain/models/grafik/grafik_element.dart';
import '../../../domain/models/grafik/grafik_element_registry.dart';
import '../../../domain/models/grafik/impl/task_planning_element.dart';
import '../../../domain/models/grafik/impl/time_issue_element.dart';
import '../../../injection.dart';
import '../../../shared/datetime/date_range_picker_button.dart';
import '../../../shared/datetime/date_time_picker_field.dart';
import '../../../shared/form/custom_button.dart';
import '../../../shared/form/custom_textfield.dart';
import '../cubit/form/grafik_element_form_cubit.dart';
import '../../../data/repositories/grafik_element_repository.dart';

class GrafikElementFormScreen extends StatelessWidget {
  final GrafikElement? existingElement;

  const GrafikElementFormScreen({Key? key, this.existingElement}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GrafikElementFormCubit(
        grafikService: getIt<GrafikElementRepository>(),
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

            // ───────────────────────────────────────────────────────────────
            //  Wybór widgetu wejściowego dla dat / trybu "Wisi i grozi"
            // ───────────────────────────────────────────────────────────────
            late final Widget dateInput;

            final bool isTaskPlanning = element is TaskPlanningElement;
            final bool isPending = isTaskPlanning
                ? (element as TaskPlanningElement).isPending
                : false;

            if (isTaskPlanning && isPending) {
              dateInput = const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Wisi i grozi – brak terminu',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              );
            } else if (isTaskPlanning ||
                (element is TimeIssueElement &&
                    element.issueType == TimeIssueType.Nieobecnosc)) {
              dateInput = DateRangePickerButton(
                initialRange: DateTimeRange(
                  start: element.startDateTime,
                  end: element.endDateTime,
                ),
                onRangeSelected: (range) {
                  context.read<GrafikElementFormCubit>()
                      .updateField('startDateTime', range.start);
                  context.read<GrafikElementFormCubit>()
                      .updateField('endDateTime', range.end);
                },
              );
            } else {
              dateInput = DateTimePickerField(
                initialDate: element.startDateTime,
                initialStartHour: element.startDateTime.hour.toDouble(),
                initialEndHour: element.endDateTime.hour.toDouble(),
                onChanged: (range) {
                  context.read<GrafikElementFormCubit>()
                      .updateField('startDateTime', range.start);
                  context.read<GrafikElementFormCubit>()
                      .updateField('endDateTime', range.end);
                },
              );
            }

            return Scaffold(
              appBar: AppBar(
                title: _buildTypeDropdown(context, element),
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

  /// Buduje DropdownButton umieszczony w AppBar, który pozwala na wybór typu elementu.
  /// Dodano ikonę strzałki w dół jako wizualny wskaźnik możliwości rozwinięcia listy.
  Widget _buildTypeDropdown(BuildContext ctx, GrafikElement element) {
    final types = GrafikElementRegistry.getRegisteredTypes();
    final mapping = {
      'TaskElement': 'Zadanie',
      'TaskPlanningElement': 'Planowane zadanie',
      'TimeIssueElement': 'Czas Pracy',
      'DeliveryPlanningElement': 'Dostawa',
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DropdownButton<String>(
          value: element.type,
          underline: const SizedBox(),
          icon: const Icon(
            Icons.arrow_drop_down,
            color: Colors.blueAccent,
            size: 42.0,
          ),
          items: types.map((t) {
            return DropdownMenuItem(
              value: t,
              child: Text(
                mapping[t] ?? t,
                style: const TextStyle(color: Colors.black),
              ),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              ctx.read<GrafikElementFormCubit>().updateField('type', val);
            }
          },
        ),
      ],
    );
  }
}
