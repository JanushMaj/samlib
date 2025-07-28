import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/supplies/transport_plan.dart';
import '../../shared/form/custom_textfield.dart';
import '../../shared/form/enum_picker/enum_picker.dart';
import '../../theme/app_tokens.dart';
import '../cubit/form/grafik_element_form_cubit.dart';

class TransportPlanFields extends StatefulWidget {
  final TransportPlan element;
  const TransportPlanFields({Key? key, required this.element}) : super(key: key);

  @override
  State<TransportPlanFields> createState() => _TransportPlanFieldsState();
}

class _TransportPlanFieldsState extends State<TransportPlanFields> {
  late List<TransportSubTask> subtasks;

  @override
  void initState() {
    super.initState();
    subtasks = List.from(widget.element.subtasks);
  }

  @override
  void didUpdateWidget(covariant TransportPlanFields oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.element.subtasks != subtasks) {
      subtasks = List.from(widget.element.subtasks);
    }
  }

  void _notify() {
    context.read<GrafikElementFormCubit>().updateField('subtasks', subtasks);
  }

  void _addSubtask() {
    setState(() {
      subtasks.add(TransportSubTask(type: TransportSubTaskType.other, place: ''));
    });
    _notify();
  }

  void _update(int index, TransportSubTask task) {
    setState(() => subtasks[index] = task);
    _notify();
  }

  void _remove(int index) {
    setState(() => subtasks.removeAt(index));
    _notify();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<GrafikElementFormCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          label: 'Komentarz',
          initialValue: widget.element.comment,
          onChanged: (v) => cubit.updateField('comment', v),
        ),
        const SizedBox(height: AppSpacing.sm * 2),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: subtasks.length,
          itemBuilder: (context, index) {
            final st = subtasks[index];
            return _SubtaskEditor(
              key: ValueKey(index),
              subtask: st,
              onChanged: (t) => _update(index, t),
              onRemove: () => _remove(index),
            );
          },
        ),
        const SizedBox(height: AppSpacing.sm),
        Align(
          alignment: Alignment.centerLeft,
          child: ElevatedButton(
            onPressed: _addSubtask,
            child: const Text('Dodaj podzadanie'),
          ),
        ),
      ],
    );
  }
}

class _SubtaskEditor extends StatelessWidget {
  final TransportSubTask subtask;
  final ValueChanged<TransportSubTask> onChanged;
  final VoidCallback onRemove;

  const _SubtaskEditor({
    Key? key,
    required this.subtask,
    required this.onChanged,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm * 2),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          children: [
            EnumPicker<TransportSubTaskType>(
              label: 'Typ',
              values: TransportSubTaskType.values,
              initialValue: subtask.type,
              onChanged: (val) => onChanged(subtask.copyWith(type: val)),
            ),
            const SizedBox(height: AppSpacing.xs),
            CustomTextField(
              label: 'Miejsce',
              initialValue: subtask.place,
              onChanged: (v) => onChanged(subtask.copyWith(place: v)),
            ),
            const SizedBox(height: AppSpacing.xs),
            CustomTextField(
              label: 'Data (ISO, opcjonalnie)',
              initialValue:
                  subtask.dateTime != null ? subtask.dateTime!.toIso8601String() : '',
              onChanged: (v) => onChanged(
                subtask.copyWith(
                  dateTime: v.isEmpty ? null : DateTime.tryParse(v),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            CustomTextField(
              label: 'Powiązane zlecenie',
              initialValue: subtask.relatedOrderId ?? '',
              onChanged: (v) =>
                  onChanged(subtask.copyWith(relatedOrderId: v.isEmpty ? null : v)),
            ),
            const SizedBox(height: AppSpacing.xs),
            CustomTextField(
              label: 'Notatka',
              initialValue: subtask.note ?? '',
              onChanged: (v) =>
                  onChanged(subtask.copyWith(note: v.isEmpty ? null : v)),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: onRemove,
              ),
            )
          ],
        ),
      ),
    );
  }
}
